Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565AbaKTSOi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 13:14:38 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:43057 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755887AbaKTSOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 13:14:37 -0500
Date: Thu, 20 Nov 2014 10:14:33 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        Huang Shijie <shijie8@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mike Voytovich <mvoytovich@paypal.com>, Roy Lee <roylee@paypal.com>
Subject: Re: [PATCH v4 2/4] mtd: nand: gpmi: add gpmi_move_bits function
Message-ID: <20141120181433.GF24364@ld-irv-0074>
References: <1413794777-32220-1-git-send-email-boris.brezillon@free-electrons.com>
 <1413794777-32220-3-git-send-email-boris.brezillon@free-electrons.com>
 <20141120092209.GD3212@norris-Latitude-E6410>
 <20141120104253.23b543d8@bbrezillon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141120104253.23b543d8@bbrezillon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 10:42:53AM +0100, Boris Brezillon wrote:
> On Thu, 20 Nov 2014 01:22:09 -0800 Brian Norris <computersforpeace@gmail.com> wrote:
> > On Mon, Oct 20, 2014 at 10:46:15AM +0200, Boris Brezillon wrote:
> > > Add a new function to move bits (not bytes) from a memory region to
> > > another one.
> > > This function is similar to memmove except it acts at bit level.
> > > This function is needed to implement GPMI raw access functions, given the
> > > fact that ECC engine does not pad ECC bits to the next byte boundary.
> > > 
> > > Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> > > ---
> > >  drivers/mtd/nand/gpmi-nand/gpmi-lib.c  | 129 +++++++++++++++++++++++++++++++++
> > >  drivers/mtd/nand/gpmi-nand/gpmi-nand.h |   4 +
> > >  2 files changed, 133 insertions(+)
> > > 
> > > diff --git a/drivers/mtd/nand/gpmi-nand/gpmi-lib.c b/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
> > > index 87e658c..5d4f140 100644
> > > --- a/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
> > > +++ b/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
> > > @@ -1353,3 +1353,132 @@ int gpmi_read_page(struct gpmi_nand_data *this,
> > >  	set_dma_type(this, DMA_FOR_READ_ECC_PAGE);
> > >  	return start_dma_with_bch_irq(this, desc);
> > >  }
> > > +
> > > +void gpmi_move_bits(u8 *dst, size_t dst_bit_off,
> > > +		    const u8 *src, size_t src_bit_off,
> > > +		    size_t nbits)
> > 
> > Two things:
> > 
> >  1) Yikes! This function is a little hairy.
> 
> Yes I know, and if you see a much simpler algorithm to do that, I'm
> really interested :-).

No ideas at the moment :)

> >  2) This function really deserves a full comment header (kerneldoc?); it
> >  needs to have clearly-documented high-level semantics.
> 
> I'll add a kernel doc header.
> 
> > 
> > I'm not sure how to address #1, as the complexity is necessary. Did you
> > run this through some unit tests, at least?
> 
> No, but I did test it with several ECC configs.
> Anyway, if I develop such unit tests, do you want me to put them in the
> driver code (under an #ifdef section) ?

I dunno, that seems like it might just clutter the file more, and I'm
not sure if anyone is likely to run them. I was mostly curious how you've
verified it.

Brian
