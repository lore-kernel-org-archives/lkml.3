Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697AbaIXQ4F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:56:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:49437 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753872AbaIXQqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:46:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,590,1406617200"; 
   d="scan'208";a="604749270"
From: Vinod Koul <vinod.koul@intel.com>
To: linux-kernel@vger.kernel.org
Cc: subhransu.s.prusty@intel.com, vinod.koul@intel.com,
        David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        Dave Airlie <airlied@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Herrmann <dh.herrmann@gmail.com>,
        Ilia Mirkin <imirkin@alum.mit.edu>,
        Jani Nikula <jani.nikula@intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Rob Clark <robdclark@gmail.com>, Thierry Reding <treding@nvidia.com>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 05/27] drm/nouveau: use pm_runtime_last_busy_and_autosuspend helper
Date: Wed, 24 Sep 2014 21:44:55 +0530
Message-Id: <1411575342-31048-6-git-send-email-vinod.koul@intel.com>
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
 drivers/gpu/drm/nouveau/nouveau_connector.c |    3 +--
 drivers/gpu/drm/nouveau/nouveau_drm.c       |    9 +++------
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_connector.c b/drivers/gpu/drm/nouveau/nouveau_connector.c
index 1ec44c8..0e3108a 100644
--- a/drivers/gpu/drm/nouveau/nouveau_connector.c
+++ b/drivers/gpu/drm/nouveau/nouveau_connector.c
@@ -323,8 +323,7 @@ detect_analog:
 
  out:
 
-	pm_runtime_mark_last_busy(connector->dev->dev);
-	pm_runtime_put_autosuspend(connector->dev->dev);
+	pm_runtime_last_busy_and_autosuspend(connector->dev->dev);
 
 	return conn_status;
 }
diff --git a/drivers/gpu/drm/nouveau/nouveau_drm.c b/drivers/gpu/drm/nouveau/nouveau_drm.c
index 250a5e8..719eabf 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drm.c
@@ -766,8 +766,7 @@ nouveau_drm_open(struct drm_device *dev, struct drm_file *fpriv)
 	mutex_unlock(&drm->client.mutex);
 
 out_suspend:
-	pm_runtime_mark_last_busy(dev->dev);
-	pm_runtime_put_autosuspend(dev->dev);
+	pm_runtime_last_busy_and_autosuspend(dev->dev);
 
 	return ret;
 }
@@ -794,8 +793,7 @@ nouveau_drm_postclose(struct drm_device *dev, struct drm_file *fpriv)
 {
 	struct nouveau_cli *cli = nouveau_cli(fpriv);
 	nouveau_cli_destroy(cli);
-	pm_runtime_mark_last_busy(dev->dev);
-	pm_runtime_put_autosuspend(dev->dev);
+	pm_runtime_last_busy_and_autosuspend(dev->dev);
 }
 
 static const struct drm_ioctl_desc
@@ -834,8 +832,7 @@ nouveau_drm_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		break;
 	}
 
-	pm_runtime_mark_last_busy(dev->dev);
-	pm_runtime_put_autosuspend(dev->dev);
+	pm_runtime_last_busy_and_autosuspend(dev->dev);
 	return ret;
 }
 
-- 
1.7.0.4

