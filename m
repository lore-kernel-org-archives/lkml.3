Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933360Ab3GMOkt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 10:40:49 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:56925 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933198Ab3GMOkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 10:40:47 -0400
Message-ID: <1373726446.1359.17.camel@x61.thuisdomein>
Subject: [PATCH] staging/lustre/libcfs: fix typo "default false"
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Sat, 13 Jul 2013 16:40:46 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Jul 2013 14:40:46.0683 (UTC) FILETIME=[F5F9A2B0:01CE7FD6]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 4b5b4c7222 ("staging/lustre/libcfs: restore LINVRNT") added
"default false" to this Kconfig file. It was obviously meant to use
"default n" here.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Tested lightly, with "make menuconfig" only.

1) No-one noticed because "default <invalid Kconfig symbol>" and
"default n" behave the same. Actually, it seems "default n" isn't needed
at all. But there are hundreds of Kconfig symbols that use "default n",
so I suppose it serves some purpose.

 drivers/staging/lustre/lustre/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/Kconfig b/drivers/staging/lustre/lustre/Kconfig
index e0eb830..002dd2e 100644
--- a/drivers/staging/lustre/lustre/Kconfig
+++ b/drivers/staging/lustre/lustre/Kconfig
@@ -43,7 +43,7 @@ config LUSTRE_OBD_MAX_IOCTL_BUFFER
 config LUSTRE_DEBUG_EXPENSIVE_CHECK
 	bool "Enable Lustre DEBUG checks"
 	depends on LUSTRE_FS
-	default false
+	default n
 	help
 	  This option is mainly for debug purpose. It enables Lustre code to do
 	  expensive checks that may have a performance impact.
-- 
1.8.1.4

