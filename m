Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543AbaIWO63 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 10:58:29 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58882 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756526AbaIWO6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 10:58:25 -0400
Date: Tue, 23 Sep 2014 16:58:22 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Huang Shijie <shijie8@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mike Voytovich <mvoytovich@paypal.com>, Roy Lee <roylee@paypal.com>
Subject: Re: [PATCH v3 1/3] mtd: nand: gpmi: add gpmi_move_bits function
Message-ID: <20140923165822.27cfde69@bbrezillon>
In-Reply-To: <20140923145413.GA1633@localhost.localdomain>
References: <1411481256-29141-1-git-send-email-boris.brezillon@free-electrons.com>
	<1411481256-29141-2-git-send-email-boris.brezillon@free-electrons.com>
	<20140923145413.GA1633@localhost.localdomain>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Sep 2014 22:54:15 +0800
Huang Shijie <shijie8@gmail.com> wrote:

> On Tue, Sep 23, 2014 at 04:07:34PM +0200, Boris BREZILLON wrote:
> > Add a new function to move bits (not bytes) from a memory region to
> > another one.
> > This function is similar to memmove except it acts at bit level.
> > This function is needed to implement GPMI raw access functions, given the
> > fact that ECC engine does not pad ECC bits to the next byte boundary.
> sorry for not comment your v2 patch set.
> 
> > 
> > Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> > ---
> >  drivers/mtd/nand/gpmi-nand/gpmi-lib.c  | 88 ++++++++++++++++++++++++++++++++++
> >  drivers/mtd/nand/gpmi-nand/gpmi-nand.h |  4 ++
> >  2 files changed, 92 insertions(+)
> > 
> > diff --git a/drivers/mtd/nand/gpmi-nand/gpmi-lib.c b/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
> > index 87e658c..e2f706a 100644
> > --- a/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
> > +++ b/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
> > @@ -1353,3 +1353,91 @@ int gpmi_read_page(struct gpmi_nand_data *this,
> >  	set_dma_type(this, DMA_FOR_READ_ECC_PAGE);
> >  	return start_dma_with_bch_irq(this, desc);
> >  }
> > +
> > +void gpmi_move_bits(u8 *dst, size_t dst_bit_off,
> > +		    const u8 *src, size_t src_bit_off,
> > +		    size_t nbits)
> we can simplify the code.

Any suggestions ?

> 
> We could use the bytes to replace the @nbits.
> 
> The chunk data is always byte aligned.

This function is also used to store ECC bits in the OOB buffer and
these chunk of data are not byte aligned :-).

> 
> 
> Btw: please add more comments in this function.

Yep, I should definitely comment it, and I'll do.

Best Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
