Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab3H0JbZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 05:31:25 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:65281 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877Ab3H0JbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 05:31:20 -0400
Date: Tue, 27 Aug 2013 11:31:18 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: "Koul, Vinod" <vinod.koul@intel.com>
cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [PATCH] DMA: shdma: fix compiler warning after a bad merge
Message-ID: <Pine.LNX.4.64.1308271130360.11515@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:1ieRfZyJeQGnBN8ZSyvyll2b64bx9TzfnHvSlHRDH0e
 cbeetHrSUdTPbTbT9b8+jvWPBYt03iTIqgMFmz4VlSiG96OOwR
 pJrfkDqm7yAFJR/OmSwZWayyxBgB3Uo/UEz/NeAQiDCeBG9G0I
 OI0F0uEijcS963kzT0BFpxL8z7LWGA7Ts4ehQxPinBsFDJ4TAd
 ezzmhdmt5V/1C0AnwZ1aDvLovjjmsag7wWij4IpzG0EORUyT2O
 iW5JhQmguFKFEtbYPl3P5HGCBCkQg7uPsFtpuwiB011jZumPXg
 ZkLPj2P21y4KoCF20K06ejqmG4yE2EtD8qpoEggVyNmEDDnQjW
 58qZ6qV1XKHxMSzyv0VwBsoBh77+570QH39RQa2PiTF3IRiE1S
 +OrrxJdTtG5yg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A recent merge commit

commit ba1e06e3dff9a0bb0758d169e50cbb04a67a402c
Author: Vinod Koul <vinod.koul@intel.com>

    Merge branch 'topic/sh' into next

introduced a compiler warning:

drivers/dma/sh/shdmac.c: In function 'sh_dmae_probe':
drivers/dma/sh/shdmac.c:697: warning: assignment discards qualifiers from pointer target type

This patch re-adds the dropped "const" qualifier and fixes the warning.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
---
 drivers/dma/sh/shdmac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/sh/shdmac.c b/drivers/dma/sh/shdmac.c
index dcd344e..1069e88 100644
--- a/drivers/dma/sh/shdmac.c
+++ b/drivers/dma/sh/shdmac.c
@@ -684,7 +684,7 @@ MODULE_DEVICE_TABLE(of, sh_dmae_of_match);
 
 static int sh_dmae_probe(struct platform_device *pdev)
 {
-	struct sh_dmae_pdata *pdata;
+	const struct sh_dmae_pdata *pdata;
 	unsigned long irqflags = IRQF_DISABLED,
 		chan_flag[SH_DMAE_MAX_CHANNELS] = {};
 	int errirq, chan_irq[SH_DMAE_MAX_CHANNELS];
-- 
1.7.2.5

