Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035AbaKGOPU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 09:15:20 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54369 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752925AbaKGOPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 09:15:17 -0500
Message-ID: <545CD3D3.9000608@arm.com>
Date: Fri, 07 Nov 2014 14:14:43 +0000
From: Andrew Jackson <Andrew.Jackson@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 3/5] serial: pl011: Set length of DMA transfer
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The DMA engines on some systems require that the dma_length is set
when using scatter gather lists.

Signed-off-by: Andrew Jackson <Andrew.Jackson@arm.com>
---
 drivers/tty/serial/amba-pl011.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index d8d067a..7c5e263 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -246,6 +246,7 @@ static int pl011_sgbuf_init(struct dma_chan *chan, struct pl011_sgbuf *sg,
 	sg_set_page(&sg->sg, phys_to_page(dma_addr),
 		PL011_DMA_BUFFER_SIZE, offset_in_page(dma_addr));
 	sg_dma_address(&sg->sg) = dma_addr;
+	sg_dma_len(&sg->sg) = PL011_DMA_BUFFER_SIZE;
 
 	return 0;
 }
-- 
1.7.1

