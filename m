Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765AbaFYM1f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 08:27:35 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:57144 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756696AbaFYM1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 08:27:33 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Felipe Balbi <balbi@ti.com>, Tony Lindgren <tony@atomide.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Russell King <linux@arm.linux.org.uk>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arch: arm: mach-omap2: usb-tusb6010.c:  Cleaning up variable is set more than once
Date: Wed, 25 Jun 2014 14:28:30 +0200
Message-Id: <1403699310-22960-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A struct member variable is set to the same value more than once

This was found using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/arm/mach-omap2/usb-tusb6010.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mach-omap2/usb-tusb6010.c b/arch/arm/mach-omap2/usb-tusb6010.c
index e832bc7..8333400 100644
--- a/arch/arm/mach-omap2/usb-tusb6010.c
+++ b/arch/arm/mach-omap2/usb-tusb6010.c
@@ -95,7 +95,6 @@ static int tusb_set_sync_mode(unsigned sysclk_ps)
 	dev_t.t_avdp_w = t_scsnh_advnh;
 	dev_t.cyc_aavdh_we = 3;
 	dev_t.cyc_wpl = 6;
-	dev_t.t_ce_rdyz = 7000;
 
 	gpmc_calc_timings(&t, &tusb_sync, &dev_t);
 
-- 
1.7.10.4

