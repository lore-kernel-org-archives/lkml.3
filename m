Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030593AbaGCJZ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:25:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52630 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758757AbaGCJZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:25:13 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paul Bolle <pebolle@tiscali.nl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 185/198] staging: tidspbridge: check for CONFIG_SND_OMAP_SOC_MCBSP
Date: Thu,  3 Jul 2014 10:20:28 +0100
Message-Id: <1404379241-8590-186-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Bolle <pebolle@tiscali.nl>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
1.9.1

