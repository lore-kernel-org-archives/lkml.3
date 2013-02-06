Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142Ab3BFKuG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 05:50:06 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18893 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497Ab3BFKuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 05:50:02 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 06 Feb 2013 02:49:33 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@nvidia.com>, <mturquette@linaro.org>
CC: <pgaikwad@nvidia.com>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] clk: tegra: initialise parent of uart clocks
Date: Wed, 6 Feb 2013 16:17:41 +0530
Message-ID: <1360147661-5435-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initialise the parent of UARTs to PLLP and disabling clock by
default.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/clk/tegra/clk-tegra20.c |    3 +++
 drivers/clk/tegra/clk-tegra30.c |    4 ++++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/clk/tegra/clk-tegra20.c b/drivers/clk/tegra/clk-tegra20.c
index 5d41569..dea94f4 100644
--- a/drivers/clk/tegra/clk-tegra20.c
+++ b/drivers/clk/tegra/clk-tegra20.c
@@ -1252,7 +1252,10 @@ static __initdata struct tegra_clk_init_table init_table[] = {
 	{emc, clk_max, 0, 1},
 	{cclk, clk_max, 0, 1},
 	{uarta, pll_p, 0, 1},
+	{uartb, pll_p, 0, 0},
+	{uartc, pll_p, 0, 0},
 	{uartd, pll_p, 0, 1},
+	{uarte, pll_p, 0, 0},
 	{usbd, clk_max, 12000000, 0},
 	{usb2, clk_max, 12000000, 0},
 	{usb3, clk_max, 12000000, 0},
diff --git a/drivers/clk/tegra/clk-tegra30.c b/drivers/clk/tegra/clk-tegra30.c
index a163812..d50146b 100644
--- a/drivers/clk/tegra/clk-tegra30.c
+++ b/drivers/clk/tegra/clk-tegra30.c
@@ -1875,6 +1875,10 @@ static struct tegra_cpu_car_ops tegra30_cpu_car_ops = {
 
 static __initdata struct tegra_clk_init_table init_table[] = {
 	{uarta, pll_p, 408000000, 1},
+	{uartb, pll_p, 408000000, 0},
+	{uartc, pll_p, 408000000, 0},
+	{uartd, pll_p, 408000000, 0},
+	{uarte, pll_p, 408000000, 0},
 	{pll_a, clk_max, 564480000, 1},
 	{pll_a_out0, clk_max, 11289600, 1},
 	{extern1, pll_a_out0, 0, 1},
-- 
1.7.1.1

