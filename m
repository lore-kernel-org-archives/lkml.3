Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904AbaANA0c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:26:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53860 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602AbaANA0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:26:25 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Simon Horman <horms+renesas@verge.net.au>
Subject: [PATCH 3.4 22/27] ARM: shmobile: mackerel: Fix coherent DMA mask
Date: Mon, 13 Jan 2014 16:26:36 -0800
Message-Id: <20140114002624.010153313@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140114002623.356220317@linuxfoundation.org>
References: <20140114002623.356220317@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

commit b6328a6b7ba57fc84c38248f6f0e387e1170f1a8 upstream.

Commit 4dcfa60071b3d23f0181f27d8519f12e37cefbb9 ("ARM: DMA-API: better
handing of DMA masks for coherent allocations") added an additional
check to the coherent DMA mask that results in an error when the mask is
larger than what dma_addr_t can address.

Set the LCDC coherent DMA mask to DMA_BIT_MASK(32) instead of ~0 to fix
the problem.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-shmobile/board-mackerel.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/mach-shmobile/board-mackerel.c
+++ b/arch/arm/mach-shmobile/board-mackerel.c
@@ -422,7 +422,7 @@ static struct platform_device lcdc_devic
 	.resource	= lcdc_resources,
 	.dev	= {
 		.platform_data	= &lcdc_info,
-		.coherent_dma_mask = ~0,
+		.coherent_dma_mask = DMA_BIT_MASK(32),
 	},
 };
 
@@ -498,7 +498,7 @@ static struct platform_device hdmi_lcdc_
 	.id		= 1,
 	.dev	= {
 		.platform_data	= &hdmi_lcdc_info,
-		.coherent_dma_mask = ~0,
+		.coherent_dma_mask = DMA_BIT_MASK(32),
 	},
 };
 


