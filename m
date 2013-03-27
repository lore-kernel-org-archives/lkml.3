Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615Ab3C0Lm5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 07:42:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:23085 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770Ab3C0Lm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 07:42:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,919,1355126400"; 
   d="scan'208";a="312589341"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 2/2 V2] mei: drop RECOVERING_FROM_RESET device state
Date: Wed, 27 Mar 2013 13:42:15 +0200
Message-Id: <1364384535-31943-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ECOVERING_FROM_RESET device state is never set
we can remove it

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
v2: rebased over char-misc-next: 8c876be81a1f2f0ab33ffb2b00871e65c7a658b3

 drivers/misc/mei/init.c    | 4 ----
 drivers/misc/mei/mei_dev.h | 1 -
 2 files changed, 5 deletions(-)

diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 1ab1fb1..09a9980 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -34,7 +34,6 @@ const char *mei_dev_state_str(int state)
 	MEI_DEV_STATE(ENABLED);
 	MEI_DEV_STATE(RESETING);
 	MEI_DEV_STATE(DISABLED);
-	MEI_DEV_STATE(RECOVERING_FROM_RESET);
 	MEI_DEV_STATE(POWER_DOWN);
 	MEI_DEV_STATE(POWER_UP);
 	default:
@@ -139,9 +138,6 @@ void mei_reset(struct mei_device *dev, int interrupts_enabled)
 {
 	bool unexpected;
 
-	if (dev->dev_state == MEI_DEV_RECOVERING_FROM_RESET)
-		return;
-
 	unexpected = (dev->dev_state != MEI_DEV_INITIALIZING &&
 			dev->dev_state != MEI_DEV_DISABLED &&
 			dev->dev_state != MEI_DEV_POWER_DOWN &&
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index d6fd3d6..091f50af 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -97,7 +97,6 @@ enum mei_dev_state {
 	MEI_DEV_ENABLED,
 	MEI_DEV_RESETING,
 	MEI_DEV_DISABLED,
-	MEI_DEV_RECOVERING_FROM_RESET,
 	MEI_DEV_POWER_DOWN,
 	MEI_DEV_POWER_UP
 };
-- 
1.7.11.7

