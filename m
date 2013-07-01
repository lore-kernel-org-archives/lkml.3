Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab3GARY3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 13:24:29 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:13854 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702Ab3GARY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 13:24:28 -0400
X-AuditID: cbfee61b-b7f8e6d00000524c-a3-51d1bb4aea45
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] DMA: Fix Marvell Orion and mv_xor after MEMSET removal
Date: Mon, 01 Jul 2013 19:24:16 +0200
Message-id: <6583540.4QCOENPlIG@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.5.0-rc2+; KDE/4.8.5; i686; ; )
In-reply-to: <20130701151720.GC19937@titan.lakedaemon.net>
References: <1372690589-2218-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <51D19CD1.3030900@gmail.com> <20130701151720.GC19937@titan.lakedaemon.net>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsVy+t9jQV2v3RcDDR7MF7OYs34Nm0Xjksss
	Fmeb3rBbbHp8jdXi8q45bBbvfzo6sHnsnHWX3aPhwHkWjxMzfrN4bF5S79G3ZRWjx+dNcgFs
	UVw2Kak5mWWpRfp2CVwZd6d2sRQ0aVR0tfWzNTCuVOxi5OCQEDCRuLVSuouRE8gUk7hwbz1b
	FyMXh5DAdEaJ/g/d7BBOC5PEgvZ9rCBVbAJWEhPbVzGC2CIC6hLnNreCdTAL3GaU+PP+HjNI
	QljAW+Lr+50sIDaLgKpE745NYA28ApoSpxpPgA0SFbCX2PbuLRuIzQk0dPfjJrBeIYHZjBIz
	b8pD1AtK/Jh8D2wOs4C8xL79U1khbC2J9TuPM01gFJiFpGwWkrJZSMoWMDKvYhRNLUguKE5K
	zzXSK07MLS7NS9dLzs/dxAgO8WfSOxhXNVgcYhTgYFTi4VWYdzFQiDWxrLgy9xCjBAezkgjv
	TW+gEG9KYmVValF+fFFpTmrxIUZpDhYlcd6DrdaBQgLpiSWp2ampBalFMFkmDk6pBkaN1ouN
	L4Mj7u6xSrzLNYkt/tHWaCGPv9dn6TotT0lpjtcUdpkt2PzJyteeMSLoXOaF9YlPApUy3Le8
	nMpa9c3+r9LdZCaRO4xzdy/43aF7avX6TsddS6Nc/gSp/J27bumzGYnp3teUlH/NX3nF9Y3K
	B/W/bSG2vz+9ltEvWOA11c/RwYG7MUmJpTgj0VCLuag4EQBaeYZObQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Monday, July 01, 2013 11:17:20 AM Jason Cooper wrote:
> On Mon, Jul 01, 2013 at 05:14:25PM +0200, Sebastian Hesselbarth wrote:
> > On 07/01/13 17:04, Jason Cooper wrote:
> > >On Mon, Jul 01, 2013 at 04:56:29PM +0200, Sebastian Hesselbarth wrote:
> > >>Commit 834cbfe966bece50afded79da8e975d255bf0772
> > >>  ("drivers/dma: remove unused support for MEMSET operations")
> > >>removes MEMSET from dmaengine but does not completely removes it from
> > >>Marvell Orion (arch/arm/plat-orion) and XOR (drivers/dma/mv_xor).
> > >>This also fixes some compiler warnings about now obsolete functions by
> > >>removing those.
> > >>
> > >>Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> > >>---
> > >>Cc: Jason Cooper <jason@lakedaemon.net>
> > >>Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > >>Cc: Kyungmin Park <kyungmin.park@samsung.com>
> > >>Cc: Andrew Morton <akpm@linux-foundation.org>
> > >>Cc: linux-arm-kernel@lists.infradead.org
> > >>Cc: linux-kernel@vger.kernel.org
> > >>---
> > >>  arch/arm/plat-orion/common.c |    6 ------
> > >>  drivers/dma/mv_xor.c         |   25 +------------------------
> > >>  2 files changed, 1 insertions(+), 30 deletions(-)
> > >
> > >Please take a look at the email from lkml I just forwarded to you.  I
> > >believe this solves your problem, but I don't have time to look closely
> > >atm.
> > 
> > Jason,
> > 
> > I have seen the forwarded patch before. I don't know what version this
> > is based on. Some of the modifications are in next-20130701, some are
> > not. I have stripped the Marvell modifications from the patch you
> > forwarded and fixed all remaining issues.
> > 
> > Also, I will sent a follow-up patch to remove memset references from
> > Marvell SoC dts/dtsi and the binding documentation soon.
> > 
> > I guess, Bartolomiej should pick them up and resend his patch set, or
> > leave Marvell alone and you pick them up.
> 
> If Bartolomiej doesn't take it, please split your changes into two
> patches, one for plat-orion, and one for drivers.

