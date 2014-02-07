Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250AbaBGLsB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:48:01 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41436 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716AbaBGLr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:47:56 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 013/233] ARM: shmobile: kzm9g: Fix coherent DMA mask
Date: Fri,  7 Feb 2014 11:43:52 +0000
Message-Id: <1391773652-25214-14-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

commit 4f387323853c495ac589210832fad4503f75a0e7 upstream.

Commit 4dcfa60071b3d23f0181f27d8519f12e37cefbb9 ("ARM: DMA-API: better
handing of DMA masks for coherent allocations") added an additional
check to the coherent DMA mask that results in an error when the mask is
larger than what dma_addr_t can address.

Set the LCDC coherent DMA mask to DMA_BIT_MASK(32) instead of ~0 to fix
the problem.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/mach-shmobile/board-kzm9g.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-shmobile/board-kzm9g.c b/arch/arm/mach-shmobile/board-kzm9g.c
index 1068120..66cac20 100644
--- a/arch/arm/mach-shmobile/board-kzm9g.c
+++ b/arch/arm/mach-shmobile/board-kzm9g.c
@@ -334,7 +334,7 @@ static struct platform_device lcdc_device = {
 	.resource	= lcdc_resources,
 	.dev	= {
 		.platform_data	= &lcdc_info,
-		.coherent_dma_mask = ~0,
+		.coherent_dma_mask = DMA_BIT_MASK(32),
 	},
 };
 
-- 
1.8.3.2

