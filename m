Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbbAAQwn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 11:52:43 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:51533 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbbAAQwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 11:52:42 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: David Airlie <airlied@linux.ie>,
        Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] gpu: drm: gma500: mmu.c:  Remove unused function
Date: Thu,  1 Jan 2015 17:55:42 +0100
Message-Id: <1420131342-30418-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function psb_get_default_pd_addr() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/gpu/drm/gma500/mmu.c |    9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/gpu/drm/gma500/mmu.c b/drivers/gpu/drm/gma500/mmu.c
index 0eaf11c..557cae7 100644
--- a/drivers/gpu/drm/gma500/mmu.c
+++ b/drivers/gpu/drm/gma500/mmu.c
@@ -426,15 +426,6 @@ struct psb_mmu_pd *psb_mmu_get_default_pd(struct psb_mmu_driver *driver)
 	return pd;
 }
 
-/* Returns the physical address of the PD shared by sgx/msvdx */
-uint32_t psb_get_default_pd_addr(struct psb_mmu_driver *driver)
-{
-	struct psb_mmu_pd *pd;
-
-	pd = psb_mmu_get_default_pd(driver);
-	return page_to_pfn(pd->p) << PAGE_SHIFT;
-}
-
 void psb_mmu_driver_takedown(struct psb_mmu_driver *driver)
 {
 	struct drm_device *dev = driver->dev;
-- 
1.7.10.4

