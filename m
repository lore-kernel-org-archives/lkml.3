Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367Ab3HYJwT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 05:52:19 -0400
Received: from mga03.intel.com ([143.182.124.21]:34236 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756301Ab3HYJwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 05:52:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,951,1367996400"; 
   d="scan'208";a="351301662"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>, stable@vger.kernel.org
Subject: [3.10][PATCH 2/4] mei: don't have to clean the state on power up
Date: Sun, 25 Aug 2013 12:49:47 +0300
Message-Id: <1377424189-5508-3-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1377424189-5508-1-git-send-email-tomas.winkler@intel.com>
References: <1377424189-5508-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

stable: 3.10
commit 99f22c4ef24cf87b0dae6aabe6b5e620b62961d9 upstream

When powering up, we don't have to clean up the device state
nothing is connected.

Cc: stable@vger.kernel.org
Tested-by: Shuah Khan <shuah.kh@samsung.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/init.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index f580d30..6eec689 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -143,7 +143,8 @@ void mei_reset(struct mei_device *dev, int interrupts_enabled)
 
 	dev->hbm_state = MEI_HBM_IDLE;
 
-	if (dev->dev_state != MEI_DEV_INITIALIZING) {
+	if (dev->dev_state != MEI_DEV_INITIALIZING &&
+	    dev->dev_state != MEI_DEV_POWER_UP) {
 		if (dev->dev_state != MEI_DEV_DISABLED &&
 		    dev->dev_state != MEI_DEV_POWER_DOWN)
 			dev->dev_state = MEI_DEV_RESETTING;
-- 
1.8.1.2

