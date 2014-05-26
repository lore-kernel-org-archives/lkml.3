Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbaEZTrP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 15:47:15 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:58415 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751534AbaEZTrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 15:47:14 -0400
Message-ID: <1401133631.6068.36.camel@x220>
Subject: [PATCH] staging: tidspbridge: check for CONFIG_SND_OMAP_SOC_MCBSP
From: Paul Bolle <pebolle@tiscali.nl>
To: Omar Ramirez Luna <omar.ramirez@copitl.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Mon, 26 May 2014 21:47:11 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 May 2014 19:47:12.0674 (UTC) FILETIME=[49D3F820:01CF791B]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d0f47ff17f29 ("ASoC: OMAP: Build config cleanup for McBSP")
removed the Kconfig symbol OMAP_MCBSP. It left two checks for
CONFIG_OMAP_MCBSP untouched.

Convert these to checks for CONFIG_SND_OMAP_SOC_MCBSP. That must be
correct, since that re-enables calls to functions that are all found in
sound/soc/omap/mcbsp.c. And that file is built only if
CONFIG_SND_OMAP_SOC_MCBSP is defined.

Fixes: d0f47ff17f29 ("ASoC: OMAP: Build config cleanup for McBSP")
Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested. Note that commit d0f47ff17f29 shipped in v3.4, so these few
lines of code haven't been built for a while. Done on top of
next-20140526.

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
1.9.0

