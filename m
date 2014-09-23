Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932401AbaIWPEq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 11:04:46 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51039 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109AbaIWPEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 11:04:44 -0400
Date: Tue, 23 Sep 2014 23:04:28 +0800
From: Huang Shijie <shijie8@gmail.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mike Voytovich <mvoytovich@paypal.com>, Roy Lee <roylee@paypal.com>
Subject: Re: [PATCH v3 1/3] mtd: nand: gpmi: add gpmi_move_bits function
Message-ID: <20140923150427.GB1633@localhost.localdomain>
References: <1411481256-29141-1-git-send-email-boris.brezillon@free-electrons.com>
 <1411481256-29141-2-git-send-email-boris.brezillon@free-electrons.com>
 <20140923145413.GA1633@localhost.localdomain>
 <20140923165822.27cfde69@bbrezillon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140923165822.27cfde69@bbrezillon>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 04:58:22PM +0200, Boris BREZILLON wrote:
> On Tue, 23 Sep 2014 22:54:15 +0800
> Huang Shijie <shijie8@gmail.com> wrote:
> 
> > On Tue, Sep 23, 2014 at 04:07:34PM +0200, Boris BREZILLON wrote:
> > > Add a new function to move bits (not bytes) from a memory region to
> > > another one.
> > > This function is similar to memmove except it acts at bit level.
> > > This function is needed to implement GPMI raw access functions, given the
> > > fact that ECC engine does not pad ECC bits to the next byte boundary.
> > sorry for not comment your v2 patch set.
> > 
> > > 
> > > Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> > > ---
> > >  drivers/mtd/nand/gpmi-nand/gpmi-lib.c  | 88 ++++++++++++++++++++++++++++++++++
> > >  drivers/mtd/nand/gpmi-nand/gpmi-nand.h |  4 ++
> > >  2 files changed, 92 insertions(+)
> > > 
> > > diff --git a/drivers/mtd/nand/gpmi-nand/gpmi-lib.c b/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
> > > index 87e658c..e2f706a 100644
> > > --- a/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
> > > +++ b/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
> > > @@ -1353,3 +1353,91 @@ int gpmi_read_page(struct gpmi_nand_data *this,
> > >  	set_dma_type(this, DMA_FOR_READ_ECC_PAGE);
> > >  	return start_dma_with_bch_irq(this, desc);
> > >  }
> > > +
> > > +void gpmi_move_bits(u8 *dst, size_t dst_bit_off,
> > > +		    const u8 *src, size_t src_bit_off,
> > > +		    size_t nbits)
> > we can simplify the code.
> 
> Any suggestions ?
> 
> > 
> > We could use the bytes to replace the @nbits.
> > 
> > The chunk data is always byte aligned.
> 
> This function is also used to store ECC bits in the OOB buffer and
> these chunk of data are not byte aligned :-).
yes. you are right. I missed it.

could you also comment these two hooks in the patch set.

I hope Brian also can check it, and we can make it more clear about how
to implement them.


thanks
Huang Shijie
