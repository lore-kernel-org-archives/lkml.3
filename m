Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab3GQMP3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 08:15:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:55706 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754405Ab3GQMOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 08:14:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,684,1367996400"; 
   d="scan'208";a="346987205"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc 3.11 3/4] mei: don't have to clean the state on power up
Date: Wed, 17 Jul 2013 15:13:16 +0300
Message-Id: <1374063197-26855-4-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374063197-26855-1-git-send-email-tomas.winkler@intel.com>
References: <1374063197-26855-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When powering up, we don't have to clean up the device state
nothing is connected.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/init.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index ed1d752..e6f16f8 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -148,7 +148,8 @@ void mei_reset(struct mei_device *dev, int interrupts_enabled)
 
 	dev->hbm_state = MEI_HBM_IDLE;
 
-	if (dev->dev_state != MEI_DEV_INITIALIZING) {
+	if (dev->dev_state != MEI_DEV_INITIALIZING &&
+	    dev->dev_state != MEI_DEV_POWER_UP) {
 		if (dev->dev_state != MEI_DEV_DISABLED &&
 		    dev->dev_state != MEI_DEV_POWER_DOWN)
 			dev->dev_state = MEI_DEV_RESETTING;
-- 
1.8.1.2

