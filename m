Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064AbaF1RrD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 13:47:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52698 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbaF1Rq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:46:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paul Bolle <pebolle@tiscali.nl>
Subject: [PATCH 3.4 02/43] staging: tidspbridge: check for CONFIG_SND_OMAP_SOC_MCBSP
Date: Sat, 28 Jun 2014 10:45:53 -0700
Message-Id: <20140628174449.919058388@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174449.788784511@linuxfoundation.org>
References: <20140628174449.788784511@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/staging/tidspbridge/core/dsp-clock.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/staging/tidspbridge/core/dsp-clock.c
+++ b/drivers/staging/tidspbridge/core/dsp-clock.c
@@ -213,7 +213,7 @@ int dsp_clk_enable(enum dsp_clk_id clk_i
 	case GPT_CLK:
 		status = omap_dm_timer_start(timer[clk_id - 1]);
 		break;
-#ifdef CONFIG_OMAP_MCBSP
+#ifdef CONFIG_SND_OMAP_SOC_MCBSP
 	case MCBSP_CLK:
 		omap_mcbsp_request(MCBSP_ID(clk_id));
 		omap2_mcbsp_set_clks_src(MCBSP_ID(clk_id), MCBSP_CLKS_PAD_SRC);
@@ -289,7 +289,7 @@ int dsp_clk_disable(enum dsp_clk_id clk_
 	case GPT_CLK:
 		status = omap_dm_timer_stop(timer[clk_id - 1]);
 		break;
-#ifdef CONFIG_OMAP_MCBSP
+#ifdef CONFIG_SND_OMAP_SOC_MCBSP
 	case MCBSP_CLK:
 		omap2_mcbsp_set_clks_src(MCBSP_ID(clk_id), MCBSP_CLKS_PRCM_SRC);
 		omap_mcbsp_free(MCBSP_ID(clk_id));


