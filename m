Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871AbaH2PWm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 11:22:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:46637 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753135AbaH2PVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 11:21:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,424,1406617200"; 
   d="scan'208";a="591743207"
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: airlied@linux.ie
Cc: Mark Rustad <mark.d.rustad@intel.com>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH 2/2] drm: Resolve shadow warning for s32
Date: Fri, 29 Aug 2014 08:21:26 -0700
Message-Id: <1409325686-13994-2-git-send-email-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409325686-13994-1-git-send-email-jeffrey.t.kirsher@intel.com>
References: <1409325686-13994-1-git-send-email-jeffrey.t.kirsher@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Rustad <mark.d.rustad@intel.com>

Resolve a shadow warning produced in a W=2 build by changing
the name of a local variable from s32 to ds32. Since s32 clashes
with the well-known typedef, any macro expansion that could
someday be used that might attempt to use an s32 type would fail
to compile. It is best to eliminate the hazard.

Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/gpu/drm/drm_ioc32.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/drm_ioc32.c b/drivers/gpu/drm/drm_ioc32.c
index 2f4c4343..777ffd8 100644
--- a/drivers/gpu/drm/drm_ioc32.c
+++ b/drivers/gpu/drm/drm_ioc32.c
@@ -339,7 +339,7 @@ typedef struct drm_stats32 {
 static int compat_drm_getstats(struct file *file, unsigned int cmd,
 			       unsigned long arg)
 {
-	drm_stats32_t s32;
+	drm_stats32_t ds32;
 	drm_stats32_t __user *argp = (void __user *)arg;
 	struct drm_stats __user *stats;
 	int i, err;
@@ -352,14 +352,14 @@ static int compat_drm_getstats(struct file *file, unsigned int cmd,
 	if (err)
 		return err;
 
-	if (__get_user(s32.count, &stats->count))
+	if (__get_user(ds32.count, &stats->count))
 		return -EFAULT;
 	for (i = 0; i < 15; ++i)
-		if (__get_user(s32.data[i].value, &stats->data[i].value)
-		    || __get_user(s32.data[i].type, &stats->data[i].type))
+		if (__get_user(ds32.data[i].value, &stats->data[i].value)
+		    || __get_user(ds32.data[i].type, &stats->data[i].type))
 			return -EFAULT;
 
-	if (copy_to_user(argp, &s32, sizeof(s32)))
+	if (copy_to_user(argp, &ds32, sizeof(ds32)))
 		return -EFAULT;
 	return 0;
 }
-- 
1.9.3

