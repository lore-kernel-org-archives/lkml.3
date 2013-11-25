Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850Ab3KYNUy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:20:54 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:9409 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195Ab3KYNUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:20:49 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 25 Nov 2013 05:14:35 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] clk: tegra: fix pllcx pdiv for Tegra124
Date: Mon, 25 Nov 2013 15:20:23 +0200
Message-ID: <1385385623-8952-3-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1385385623-8952-1-git-send-email-pdeschrijver@nvidia.com>
References: <1385385623-8952-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The post divider field for pllcx on Tegra124 has some more allowed values than
the one on Tegra114. Fix the code to reflect this.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk-tegra124.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/clk/tegra/clk-tegra124.c b/drivers/clk/tegra/clk-tegra124.c
index 54af043..863c38b 100644
--- a/drivers/clk/tegra/clk-tegra124.c
+++ b/drivers/clk/tegra/clk-tegra124.c
@@ -263,8 +263,11 @@ static struct div_nmp pllcx_nmp = {
 static struct pdiv_map pllc_p[] = {
 	{ .pdiv = 1, .hw_val = 0 },
 	{ .pdiv = 2, .hw_val = 1 },
+	{ .pdiv = 3, .hw_val = 2 },
 	{ .pdiv = 4, .hw_val = 3 },
+	{ .pdiv = 6, .hw_val = 4 },
 	{ .pdiv = 8, .hw_val = 5 },
+	{ .pdiv = 12, .hw_val = 6 },
 	{ .pdiv = 16, .hw_val = 7 },
 	{ .pdiv = 0, .hw_val = 0 },
 };
-- 
1.7.7.rc0.72.g4b5ea.dirty

