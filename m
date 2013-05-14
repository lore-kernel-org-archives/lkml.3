Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302Ab3ENOtZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 10:49:25 -0400
Received: from mga14.intel.com ([143.182.124.37]:54010 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932218Ab3ENOtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 10:49:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,671,1363158000"; 
   d="scan'208";a="241385583"
From: Imre Deak <imre.deak@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH v2 3/8] drm/i915: take msecs_to_jiffies_timeout into use
Date: Tue, 14 May 2013 17:48:33 +0300
Message-Id: <1368542918-8861-4-git-send-email-imre.deak@intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368542918-8861-1-git-send-email-imre.deak@intel.com>
References: <1368542918-8861-1-git-send-email-imre.deak@intel.com>
In-Reply-To: <1368188011-23661-1-git-send-email-imre.deak@intel.com>
References: <1368188011-23661-1-git-send-email-imre.deak@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use msecs_to_jiffies_timeout instead of open-coding the same.

Signed-off-by: Imre Deak <imre.deak@intel.com>
---
 drivers/gpu/drm/i915/intel_drv.h |    2 +-
 drivers/gpu/drm/i915/intel_i2c.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_drv.h
index 624a9e6..13a46b7 100644
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -42,7 +42,7 @@
  * we've never had a chance to check the condition before the timeout.
  */
 #define _wait_for(COND, MS, W) ({ \
-	unsigned long timeout__ = jiffies + msecs_to_jiffies(MS) + 1;	\
+	unsigned long timeout__ = jiffies + msecs_to_jiffies_timeout(MS);\
 	int ret__ = 0;							\
 	while (!(COND)) {						\
 		if (time_after(jiffies, timeout__)) {			\
diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
index 5d24503..98cd8535 100644
--- a/drivers/gpu/drm/i915/intel_i2c.c
+++ b/drivers/gpu/drm/i915/intel_i2c.c
@@ -228,7 +228,7 @@ gmbus_wait_hw_status(struct drm_i915_private *dev_priv,
 	 * need to wake up periodically and check that ourselves. */
 	I915_WRITE(GMBUS4 + reg_offset, gmbus4_irq_en);
 
-	for (i = 0; i < msecs_to_jiffies(50) + 1; i++) {
+	for (i = 0; i < msecs_to_jiffies_timeout(50); i++) {
 		prepare_to_wait(&dev_priv->gmbus_wait_queue, &wait,
 				TASK_UNINTERRUPTIBLE);
 
-- 
1.7.10.4

