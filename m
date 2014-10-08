Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582AbaJHTeH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 15:34:07 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:57786 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049AbaJHTeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 15:34:05 -0400
From: Dmitry Osipenko <digetx@gmail.com>
To: swarren@wwwdotorg.org, josephl@nvidia.com, thierry.reding@gmail.com,
        balbi@ti.com, digetx@gmail.com
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH V2] ARM: tegra: Re-add removed SoC id macro to tegra_resume()
Date: Wed,  8 Oct 2014 23:24:15 +0400
Message-Id: <1412796255-10589-1-git-send-email-digetx@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <20141008190432.GN22688@saruman>
References: <20141008190432.GN22688@saruman>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d127e9c5c5bc1ee22a7b1fe804397cddd132f756 ("ARM: tegra: make tegra_resume
can work with current and later chips") removed tegra_get_soc_id macro leaving
used cpu register unassigned and as result causing execution of unintended code
on tegra20. Fix it by re-adding macro.

Fixes: d127e9c (ARM: tegra: make tegra_resume can work with current and later chips)
Cc: <stable@vger.kernel.org> # v3.13+
Reviewed-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
---
V2: added Cc's for lakml and stable, added "Reviewed-by:" Felipe Balbi

 arch/arm/mach-tegra/reset-handler.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-tegra/reset-handler.S b/arch/arm/mach-tegra/reset-handler.S
index 7b2baab..71be4af 100644
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
2.1.1

