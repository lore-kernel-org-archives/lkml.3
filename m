Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179Ab3KALjI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 07:39:08 -0400
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:31023
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756001Ab3KALga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 07:36:30 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 6
X-BigFish: VS6(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6h1082kz70kz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h1155h)
From: Nicolin Chen <b42378@freescale.com>
To: <akpm@linux-foundation.org>, <joe@perches.com>, <nsekhar@ti.com>,
        <khilman@deeprootsystems.com>, <linux@arm.linux.org.uk>,
        <dan.j.williams@intel.com>, <vinod.koul@intel.com>,
        <m.chehab@samsung.com>, <hjk@hansjkoch.de>,
        <gregkh@linuxfoundation.org>, <perex@perex.cz>, <tiwai@suse.de>,
        <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <rmk+kernel@arm.linux.org.uk>, <eric.y.miao@gmail.com>,
        <haojian.zhuang@gmail.com>
CC: <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>, <dmaengine@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <alsa-devel@alsa-project.org>
Subject: [PATCH 2/8] ARM: davinci: use gen_pool_dma_alloc() to sram.c
Date: Fri, 1 Nov 2013 19:36:00 +0800
Message-ID: <9536ee2bbb1a8463ebb21068a750b61fa59900df.1383303752.git.b42378@freescale.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <cover.1383303752.git.b42378@freescale.com>
References: <cover.1383303752.git.b42378@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since gen_pool_dma_alloc() is introduced, we implement it to simplify code.

Signed-off-by: Nicolin Chen <b42378@freescale.com>
---
 arch/arm/mach-davinci/sram.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/arch/arm/mach-davinci/sram.c b/arch/arm/mach-davinci/sram.c
index f18928b..8540ddd 100644
--- a/arch/arm/mach-davinci/sram.c
+++ b/arch/arm/mach-davinci/sram.c
@@ -25,7 +25,6 @@ struct gen_pool *sram_get_gen_pool(void)
 
 void *sram_alloc(size_t len, dma_addr_t *dma)
 {
-	unsigned long vaddr;
 	dma_addr_t dma_base = davinci_soc_info.sram_dma;
 
 	if (dma)
@@ -33,13 +32,7 @@ void *sram_alloc(size_t len, dma_addr_t *dma)
 	if (!sram_pool || (dma && !dma_base))
 		return NULL;
 
-	vaddr = gen_pool_alloc(sram_pool, len);
-	if (!vaddr)
-		return NULL;
-
-	if (dma)
-		*dma = gen_pool_virt_to_phys(sram_pool, vaddr);
-	return (void *)vaddr;
+	return gen_pool_dma_alloc(sram_pool, len, dma);
 
 }
 EXPORT_SYMBOL(sram_alloc);
-- 
1.8.4


