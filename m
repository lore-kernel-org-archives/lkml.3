Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab3L0AuZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 19:50:25 -0500
Received: from mail-qc0-f202.google.com ([209.85.216.202]:38596 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab3L0AuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 19:50:24 -0500
From: Andrew Bresticker <abrestic@chromium.org>
To: Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Gabe Black <gabeblack@chromium.org>, Gabe Black <gabeblack@google.com>,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH 1/7] clk: tegra: Fix PLLP rate table
Date: Thu, 26 Dec 2013 16:44:21 -0800
Message-Id: <1388105067-24438-2-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1388105067-24438-1-git-send-email-abrestic@chromium.org>
References: <1388105067-24438-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gabe Black <gabeblack@chromium.org>

This table had settings for 216MHz, but PLLP is (and is supposed to be)
configured at 408MHz.  If that table is used and PLLP_BASE_OVRRIDE is
not set, the kernel will panic in clk_pll_recalc_rate().

Signed-off-by: Gabe Black <gabeblack@google.com>
Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 drivers/clk/tegra/clk-tegra124.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/clk/tegra/clk-tegra124.c b/drivers/clk/tegra/clk-tegra124.c
index aff86b5..28bb238 100644
--- a/drivers/clk/tegra/clk-tegra124.c
+++ b/drivers/clk/tegra/clk-tegra124.c
@@ -516,11 +516,11 @@ static struct div_nmp pllp_nmp = {
 };
 
 static struct tegra_clk_pll_freq_table pll_p_freq_table[] = {
-	{12000000, 216000000, 432, 12, 1, 8},
-	{13000000, 216000000, 432, 13, 1, 8},
-	{16800000, 216000000, 360, 14, 1, 8},
-	{19200000, 216000000, 360, 16, 1, 8},
-	{26000000, 216000000, 432, 26, 1, 8},
+	{12000000, 408000000, 408, 12, 0, 8},
+	{13000000, 408000000, 408, 13, 0, 8},
+	{16800000, 408000000, 340, 14, 0, 8},
+	{19200000, 408000000, 340, 16, 0, 8},
+	{26000000, 408000000, 408, 26, 0, 8},
 	{0, 0, 0, 0, 0, 0},
 };
 
-- 
1.8.5.1

