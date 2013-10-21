Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540Ab3JUTPc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 15:15:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:1334 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752281Ab3JUTPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 15:15:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,541,1378882800"; 
   d="scan'208";a="414681986"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 8/8] mei: print correct device state during unexpected reset
Date: Mon, 21 Oct 2013 22:05:43 +0300
Message-Id: <1382382343-12066-9-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1382382343-12066-1-git-send-email-tomas.winkler@intel.com>
References: <1382382343-12066-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

Move the unexpected state print to the beginning of mei_reset,
thus printing right state.

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/init.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 4c93e3d..7dfc7a4 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -147,6 +147,10 @@ void mei_reset(struct mei_device *dev, int interrupts_enabled)
 			dev->dev_state != MEI_DEV_POWER_DOWN &&
 			dev->dev_state != MEI_DEV_POWER_UP);
 
+	if (unexpected)
+		dev_warn(&dev->pdev->dev, "unexpected reset: dev_state = %s\n",
+			 mei_dev_state_str(dev->dev_state));
+
 	ret = mei_hw_reset(dev, interrupts_enabled);
 	if (ret) {
 		dev_err(&dev->pdev->dev, "hw reset failed disabling the device\n");
@@ -186,10 +190,6 @@ void mei_reset(struct mei_device *dev, int interrupts_enabled)
 	dev->rd_msg_hdr = 0;
 	dev->wd_pending = false;
 
-	if (unexpected)
-		dev_warn(&dev->pdev->dev, "unexpected reset: dev_state = %s\n",
-			 mei_dev_state_str(dev->dev_state));
-
 	if (!interrupts_enabled) {
 		dev_dbg(&dev->pdev->dev, "intr not enabled end of reset\n");
 		return;
-- 
1.8.3.1

