Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431AbaFWIwF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:52:05 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55556 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752603AbaFWIc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:29 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Paul Walmsley <paul@pwsan.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 030/111] ARM: OMAP3: clock: Back-propagate rate change from cam_mclk to dpll4_m5 on all OMAP3 platforms
Date: Mon, 23 Jun 2014 10:31:05 +0200
Message-Id: <7e84ef36ae2501e1155e9011ead7e59aadd0910d.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 98d7e1aee6dd534f468993f8c6a1bc730d4cfa81 upstream.

Commit 7b2e1277598e4187c9be3e61fd9b0f0423f97986 ("ARM: OMAP3: clock:
Back-propagate rate change from cam_mclk to dpll4_m5") enabled clock
rate back-propagation from cam_mclk do dpll4_m5 on OMAP3630 only.
Perform back-propagation on other OMAP3 platforms as well.

Reported-by: Jean-Philippe François <jp.francois@cynove.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
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
2.0.0

