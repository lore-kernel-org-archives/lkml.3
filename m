Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933256Ab3CVLzo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 07:55:44 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13862 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932939Ab3CVLzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 07:55:42 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 22 Mar 2013 04:55:31 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: <linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] clk: tegra: Don't enable PLLs during early boot
Date: Fri, 22 Mar 2013 13:54:58 +0200
Message-ID: <1363953308-28828-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PLL code relies on udelay() which is not available when CCF is
initialized. Hence we can't enable any PLL during this phase.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>

--

Stephen,

Can you confirm this is ok for the audio drivers?

We used to be lucky that this has worked up to now, but I will introduce some
changes to the pll lock check code which cause this to fail due to the
slight differences in timing.

---
 drivers/clk/tegra/clk-tegra20.c |    4 ++--
 drivers/clk/tegra/clk-tegra30.c |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/clk/tegra/clk-tegra20.c b/drivers/clk/tegra/clk-tegra20.c
index b92d48b..7cc76b0 100644
--- a/drivers/clk/tegra/clk-tegra20.c
+++ b/drivers/clk/tegra/clk-tegra20.c
@@ -1230,8 +1230,8 @@ static __initdata struct tegra_clk_init_table init_table[] = {
 	{usbd, clk_max, 12000000, 0},
 	{usb2, clk_max, 12000000, 0},
 	{usb3, clk_max, 12000000, 0},
-	{pll_a, clk_max, 56448000, 1},
-	{pll_a_out0, clk_max, 11289600, 1},
+	{pll_a, clk_max, 56448000, 0},
+	{pll_a_out0, clk_max, 11289600, 0},
 	{cdev1, clk_max, 0, 1},
 	{blink, clk_max, 32768, 1},
 	{i2s1, pll_a_out0, 11289600, 0},
diff --git a/drivers/clk/tegra/clk-tegra30.c b/drivers/clk/tegra/clk-tegra30.c
index ba6f51b..b705408 100644
--- a/drivers/clk/tegra/clk-tegra30.c
+++ b/drivers/clk/tegra/clk-tegra30.c
@@ -1882,11 +1882,11 @@ static __initdata struct tegra_clk_init_table init_table[] = {
 	{uartc, pll_p, 408000000, 0},
 	{uartd, pll_p, 408000000, 0},
 	{uarte, pll_p, 408000000, 0},
-	{pll_a, clk_max, 564480000, 1},
-	{pll_a_out0, clk_max, 11289600, 1},
-	{extern1, pll_a_out0, 0, 1},
+	{pll_a, clk_max, 564480000, 0},
+	{pll_a_out0, clk_max, 11289600, 0},
+	{extern1, pll_a_out0, 0, 0},
 	{clk_out_1_mux, extern1, 0, 0},
-	{clk_out_1, clk_max, 0, 1},
+	{clk_out_1, clk_max, 0, 0},
 	{blink, clk_max, 0, 1},
 	{i2s0, pll_a_out0, 11289600, 0},
 	{i2s1, pll_a_out0, 11289600, 0},
-- 
1.7.7.rc0.72.g4b5ea.dirty

