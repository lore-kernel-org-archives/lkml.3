Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448Ab3I3ISl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 04:18:41 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:57161 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318Ab3I3ISf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 04:18:35 -0400
From: Ulf Hansson <ulf.hansson@linaro.org>
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Chris Ball <cjb@laptop.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>,
        Tony Olech <tony.olech@elandigitalsystems.com>,
        linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] mmc: vub300: Move away from using deprecated APIs
Date: Mon, 30 Sep 2013 10:18:24 +0200
Message-Id: <1380529104-25818-1-git-send-email-ulf.hansson@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suspend and resume of cards are handled by the protocol layer and
consequently the mmc_suspend|resume_host APIs are marked as deprecated.

This means we can simplify the suspend|resume callbacks by removing the
use of the deprecated APIs.

Cc: Tony Olech <tony.olech@elandigitalsystems.com>
Cc: linux-usb@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
---
 drivers/mmc/host/vub300.c |   18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff --git a/drivers/mmc/host/vub300.c b/drivers/mmc/host/vub300.c
index e9028ad..4262296 100644
--- a/drivers/mmc/host/vub300.c
+++ b/drivers/mmc/host/vub300.c
@@ -2392,26 +2392,12 @@ static void vub300_disconnect(struct usb_interface *interface)
 #ifdef CONFIG_PM
 static int vub300_suspend(struct usb_interface *intf, pm_message_t message)
 {
-	struct vub300_mmc_host *vub300 = usb_get_intfdata(intf);
-	if (!vub300 || !vub300->mmc) {
-		return 0;
-	} else {
-		struct mmc_host *mmc = vub300->mmc;
-		mmc_suspend_host(mmc);
-		return 0;
-	}
+	return 0;
 }
 
 static int vub300_resume(struct usb_interface *intf)
 {
-	struct vub300_mmc_host *vub300 = usb_get_intfdata(intf);
-	if (!vub300 || !vub300->mmc) {
-		return 0;
-	} else {
-		struct mmc_host *mmc = vub300->mmc;
-		mmc_resume_host(mmc);
-		return 0;
-	}
+	return 0;
 }
 #else
 #define vub300_suspend NULL
-- 
1.7.9.5

