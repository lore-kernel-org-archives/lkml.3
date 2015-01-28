Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762051AbbA2CfO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:35:14 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46919 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759606AbbA2CfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:35:11 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dmitry Osipenko <digetx@gmail.com>, Thierry Reding <treding@nvidia.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 035/139] ARM: tegra: Re-add removed SoC id macro to tegra_resume()
Date: Wed, 28 Jan 2015 14:19:38 -0800
Message-Id: <1422483682-15393-36-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Osipenko <digetx@gmail.com>

commit e4a680099a6e97ecdbb81081cff9e4a489a4dc44 upstream.

Commit d127e9c ("ARM: tegra: make tegra_resume can work with current and later
chips") removed tegra_get_soc_id macro leaving used cpu register corrupted after
branching to v7_invalidate_l1() and as result causing execution of unintended
code on tegra20. Possibly it was expected that r6 would be SoC id func argument
since common cpu reset handler is setting r6 before branching to tegra_resume(),
but neither tegra20_lp1_reset() nor tegra30_lp1_reset() aren't setting r6
register before jumping to resume function. Fix it by re-adding macro.

Fixes: d127e9c (ARM: tegra: make tegra_resume can work with current and later chips)
Reviewed-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/mach-tegra/reset-handler.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-tegra/reset-handler.S b/arch/arm/mach-tegra/reset-handler.S
index 8c1ba4f..3505799 100644
--- a/arch/arm/mach-tegra/reset-handler.S
+++ b/arch/arm/mach-tegra/reset-handler.S
@@ -51,6 +51,7 @@ ENTRY(tegra_resume)
  THUMB(	it	ne )
 	bne	cpu_resume			@ no
 
+	tegra_get_soc_id TEGRA_APB_MISC_BASE, r6
 	/* Are we on Tegra20? */
 	cmp	r6, #TEGRA20
 	beq	1f				@ Yes
-- 
1.9.1

