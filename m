Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534AbaF3LzT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 07:55:19 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:52115 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753988AbaF3Lx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:26 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Paul Bolle <pebolle@tiscali.nl>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 100/181] staging: tidspbridge: check for CONFIG_SND_OMAP_SOC_MCBSP
Date: Mon, 30 Jun 2014 13:52:01 +0200
Message-Id: <8454436ae3803ca071d2955cb0a01fc495fba40f.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Bolle <pebolle@tiscali.nl>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit d3921a03a89acb1b9ca599590c0131c89f8737d8 upstream.

Commit d0f47ff17f29 ("ASoC: OMAP: Build config cleanup for McBSP")
removed the Kconfig symbol OMAP_MCBSP. It left two checks for
CONFIG_OMAP_MCBSP untouched.

Convert these to checks for CONFIG_SND_OMAP_SOC_MCBSP. That must be
correct, since that re-enables calls to functions that are all found in
sound/soc/omap/mcbsp.c. And that file is built only if
CONFIG_SND_OMAP_SOC_MCBSP is defined.

Fixes: d0f47ff17f29 ("ASoC: OMAP: Build config cleanup for McBSP")
Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/staging/tidspbridge/core/dsp-clock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/tidspbridge/core/dsp-clock.c b/drivers/staging/tidspbridge/core/dsp-clock.c
index 2f084e181d39..a1aca4416ca7 100644
--- a/drivers/staging/tidspbridge/core/dsp-clock.c
+++ b/drivers/staging/tidspbridge/core/dsp-clock.c
@@ -226,7 +226,7 @@ int dsp_clk_enable(enum dsp_clk_id clk_id)
 	case GPT_CLK:
 		status = omap_dm_timer_start(timer[clk_id - 1]);
 		break;
-#ifdef CONFIG_OMAP_MCBSP
+#ifdef CONFIG_SND_OMAP_SOC_MCBSP
 	case MCBSP_CLK:
 		omap_mcbsp_request(MCBSP_ID(clk_id));
 		omap2_mcbsp_set_clks_src(MCBSP_ID(clk_id), MCBSP_CLKS_PAD_SRC);
@@ -302,7 +302,7 @@ int dsp_clk_disable(enum dsp_clk_id clk_id)
 	case GPT_CLK:
 		status = omap_dm_timer_stop(timer[clk_id - 1]);
 		break;
-#ifdef CONFIG_OMAP_MCBSP
+#ifdef CONFIG_SND_OMAP_SOC_MCBSP
 	case MCBSP_CLK:
 		omap2_mcbsp_set_clks_src(MCBSP_ID(clk_id), MCBSP_CLKS_PRCM_SRC);
 		omap_mcbsp_free(MCBSP_ID(clk_id));
-- 
2.0.0

