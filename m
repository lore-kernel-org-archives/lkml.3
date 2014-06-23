Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbaFWND4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:03:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36774 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799AbaFWNDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:03:52 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Paul Walmsley <paul@pwsan.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 22/93] ARM: OMAP3: clock: Back-propagate rate change from cam_mclk to dpll4_m5 on all OMAP3 platforms
Date: Mon, 23 Jun 2014 14:02:01 +0100
Message-Id: <1403528592-2163-23-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
References: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

commit 98d7e1aee6dd534f468993f8c6a1bc730d4cfa81 upstream.

Commit 7b2e1277598e4187c9be3e61fd9b0f0423f97986 ("ARM: OMAP3: clock:
Back-propagate rate change from cam_mclk to dpll4_m5") enabled clock
rate back-propagation from cam_mclk do dpll4_m5 on OMAP3630 only.
Perform back-propagation on other OMAP3 platforms as well.

Reported-by: Jean-Philippe François <jp.francois@cynove.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/mach-omap2/cclock3xxx_data.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/cclock3xxx_data.c b/arch/arm/mach-omap2/cclock3xxx_data.c
index 334b76745900..9128b2553ca5 100644
--- a/arch/arm/mach-omap2/cclock3xxx_data.c
+++ b/arch/arm/mach-omap2/cclock3xxx_data.c
@@ -418,7 +418,8 @@ static struct clk_hw_omap dpll4_m5x2_ck_hw = {
 	.clkdm_name	= "dpll4_clkdm",
 };
 
-DEFINE_STRUCT_CLK(dpll4_m5x2_ck, dpll4_m5x2_ck_parent_names, dpll4_m5x2_ck_ops);
+DEFINE_STRUCT_CLK_FLAGS(dpll4_m5x2_ck, dpll4_m5x2_ck_parent_names,
+			dpll4_m5x2_ck_ops, CLK_SET_RATE_PARENT);
 
 static struct clk dpll4_m5x2_ck_3630 = {
 	.name		= "dpll4_m5x2_ck",
-- 
1.9.1

