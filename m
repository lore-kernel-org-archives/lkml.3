Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab3DXAGX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 20:06:23 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:39567 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756833Ab3DXAGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 20:06:19 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-sh@vger.kernel.org
Cc: linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 4/9] ARM: mach-shmobile: clock-r8a7740: add TPU PWM support
Date: Wed, 24 Apr 2013 02:06:04 +0200
Message-Id: <1366761969-16759-5-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1366761969-16759-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1366761969-16759-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Tested-by: Simon Horman <horms@verge.net.au>
---
 arch/arm/mach-shmobile/clock-r8a7740.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-shmobile/clock-r8a7740.c b/arch/arm/mach-shmobile/clock-r8a7740.c
index b12c476..a5ca9c6 100644
--- a/arch/arm/mach-shmobile/clock-r8a7740.c
+++ b/arch/arm/mach-shmobile/clock-r8a7740.c
@@ -461,7 +461,7 @@ enum {
 
 	MSTP329, MSTP328, MSTP323, MSTP320,
 	MSTP314, MSTP313, MSTP312,
-	MSTP309,
+	MSTP309, MSTP304,
 
 	MSTP416, MSTP415, MSTP407, MSTP406,
 
@@ -499,6 +499,7 @@ static struct clk mstp_clks[MSTP_NR] = {
 	[MSTP313] = SH_CLK_MSTP32(&div4_clks[DIV4_HP],	SMSTPCR3, 13, 0), /* SDHI1 */
 	[MSTP312] = SH_CLK_MSTP32(&div4_clks[DIV4_HP],	SMSTPCR3, 12, 0), /* MMC */
 	[MSTP309] = SH_CLK_MSTP32(&div4_clks[DIV4_HP],	SMSTPCR3,  9, 0), /* GEther */
+	[MSTP304] = SH_CLK_MSTP32(&div4_clks[DIV4_CP],	SMSTPCR3,  4, 0), /* TPU0 */
 
 	[MSTP416] = SH_CLK_MSTP32(&div4_clks[DIV4_HP],	SMSTPCR4, 16, 0), /* USBHOST */
 	[MSTP415] = SH_CLK_MSTP32(&div4_clks[DIV4_HP],	SMSTPCR4, 15, 0), /* SDHI2 */
@@ -596,6 +597,7 @@ static struct clk_lookup lookups[] = {
 	CLKDEV_DEV_ID("e6bd0000.mmcif",         &mstp_clks[MSTP312]),
 	CLKDEV_DEV_ID("sh-eth",			&mstp_clks[MSTP309]),
 	CLKDEV_DEV_ID("e9a00000.sh-eth",	&mstp_clks[MSTP309]),
+	CLKDEV_DEV_ID("rmob_tpu_pwm",		&mstp_clks[MSTP304]),
 
 	CLKDEV_DEV_ID("sh_mobile_sdhi.2",	&mstp_clks[MSTP415]),
 	CLKDEV_DEV_ID("e6870000.sdhi",          &mstp_clks[MSTP415]),
-- 
1.8.1.5

