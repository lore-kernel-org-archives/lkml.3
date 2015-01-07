Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585AbbAGCgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:36:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46953 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757553AbbAGCQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 21:16:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Dmitry Osipenko <digetx@gmail.com>,
        Thierry Reding <treding@nvidia.com>
Subject: [PATCH 3.17 31/73] ARM: tegra: Re-add removed SoC id macro to tegra_resume()
Date: Tue,  6 Jan 2015 18:15:52 -0800
Message-Id: <20150107021558.457352463@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107021557.521276020@linuxfoundation.org>
References: <20150107021557.521276020@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-tegra/reset-handler.S |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/mach-tegra/reset-handler.S
+++ b/arch/arm/mach-tegra/reset-handler.S
@@ -51,6 +51,7 @@ ENTRY(tegra_resume)
  THUMB(	it	ne )
 	bne	cpu_resume			@ no
 
+	tegra_get_soc_id TEGRA_APB_MISC_BASE, r6
 	/* Are we on Tegra20? */
 	cmp	r6, #TEGRA20
 	beq	1f				@ Yes


