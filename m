Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758247Ab3DXUup (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 16:50:45 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:45786 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758059Ab3DXUuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 16:50:39 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-sh@vger.kernel.org
Cc: linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH v2 05/11] ARM: mach-shmobile: clock-r8a7740: add TPU PWM support
Date: Wed, 24 Apr 2013 22:50:10 +0200
Message-Id: <1366836616-21475-6-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1366836616-21475-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1366836616-21475-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Tested-by: Simon Horman <horms@verge.net.au>
---
 arch/arm/mach-shmobile/clock-r8a7740.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-shmobile/clock-r8a7740.c b/arch/arm/mach-shmobile/clock-r8a7740.c
index b12c476..6ad4640 100644
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
+	CLKDEV_DEV_ID("renesas_tpu_pwm",	&mstp_clks[MSTP304]),
 
 	CLKDEV_DEV_ID("sh_mobile_sdhi.2",	&mstp_clks[MSTP415]),
 	CLKDEV_DEV_ID("e6870000.sdhi",          &mstp_clks[MSTP415]),
-- 
1.8.1.5

