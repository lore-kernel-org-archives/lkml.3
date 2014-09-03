Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932886AbaICPdv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 11:33:51 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:57672 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbaICPdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 11:33:50 -0400
Message-ID: <540734DE.6090306@gmail.com>
Date: Wed, 03 Sep 2014 23:33:50 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: nab@linux-iscsi.org
CC: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Simek <monstr@monstr.eu>
Subject: [PATCH] drivers/target/target_core_transport.c: Fix typo issue to
 use 'buf' instead of 'len'
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is a typo issue, need use 'buf' instead of 'len', the related warning
with allmodconfig under microblaze:

drivers/target/target_core_transport.c: In function ‘transport_dump_vpd_ident_type’:
drivers/target/target_core_transport.c:956:9: warning: passing argument 1 of ‘strlen’ makes pointer from integer without a cast
   len = strlen(len);
         ^
In file included from include/linux/bitmap.h:8:0,
                 from include/linux/cpumask.h:11,
                 from include/linux/mm_types.h:12,
                 from include/linux/kmemcheck.h:4,
                 from include/linux/net.h:25,
                 from drivers/target/target_core_transport.c:26:
include/linux/string.h:83:24: note: expected ‘const char *’ but argument is of type ‘int’
 extern __kernel_size_t strlen(const char *);
                        ^

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 drivers/target/target_core_transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 1dd1181..3ce85ed 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -953,7 +953,7 @@ int transport_dump_vpd_ident_type(
 		strlcat(buf, "SCSI name string\n", sizeof(buf));
 		break;
 	default:
-		len = strlen(len);
+		len = strlen(buf);
 		snprintf(&buf[len], sizeof(buf) - len, "Unsupported: 0x%02x\n",
 				vpd->device_identifier_type);
 		ret = -EINVAL;
-- 
1.9.3
