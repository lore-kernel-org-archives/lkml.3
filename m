Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbaANA1q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:27:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54085 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321AbaANA1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:27:25 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Simon Horman <horms+renesas@verge.net.au>
Subject: [PATCH 3.10 43/62] ARM: shmobile: mackerel: Fix coherent DMA mask
Date: Mon, 13 Jan 2014 16:27:08 -0800
Message-Id: <20140114002711.684374595@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140114002710.464561569@linuxfoundation.org>
References: <20140114002710.464561569@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -421,7 +421,7 @@ static struct platform_device lcdc_devic
 	.resource	= lcdc_resources,
 	.dev	= {
 		.platform_data	= &lcdc_info,
-		.coherent_dma_mask = ~0,
+		.coherent_dma_mask = DMA_BIT_MASK(32),
 	},
 };
 
@@ -497,7 +497,7 @@ static struct platform_device hdmi_lcdc_
 	.id		= 1,
 	.dev	= {
 		.platform_data	= &hdmi_lcdc_info,
-		.coherent_dma_mask = ~0,
+		.coherent_dma_mask = DMA_BIT_MASK(32),
 	},
 };
 


