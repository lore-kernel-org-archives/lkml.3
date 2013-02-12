Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761060Ab3BLPRj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 10:17:39 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9774 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758195Ab3BLPRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 10:17:38 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 12 Feb 2013 07:16:39 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@nvidia.com>, <mturquette@linaro.org>
CC: <pgaikwad@nvidia.com>, <pdeschrijver@nvidia.com>,
        <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] clk: tegra: initialise parent of uart clocks
Date: Tue, 12 Feb 2013 20:47:13 +0530
Message-ID: <1360682233-23016-1-git-send-email-ldewangan@nvidia.com>
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
As suggested by Stephen, Make other uarts clock state to disable as
driver already enable these clocks.

 drivers/clk/tegra/clk-tegra20.c |    7 +++++--
 drivers/clk/tegra/clk-tegra30.c |    6 +++++-
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/tegra/clk-tegra20.c b/drivers/clk/tegra/clk-tegra20.c
index 4612b2e..8b5241e 100644
--- a/drivers/clk/tegra/clk-tegra20.c
+++ b/drivers/clk/tegra/clk-tegra20.c
@@ -1254,8 +1254,11 @@ static __initdata struct tegra_clk_init_table init_table[] = {
 	{csite, clk_max, 0, 1},
 	{emc, clk_max, 0, 1},
 	{cclk, clk_max, 0, 1},
-	{uarta, pll_p, 0, 1},
-	{uartd, pll_p, 0, 1},
+	{uarta, pll_p, 0, 0},
+	{uartb, pll_p, 0, 0},
+	{uartc, pll_p, 0, 0},
+	{uartd, pll_p, 0, 0},
+	{uarte, pll_p, 0, 0},
 	{usbd, clk_max, 12000000, 0},
 	{usb2, clk_max, 12000000, 0},
 	{usb3, clk_max, 12000000, 0},
diff --git a/drivers/clk/tegra/clk-tegra30.c b/drivers/clk/tegra/clk-tegra30.c
index bf050bc..56925e1 100644
--- a/drivers/clk/tegra/clk-tegra30.c
+++ b/drivers/clk/tegra/clk-tegra30.c
@@ -1877,7 +1877,11 @@ static struct tegra_cpu_car_ops tegra30_cpu_car_ops = {
 };
 
 static __initdata struct tegra_clk_init_table init_table[] = {
-	{uarta, pll_p, 408000000, 1},
+	{uarta, pll_p, 408000000, 0},
+	{uartb, pll_p, 408000000, 0},
+	{uartc, pll_p, 408000000, 0},
+	{uartd, pll_p, 408000000, 0},
+	{uarte, pll_p, 408000000, 0},
 	{pll_a, clk_max, 564480000, 1},
 	{pll_a_out0, clk_max, 11289600, 1},
 	{extern1, pll_a_out0, 0, 1},
-- 
1.7.1.1

