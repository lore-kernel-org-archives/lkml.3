Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549AbbAYVqZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 16:46:25 -0500
Received: from mga03.intel.com ([134.134.136.65]:63921 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717AbbAYVqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 16:46:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="444962541"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        <stable@vger.kernel.org>, Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc 1/2 3.19] mei: mask interrupt set bit on clean reset bit
Date: Sun, 25 Jan 2015 23:45:27 +0200
Message-Id: <1422222328-16109-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

We should mask interrupt set bit when writing back
hcsr value in reset bit clean-up.

This is refinement for
mei: clean reset bit before reset
commit b13a65ef190e488e2761d65bdd2e1fe8a3a125f5

Cc: <stable@vger.kernel.org> #3.10+
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hw-me.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index 06ff0a2ec960..ccc1b405ca21 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -242,7 +242,7 @@ static int mei_me_hw_reset(struct mei_device *dev, bool intr_enable)
 	if ((hcsr & H_RST) == H_RST) {
 		dev_warn(dev->dev, "H_RST is set = 0x%08X", hcsr);
 		hcsr &= ~H_RST;
-		mei_me_reg_write(hw, H_CSR, hcsr);
+		mei_hcsr_set(hw, hcsr);
 		hcsr = mei_hcsr_read(hw);
 	}
 
-- 
1.9.3

