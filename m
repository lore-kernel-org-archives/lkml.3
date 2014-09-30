Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106AbaI3HWY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 03:22:24 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:42692 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbaI3HWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 03:22:20 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>
Subject: [PATCH] clk: tegra: Fix order of arguments in WARN
Date: Tue, 30 Sep 2014 09:22:00 +0200
Message-Id: <1412061720-10402-1-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As previously the names of the present clock and its parent were swapped.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>

---

Hi,

I'm not a native English speaker, but the way the current message is made me
think that the clock that failed registration was the wrong one.

Regards,

Tomeu
---
 drivers/clk/tegra/clk-pll.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/tegra/clk-pll.c b/drivers/clk/tegra/clk-pll.c
index c7c6d8f..fd18d2e 100644
--- a/drivers/clk/tegra/clk-pll.c
+++ b/drivers/clk/tegra/clk-pll.c
@@ -1565,7 +1565,7 @@ struct clk *tegra_clk_register_pllxc(const char *name, const char *parent_name,
 	parent = __clk_lookup(parent_name);
 	if (!parent) {
 		WARN(1, "parent clk %s of %s must be registered first\n",
-			name, parent_name);
+			parent_name, name);
 		return ERR_PTR(-EINVAL);
 	}
 
@@ -1665,7 +1665,7 @@ struct clk *tegra_clk_register_pllm(const char *name, const char *parent_name,
 	parent = __clk_lookup(parent_name);
 	if (!parent) {
 		WARN(1, "parent clk %s of %s must be registered first\n",
-			name, parent_name);
+			parent_name, name);
 		return ERR_PTR(-EINVAL);
 	}
 
@@ -1706,7 +1706,7 @@ struct clk *tegra_clk_register_pllc(const char *name, const char *parent_name,
 	parent = __clk_lookup(parent_name);
 	if (!parent) {
 		WARN(1, "parent clk %s of %s must be registered first\n",
-			name, parent_name);
+			parent_name, name);
 		return ERR_PTR(-EINVAL);
 	}
 
@@ -1830,7 +1830,7 @@ struct clk *tegra_clk_register_pllss(const char *name, const char *parent_name,
 	parent = __clk_lookup(parent_name);
 	if (!parent) {
 		WARN(1, "parent clk %s of %s must be registered first\n",
-			name, parent_name);
+			parent_name, name);
 		return ERR_PTR(-EINVAL);
 	}
 
-- 
1.9.3

