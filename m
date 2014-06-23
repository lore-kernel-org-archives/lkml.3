Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136AbaFWIrd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:47:33 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55561 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752577AbaFWIc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:29 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Paul Walmsley <paul@pwsan.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 029/111] ARM: omap5: hwmod_data: Correct IDLEMODE for McPDM
Date: Mon, 23 Jun 2014 10:31:04 +0200
Message-Id: <d0c827e617439816bab3a434835be8a68b66a570.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Ujfalusi <peter.ujfalusi@ti.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 0f9e19ad88eee820f517b85531b555a0fa73e7e4 upstream.

McPDM need to be configured to NO_IDLE mode when it is in used otherwise
vital clocks will be gated which results 'slow motion' audio playback.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/arm/mach-omap2/omap_hwmod_54xx_data.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod_54xx_data.c b/arch/arm/mach-omap2/omap_hwmod_54xx_data.c
index cde415570e04..6bbb1e679e30 100644
--- a/arch/arm/mach-omap2/omap_hwmod_54xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_54xx_data.c
@@ -895,7 +895,7 @@ static struct omap_hwmod omap54xx_mcpdm_hwmod = {
 	 * current exception.
 	 */
 
-	.flags		= HWMOD_EXT_OPT_MAIN_CLK,
+	.flags		= HWMOD_EXT_OPT_MAIN_CLK | HWMOD_SWSUP_SIDLE,
 	.main_clk	= "pad_clks_ck",
 	.prcm = {
 		.omap4 = {
-- 
2.0.0

