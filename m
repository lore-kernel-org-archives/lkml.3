Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047AbaDZKQ5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 06:16:57 -0400
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:20483 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbaDZKQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 06:16:55 -0400
X-ME-Helo: localhost
X-ME-Date: Sat, 26 Apr 2014 12:16:52 +0200
X-ME-IP: 92.151.74.103
Message-ID: <ddc9a5694b311c48d5f5f82d3b56d022@mwinf5d14.me-wanadoo.net>
From: Thomas Vegas <thomas_75@safe-mail.net>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org
Cc: daeseok.youn@gmail.com
Cc: sachin.kamat@linaro.org
Cc: shaun@XResource.ca
Cc: ebru.akagunduz@gmail.com
Cc: dulshani.gunawardhana89@gmail.com
Date: Sat, 26 Apr 2014 11:20:09 +0200
Subject: [PATCH] staging: cxt1e1: Avoid using 0 instead of NULL
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the following sparse warnings:

drivers/staging/cxt1e1/hwprobe.c:162:38:
	warning: Using plain integer as NULL pointer
drivers/staging/cxt1e1/hwprobe.c:163:38:
	warning: Using plain integer as NULL pointer
drivers/staging/cxt1e1/hwprobe.c:179:46:
	warning: Using plain integer as NULL pointer
drivers/staging/cxt1e1/hwprobe.c:184:46:
	warning: Using plain integer as NULL pointer

Signed-off-by: Thomas Vegas <thomas_75@safe-mail.net>
---
 drivers/staging/cxt1e1/hwprobe.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/cxt1e1/hwprobe.c b/drivers/staging/cxt1e1/hwprobe.c
index cc2151e..4fa27c8 100644
--- a/drivers/staging/cxt1e1/hwprobe.c
+++ b/drivers/staging/cxt1e1/hwprobe.c
@@ -159,8 +159,8 @@ prep_hdw_info(void)
 		hi->ndev = NULL;
 		hi->addr[0] = 0L;
 		hi->addr[1] = 0L;
-		hi->addr_mapped[0] = 0L;
-		hi->addr_mapped[1] = 0L;
+		hi->addr_mapped[0] = NULL;
+		hi->addr_mapped[1] = NULL;
 	}
 }
 
@@ -176,12 +176,12 @@ cleanup_ioremap(void)
 		if (hi->addr_mapped[0]) {
 			iounmap(hi->addr_mapped[0]);
 			release_mem_region((long) hi->addr[0], hi->len[0]);
-			hi->addr_mapped[0] = 0;
+			hi->addr_mapped[0] = NULL;
 		}
 		if (hi->addr_mapped[1]) {
 			iounmap(hi->addr_mapped[1]);
 			release_mem_region((long) hi->addr[1], hi->len[1]);
-			hi->addr_mapped[1] = 0;
+			hi->addr_mapped[1] = NULL;
 		}
 	}
 }
-- 
1.8.3.2

