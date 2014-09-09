Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135AbaIIHYG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 03:24:06 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:44069 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756014AbaIIHYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 03:24:04 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers: target: target_core_transport.c: build warning
Date: Tue,  9 Sep 2014 12:53:50 +0530
Message-Id: <1410247430-11293-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

build is giving : 
warning: passing argument 1 of 'strlen' makes pointer from integer 
without a cast [enabled by default]

the snprintf after the strlen is trying to put the "Unsupported" string
at the end of exising string. so len should give the string length here

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
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
1.8.1.2

