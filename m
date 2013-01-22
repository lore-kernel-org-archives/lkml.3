Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328Ab3AVQoR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 11:44:17 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:51852 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622Ab3AVQoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 11:44:15 -0500
From: Afzal Mohammed <afzal@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH 0/4] ARM: AM335x: LCDC platform support
Date: Tue, 22 Jan 2013 22:14:05 +0530
Message-ID: <cover.1358871018.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.12
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series make am335x lcdc capable of providing display.
Certain changes were required in generic OMAP clock handling
to attain it. Clock nodes in LCDC path is marked such that
rate can get propogated to upstream clocks till display PLL.

Based on 3.8-rc3.

Tested on AM335x EVM.

To test on AM335x based boards, tree
@ git://gitorious.org/x0148406-public/linux-kernel.git tags/da8xx-fb-dt-v3

Regards
Afzal

Afzal Mohammed (4):
  ARM: OMAP2+: dpll: round rate to closest value
  ARM: OMAP2+: dpll: am335x - avoid freqsel
  ARM: OMAP2+: clock: DEFINE_STRUCT_CLK_FLAGS helper
  ARM: AM33XX: clock: SET_RATE_PARENT in lcd path

 arch/arm/mach-omap2/cclock33xx_data.c | 11 ++++++-----
 arch/arm/mach-omap2/clkt_dpll.c       | 12 +++++++-----
 arch/arm/mach-omap2/clock.h           | 11 +++++++++++
 arch/arm/mach-omap2/dpll3xxx.c        |  5 +++--
 4 files changed, 27 insertions(+), 12 deletions(-)

-- 
1.7.12

