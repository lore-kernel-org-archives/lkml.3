Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826AbaGULX0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 07:23:26 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:37774 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584AbaGULXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 07:23:24 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] clk/tegra: Fix a bunch of sparse warnings
Date: Mon, 21 Jul 2014 13:23:21 +0200
Message-Id: <1405941801-27455-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

The second to last parameter of the TEGRA_CLK_PERIPH macro denotes a
table and should therefore users should pass in NULL instead of 0.

Fixes a bunch of sparse warnings like this:

	warning: Using plain integer as NULL pointer

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/clk/tegra/clk-tegra-periph.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/tegra/clk-tegra-periph.c b/drivers/clk/tegra/clk-tegra-periph.c
index adf6b814b5bc..0bc59fba9e6a 100644
--- a/drivers/clk/tegra/clk-tegra-periph.c
+++ b/drivers/clk/tegra/clk-tegra-periph.c
@@ -218,7 +218,7 @@
 		.clk_id = _clk_id,					\
 		.p.parent_name = _parent_name,				\
 		.periph = TEGRA_CLK_PERIPH(0, 0, 0, 0, 0, 0, 0,		\
-				_clk_num, _gate_flags, 0, NULL),	\
+				_clk_num, _gate_flags, NULL, NULL),	\
 		.flags = _flags						\
 	}
 
-- 
2.0.1

