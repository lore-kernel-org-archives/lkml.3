Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbaIXQ4E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:56:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:49463 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753877AbaIXQqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:46:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,590,1406617200"; 
   d="scan'208";a="604749297"
From: Vinod Koul <vinod.koul@intel.com>
To: linux-kernel@vger.kernel.org
Cc: subhransu.s.prusty@intel.com, vinod.koul@intel.com,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: [PATCH 07/27] vga_switcheroo: use pm_runtime_last_busy_and_autosuspend helper
Date: Wed, 24 Sep 2014 21:44:57 +0530
Message-Id: <1411575342-31048-8-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1411575342-31048-1-git-send-email-vinod.koul@intel.com>
References: <1411575342-31048-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new pm_runtime_last_busy_and_autosuspend helper instead of open
coding the same code

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
---
 drivers/gpu/vga/vga_switcheroo.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/vga/vga_switcheroo.c b/drivers/gpu/vga/vga_switcheroo.c
index 6866448..697ffbd 100644
--- a/drivers/gpu/vga/vga_switcheroo.c
+++ b/drivers/gpu/vga/vga_switcheroo.c
@@ -682,10 +682,9 @@ static int vga_switcheroo_runtime_resume_hdmi_audio(struct device *dev)
 	ret = dev->bus->pm->runtime_resume(dev);
 
 	/* put the reference for the gpu */
-	if (found) {
-		pm_runtime_mark_last_busy(&found->pdev->dev);
-		pm_runtime_put_autosuspend(&found->pdev->dev);
-	}
+	if (found)
+		pm_runtime_last_busy_and_autosuspend(&found->pdev->dev);
+
 	return ret;
 }
 
-- 
1.7.0.4

