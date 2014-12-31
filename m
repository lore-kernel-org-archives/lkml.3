Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749AbaLaL15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 06:27:57 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:37176 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbaLaL1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 06:27:55 -0500
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Arnaud Patard <arnaud.patard@rtp-net.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: xgifb: remove unnecessary check
Date: Wed, 31 Dec 2014 16:57:46 +0530
Message-Id: <1420025266-29430-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the check for htotal and vtotal is not required as we have already
checked for them and returned -EINVAL if any of them is zero.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 drivers/staging/xgifb/XGI_main_26.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 709d49e..74a8db8 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -952,7 +952,7 @@ static int XGIfb_do_set_var(struct fb_var_screeninfo *var, int isactive,
 	} pr_debug("var->pixclock=%d, htotal=%d, vtotal=%d\n",
 			var->pixclock, htotal, vtotal);
 
-	if (var->pixclock && htotal && vtotal) {
+	if (var->pixclock) {
 		drate = 1000000000 / var->pixclock;
 		hrate = (drate * 1000) / htotal;
 		xgifb_info->refresh_rate = (unsigned int) (hrate * 2
-- 
1.8.1.2

