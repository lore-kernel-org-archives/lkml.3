Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933897AbaFIWpq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 18:45:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56773 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933368AbaFIWp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:45:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Peter Ujfalusi <peter.ujfalusi@ti.com>, Paul Walmsley <paul@pwsan.com>
Subject: [PATCH 3.14 18/78] ARM: omap5: hwmod_data: Correct IDLEMODE for McPDM
Date: Mon,  9 Jun 2014 15:47:58 -0700
Message-Id: <20140609224813.947922503@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140609224813.282275135@linuxfoundation.org>
References: <20140609224813.282275135@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@ti.com>

commit 0f9e19ad88eee820f517b85531b555a0fa73e7e4 upstream.

McPDM need to be configured to NO_IDLE mode when it is in used otherwise
vital clocks will be gated which results 'slow motion' audio playback.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-omap2/omap_hwmod_54xx_data.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mach-omap2/omap_hwmod_54xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_54xx_data.c
@@ -895,7 +895,7 @@ static struct omap_hwmod omap54xx_mcpdm_
 	 * current exception.
 	 */
 
-	.flags		= HWMOD_EXT_OPT_MAIN_CLK,
+	.flags		= HWMOD_EXT_OPT_MAIN_CLK | HWMOD_SWSUP_SIDLE,
 	.main_clk	= "pad_clks_ck",
 	.prcm = {
 		.omap4 = {


