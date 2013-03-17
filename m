Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185Ab3CQJlr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 05:41:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:8342 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756111Ab3CQJld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 05:41:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,859,1355126400"; 
   d="scan'208";a="307767256"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 2/2] mei: drop RECOVERING_FROM_RESET device state
Date: Sun, 17 Mar 2013 11:41:21 +0200
Message-Id: <1363513281-12606-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1363513281-12606-1-git-send-email-tomas.winkler@intel.com>
References: <1363513281-12606-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ECOVERING_FROM_RESET device state is never set
we can remove it

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
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
1.8.1.3