Andrew has already applied incremental patch fixing build problems to his
tree (though it is not yet in linux-next):

	http://www.ozlabs.org/~akpm/mmots/broken-out/drivers-dma-remove-unused-support-for-memset-operations-v3.patch

The rest of changes from Sebastian are contained in another incremental
patch which I've attached to this mail. They can be also folded into
the first patch (which is what Andrew will probably do before sending them
to Linus).

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics


From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: [PATCH] DMA: Fix mv_xor after MEMSET removal

Commit 834cbfe ("drivers/dma: remove unused support for MEMSET operations")
removes MEMSET from dmaengine but does not completely removes it from
drivers/dma/mv_xor.

This also fixes some compiler warnings about now obsolete functions by
removing those.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
[bzolnier: splitted off changes from bigger patch]
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/dma/mv_xor.c |   23 +----------------------
 1 file changed, 1 insertion(+), 22 deletions(-)

Index: b/drivers/dma/mv_xor.c
===================================================================
--- a/drivers/dma/mv_xor.c	2013-07-01 18:53:12.113317468 +0200
+++ b/drivers/dma/mv_xor.c	2013-07-01 18:56:07.273317119 +0200
@@ -89,11 +89,6 @@ static void mv_desc_clear_next_desc(stru
 	hw_desc->phy_next_desc = 0;
 }
 
-static void mv_desc_set_block_fill_val(struct mv_xor_desc_slot *desc, u32 val)
-{
-	desc->value = val;
-}
-
 static void mv_desc_set_dest_addr(struct mv_xor_desc_slot *desc,
 				  dma_addr_t addr)
 {
@@ -128,22 +123,6 @@ static void mv_chan_set_next_descriptor(
 	__raw_writel(next_desc_addr, XOR_NEXT_DESC(chan));
 }
 
-static void mv_chan_set_dest_pointer(struct mv_xor_chan *chan, u32 desc_addr)
-{
-	__raw_writel(desc_addr, XOR_DEST_POINTER(chan));
-}
-
-static void mv_chan_set_block_size(struct mv_xor_chan *chan, u32 block_size)
-{
-	__raw_writel(block_size, XOR_BLOCK_SIZE(chan));
-}
-
-static void mv_chan_set_value(struct mv_xor_chan *chan, u32 value)
-{
-	__raw_writel(value, XOR_INIT_VALUE_LOW(chan));
-	__raw_writel(value, XOR_INIT_VALUE_HIGH(chan));
-}
-
 static void mv_chan_unmask_interrupts(struct mv_xor_chan *chan)
 {
 	u32 val = __raw_readl(XOR_INTR_MASK(chan));
@@ -1134,7 +1113,7 @@ mv_xor_channel_add(struct mv_xor_device
 			goto err_free_irq;
 	}
 
-	dev_info(&pdev->dev, "Marvell XOR: ( %s%s%s%s)\n",
+	dev_info(&pdev->dev, "Marvell XOR: ( %s%s%s)\n",
 		 dma_has_cap(DMA_XOR, dma_dev->cap_mask) ? "xor " : "",
 		 dma_has_cap(DMA_MEMCPY, dma_dev->cap_mask) ? "cpy " : "",
 		 dma_has_cap(DMA_INTERRUPT, dma_dev->cap_mask) ? "intr " : "");

