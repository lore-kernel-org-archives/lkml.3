Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbaGaLWd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 07:22:33 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:55786 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbaGaLW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 07:22:29 -0400
From: Humberto Silva Naves <hsnaves@gmail.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Thomas Abraham <ta.omasab@gmail.com>,
        Andreas Farber <afaerber@suse.de>,
        Randy Dunlap <rdunlap@infradead.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Humberto Silva Naves <hsnaves@gmail.com>
Subject: [PATCHv2 0/5] clk: samsung: exynos5410: Implementation of the PLL clocks
Date: Thu, 31 Jul 2014 13:22:07 +0200
Message-Id: <1406805732-17372-1-git-send-email-hsnaves@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch series slightly improves the exynos5410 clock driver. Below is
a list of changes introduced by the patch:
 - Basic validation in the clock initialization routine
 - Added resume/suspend handler
 - Implemented some fixed rate clocks and changed the way "fin_pll" is defined
 - Added the remaining PLL clocks

Changelog since v1:
 * Split the reordering and addition of new constants  into two different
commits, as suggested by Thomas Abraham. For details, see:
http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg34950.html
 * The rate tables are only installed if the clock rate of the parent matches
a specific frequency of 24MHz. For details, please refer to:
http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg34953.html
 * Added some fixed rate clocks.

Humberto Silva Naves (5):
  clk: samsung: exynos5410: Add NULL pointer checks in clock init
  clk: samsung: exynos5410: Organize register offset constants
  clk: samsung: exynos5410: Add suspend/resume handling
  clk: samsung: exynos5410: Add fixed rate clocks
  clk: samsung: exynos5410: Added clocks DPLL, EPLL, IPLL, and VPLL

 .../devicetree/bindings/clock/exynos5410-clock.txt |   17 +-
 drivers/clk/samsung/clk-exynos5410.c               |  437 ++++++++++++++++++--
 include/dt-bindings/clock/exynos5410.h             |    5 +
 3 files changed, 430 insertions(+), 29 deletions(-)

-- 
1.7.10.4

