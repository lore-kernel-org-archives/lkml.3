Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932567AbaFLHBm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 03:01:42 -0400
Received: from [59.16.167.190] ([59.16.167.190]:44318 "EHLO louise.mog422.net"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752334AbaFLHBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 03:01:41 -0400
X-Greylist: delayed 1631 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Jun 2014 03:01:41 EDT
From: mog422 <admin@mog422.net>
To: Mattia Dongili <malattia@linux.it>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        platform-driver-x86@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mog422 <admin@mog422.net>
Subject: [PATCH 1/1] sony-laptop: fix doesn't work lid resume settings on Vaio Pro
Date: Thu, 12 Jun 2014 15:34:09 +0900
Message-Id: <1402554849-24189-1-git-send-email-admin@mog422.net>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: mog422 <admin@mog422.net>
---
 drivers/platform/x86/sony-laptop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
index 9c5a074..26ad9ff 100644
--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -2389,7 +2389,7 @@ static int sony_nc_lid_resume_setup(struct platform_device *pd,
 		lid_ctl->attrs[LID_RESUME_S3].store = sony_nc_lid_resume_store;
 	}
 	for (i = 0; i < LID_RESUME_MAX &&
-			lid_ctl->attrs[LID_RESUME_S3].attr.name; i++) {
+			lid_ctl->attrs[i].attr.name; i++) {
 		result = device_create_file(&pd->dev, &lid_ctl->attrs[i]);
 		if (result)
 			goto liderror;
-- 
1.9.1

