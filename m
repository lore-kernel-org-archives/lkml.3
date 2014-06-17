Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966547AbaFQVuQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:50:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54316 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966515AbaFQVuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:50:10 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Paul Walmsley <paul@pwsan.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 163/212] ARM: OMAP3: clock: Back-propagate rate change from cam_mclk to dpll4_m5 on all OMAP3 platforms
Date: Tue, 17 Jun 2014 14:44:17 -0700
Message-Id: <1403041506-13646-164-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/mach-omap2/cclock3xxx_data.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/cclock3xxx_data.c b/arch/arm/mach-omap2/cclock3xxx_data.c
index 3b05aea..807e2fc 100644
--- a/arch/arm/mach-omap2/cclock3xxx_data.c
+++ b/arch/arm/mach-omap2/cclock3xxx_data.c
@@ -454,7 +454,8 @@ static struct clk_hw_omap dpll4_m5x2_ck_hw = {
 	.clkdm_name	= "dpll4_clkdm",
 };
 
-DEFINE_STRUCT_CLK(dpll4_m5x2_ck, dpll4_m5x2_ck_parent_names, dpll4_m5x2_ck_ops);
+DEFINE_STRUCT_CLK_FLAGS(dpll4_m5x2_ck, dpll4_m5x2_ck_parent_names,
+			dpll4_m5x2_ck_ops, CLK_SET_RATE_PARENT);
 
 static struct clk dpll4_m5x2_ck_3630 = {
 	.name		= "dpll4_m5x2_ck",
-- 
1.9.1

