Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758374Ab3DXUw4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 16:52:56 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:45786 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758077Ab3DXUuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 16:50:40 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-sh@vger.kernel.org
Cc: linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH v2 06/11] ARM: mach-shmobile: clock-r8a7790: add TPU PWM support
Date: Wed, 24 Apr 2013 22:50:11 +0200
Message-Id: <1366836616-21475-7-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1366836616-21475-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1366836616-21475-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 arch/arm/mach-shmobile/clock-r8a7790.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-shmobile/clock-r8a7790.c b/arch/arm/mach-shmobile/clock-r8a7790.c
index bedd20c..b393592 100644
--- a/arch/arm/mach-shmobile/clock-r8a7790.c
+++ b/arch/arm/mach-shmobile/clock-r8a7790.c
@@ -48,6 +48,7 @@
 #define CPG_LEN 0x1000
 
 #define SMSTPCR2 0xe6150138
+#define SMSTPCR3 0xe615013c
 #define SMSTPCR7 0xe615014c
 
 #define MODEMR		0xE6160060
@@ -178,11 +179,17 @@ static struct clk div6_clks[DIV6_NR] = {
 };
 
 /* MSTP */
-enum { MSTP721, MSTP720,
-	MSTP216, MSTP207, MSTP206, MSTP204, MSTP203, MSTP202, MSTP_NR };
+enum {
+	MSTP721, MSTP720,
+	MSTP304,
+	MSTP216, MSTP207, MSTP206, MSTP204, MSTP203, MSTP202,
+	MSTP_NR
+};
+
 static struct clk mstp_clks[MSTP_NR] = {
 	[MSTP721] = SH_CLK_MSTP32(&p_clk, SMSTPCR7, 21, 0), /* SCIF0 */
 	[MSTP720] = SH_CLK_MSTP32(&p_clk, SMSTPCR7, 20, 0), /* SCIF1 */
+	[MSTP304] = SH_CLK_MSTP32(&cp_clk, SMSTPCR3, 4, 0), /* TPU0 */
 	[MSTP216] = SH_CLK_MSTP32(&mp_clk, SMSTPCR2, 16, 0), /* SCIFB2 */
 	[MSTP207] = SH_CLK_MSTP32(&mp_clk, SMSTPCR2, 7, 0), /* SCIFB1 */
 	[MSTP206] = SH_CLK_MSTP32(&mp_clk, SMSTPCR2, 6, 0), /* SCIFB0 */
-- 
1.8.1.5

