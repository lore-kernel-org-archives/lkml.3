Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855Ab3EQLwd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 07:52:33 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11198 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755807Ab3EQLwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 07:52:31 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 17 May 2013 04:48:40 -0700
From: Arto Merilainen <amerilainen@nvidia.com>
To: <thierry.reding@avionic-design.de>, <airlied@linux.ie>,
        <linux-tegra@vger.kernel.org>
CC: <tbergstrom@nvidia.com>, <dri-devel@lists.freedesktop.org>,
        <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: [PATCH 6/6] drm/tegra: Fix syncpoint increment return code
Date: Fri, 17 May 2013 14:49:48 +0300
Message-ID: <1368791388-31441-7-git-send-email-amerilainen@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1368791388-31441-1-git-send-email-amerilainen@nvidia.com>
References: <1368791388-31441-1-git-send-email-amerilainen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add syncpoint increment to return a proper return code based on the
return value from host1x.

Signed-off-by: Arto Merilainen <amerilainen@nvidia.com>
---
 drivers/gpu/host1x/drm/drm.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/host1x/drm/drm.c b/drivers/gpu/host1x/drm/drm.c
index 2b561c9..1dfd454 100644
--- a/drivers/gpu/host1x/drm/drm.c
+++ b/drivers/gpu/host1x/drm/drm.c
@@ -378,8 +378,7 @@ static int tegra_syncpt_incr(struct drm_device *drm, void *data,
 	if (!sp)
 		return -EINVAL;
 
-	host1x_syncpt_incr(sp);
-	return 0;
+	return host1x_syncpt_incr(sp);
 }
 
 static int tegra_syncpt_wait(struct drm_device *drm, void *data,
-- 
1.7.9.5

