Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbbAKNzB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 08:55:01 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:51681 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbbAKNzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 08:55:00 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        Thierry Reding <treding@nvidia.com>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drm: nouveau: nouveau_gem: Remove unused function
Date: Sun, 11 Jan 2015 14:58:05 +0100
Message-Id: <1420984685-17724-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function domain_to_ttm() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/gpu/drm/nouveau/nouveau_gem.c |   13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_gem.c b/drivers/gpu/drm/nouveau/nouveau_gem.c
index 36951ee..f208d3a 100644
--- a/drivers/gpu/drm/nouveau/nouveau_gem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_gem.c
@@ -825,19 +825,6 @@ out_next:
 	return nouveau_abi16_put(abi16, ret);
 }
 
-static inline uint32_t
-domain_to_ttm(struct nouveau_bo *nvbo, uint32_t domain)
-{
-	uint32_t flags = 0;
-
-	if (domain & NOUVEAU_GEM_DOMAIN_VRAM)
-		flags |= TTM_PL_FLAG_VRAM;
-	if (domain & NOUVEAU_GEM_DOMAIN_GART)
-		flags |= TTM_PL_FLAG_TT;
-
-	return flags;
-}
-
 int
 nouveau_gem_ioctl_cpu_prep(struct drm_device *dev, void *data,
 			   struct drm_file *file_priv)
-- 
1.7.10.4

