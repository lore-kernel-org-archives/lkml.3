Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206AbaEOAhF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 20:37:05 -0400
Received: from mail-oa0-f74.google.com ([209.85.219.74]:54819 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbaEOAdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 20:33:12 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: linux-tegra@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>, Jim Lin <jilin@nvidia.com>,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [RFC PATCH 02/10] clk: tegra: Fix xusb_fs_src mux
Date: Wed, 14 May 2014 17:32:58 -0700
Message-Id: <1400113986-339-3-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
In-Reply-To: <1400113986-339-1-git-send-email-abrestic@chromium.org>
References: <1400113986-339-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Lin <jilin@nvidia.com>

The parent-to-index mapping for xusb_fs_src is incorrect.
Fix it by adding a mux table.

Signed-off-by: Jim Lin <jilin@nvidia.com>
Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 drivers/clk/tegra/clk-tegra-periph.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/tegra/clk-tegra-periph.c b/drivers/clk/tegra/clk-tegra-periph.c
index 1fa5c3f..a4063bc 100644
--- a/drivers/clk/tegra/clk-tegra-periph.c
+++ b/drivers/clk/tegra/clk-tegra-periph.c
@@ -329,7 +329,9 @@ static u32 mux_clkm_pllp_pllc_pllre_idx[] = {
 static const char *mux_clkm_48M_pllp_480M[] = {
 	"clk_m", "pll_u_48M", "pll_p", "pll_u_480M"
 };
-#define mux_clkm_48M_pllp_480M_idx NULL
+static u32 mux_clkm_48M_pllp_480M_idx[] = {
+	[0] = 0, [1] = 2, [2] = 4, [3] = 6,
+};
 
 static const char *mux_clkm_pllre_clk32_480M_pllc_ref[] = {
 	"clk_m", "pll_re_out", "clk_32k", "pll_u_480M", "pll_c", "pll_ref"
-- 
1.9.1.423.g4596e3a

