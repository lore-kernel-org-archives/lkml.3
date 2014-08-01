Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499AbaHAJ1h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 05:27:37 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:64450 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbaHAJ1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 05:27:34 -0400
Date: Fri, 1 Aug 2014 10:27:25 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Brian Norris <computersforpeace@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, "Gupta, Pekon\"" <pekon@ti.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        Boris BREZILLON <b.brezillon.dev@gmail.com>
Subject: Re: [PATCH] mtd: nand: stm_nand_bch: add new driver
Message-ID: <20140801092725.GN9030@lee--X1>
References: <1401268805-26043-1-git-send-email-lee.jones@linaro.org>
 <20140703002237.GM3599@ld-irv-0074>
 <20140731164709.GK9030@lee--X1>
 <20140731175427.GO3711@ld-irv-0074>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140731175427.GO3711@ld-irv-0074>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jul 2014, Brian Norris wrote:
> On Thu, Jul 31, 2014 at 05:47:09PM +0100, Lee Jones wrote:
> > Finally getting round to this ...
> 
> Sounds like me :)

:)

> > On Wed, 02 Jul 2014, Brian Norris wrote:
> > > On Wed, May 28, 2014 at 10:20:05AM +0100, Lee Jones wrote:
> > > > This is a squashed version of the submission to avoid re-sending the
> > > > entire set over and over, essentially clogging up the MLs.
> > > 
> > > Thanks. I think I'd prefer to accept your driver in a form like this
> > > too.
> > 
> > You mean squashed?  I'd _really_ like _not_ to do that.
> 
> Any particular reason? Just to bump your patch count? ;) A half-finished
> driver is not really bisectable.

I'd be lying if I said that it wasn't a consideration.  I have put
more hours into this one driver than I would have 10 others.  The
bumping of the patch count, as you call it would closer reflect the
effort put in.

But actually I initially split this patch-set up after a review
comment you provided during the upstreaming process of the FSM NOR
driver.  You mentioned that breaking up the driver made it easier to
review as I guess you could review a couple of patches, then take a
break without the fear of duplicated work.

Admittedly, I went a little overboard with this submission - it
appears that I underestimated the size of the driver and subsequently
misjudged the function split.

> > We've spoken
> > about this in reasonable depth before.  I agreed to squash it for this
> > review to keep the submissions nice and light, but we did have an
> > agreement that once accepted the final delivery could be via
> > pull-request.  I'd really like it if you honoured that.
> 
> I don't recall the part about final delivery, but that's what happens
> via informal and unlogged communication like IRC, I guess. As I recall,
> I just mentioned that you could link people to your git history if you
> felt it was still useful.
> 
> Anyway, as long as the review process is sane (1 new driver = small
> number of patches), then I don't particularly mind how the final
> delivery comes.
> 
> > I can pull the vendor specific (rather than
> > legacy :) ) BBT handling out and protect it with a CONFIG option.
> 
> A CONFIG option perhaps; but you also might need to specify what
> 'nand-on-flash-bbt' means in your DT. Personally, I'd prefer that
> 'nand-on-flash-bbt' refers only to one of the BBT's found in nand_bbt.c.
> Maybe you could extend nand-on-flash-bbt to have a value, like:
> 
> 	nand-on-flash-bbt = "ST";
> 
> Just a thought. I don't know if this is overdesign, or proper DT safety
> (the whole "DT as ABI" thing is tricky, especially when dealing with
> softer things like this).

I'm not sure it means anything to us specifically.  I think we're only
specifying it to keep the framework quiet.  If using the vendor
specific BBT, then the factory set BBT is always scanned for and the
resultant BBT it's always stored in-band (i.e. in flash).  If using
the framework's version of BBT, then NAND_BBT_USE_FLASH will mean the
same thing as it does everywhere else.

> > > >  Documentation/devicetree/bindings/mtd/stm-nand.txt |   87 +
> > > 
> > > See:
> > > 
> > >   Documentation/devicetree/bindings/submitting-patches.txt
> > 
> > This file doesn't exist.  What are you referencing?
> 
> commit 2a9330010bea5982a5c6593824bc036bf62d67b7
> Author: Jason Cooper <jason@lakedaemon.net>
> Date:   Tue Dec 17 16:59:40 2013 +0000
> 
>     dt/bindings: submitting patches and ABI documents

Ah, looks like I need to rebase this branch.  Jeez, this (NAND BCH)
patch-set has been around since forever!

> > > You're missing devicetree@vger.kernel.org on CC, and the binding doc
> > > needs a separate patch. (Sorry if I confused this one earlier.)
> > 
> > The binding document will certainly be a separate patch.  This patch
> > is the 'everything squashed' version which was requested.
> 
> I was only referring to the driver. For the DT guys' sake, you should
> still follow their rules for patch review.

So yes, I am fully aware of the rules about submitting drivers
containing DT bindings.  As mentioned before, I have no intention of
sending this whole series as onebigpatch (TM).

> > > >  arch/arm/boot/dts/stih41x-b2020.dtsi               |   40 +
> > > 
> > > This will need refreshed and sent as a separate patch, to go through the
> > > appropriate ARM tree.
> > 
> > As above.
> 
> OK, if you're really planning to send a final git pull request, you'll
> need to have this in a separate branch for them to take, then.

Of course.  Same goes with the DTS(I) changes.

> > > > diff --git a/Documentation/devicetree/bindings/mtd/stm-nand.txt b/Documentation/devicetree/bindings/mtd/stm-nand.txt
> > > > new file mode 100644
> > > > index 0000000..d957f49
> > > > --- /dev/null
> > > > +++ b/Documentation/devicetree/bindings/mtd/stm-nand.txt
> > > > @@ -0,0 +1,87 @@
> > > > +STM BCH NAND Support
> > > > +--------------------
> > > > +
> > > > +Required properties:
> > > > +
> > > > +- compatible		: Should be "st,nand-bch"
> > > > +- reg			: Should contain register's location and length
> > > > +- reg-names		: "nand_mem" - NAND Controller register map
> > > > +			  "nand_dma" - BCH Controller DMA configuration map
> > > > +- interrupts		: Interrupt number
> > > > +- interrupt-names	: "nand_irq" - NAND Controller IRQ
> > > > +- st,nand-banks		: Subnode representing one or more "banks" of NAND
> > > > +			  Flash, connected to an STM NAND Controller (see
> > > > +			  description below).
> > > > +- nand-ecc-strength	: Generic NAND property (See mtd/nand.txt)
> > > > +			  Options are; 0, 18, 30 or 0xFF (AUTO)
> > > 
> > > What is 0xFF (AUTO)?
> 
> Could you answer this one? IIRC, 0xff (AUTO) could easily be replaced by
> language that "If nand-ecc-strength is not present", software is free to
> auto-select the ECC strength. That removes this non-intuitive special
> value.

Yes, that's exactly what should happen.  Will fix.

> Also, nand-ecc-strength should probably be paired with
> nand-ecc-step-size, otherwise it doesn't really have any meaning.

Will look into it.

> ...
> > > > +Example:
> > > > +
> ...
> > > > +	nand_banks: nand-banks {
> > > > +		bank0 {
> ...
> > > > +			partitions {
> ...
> > > > +				partition@0{
> > > > +					label = "NAND Flash 1";
> > > 
> > > Do you really want spaces in your partition names?
> > 
> > No clue to be honest.  What are the known ramifications?
> 
> I thought it might give issues with the /proc/mtd columns, but actually,
> the format there is quoted, so the columns will still be unambiguous.
> 
> It also could make things a little more difficult with boot cmdline
> parameters, for instance if you want to specify a partition for UBI to
> attach to:
> 
>   ubi.mtd="NAND Flash 1"
> 
> This will probably work OK (haven't tested it), but I can imagine some
> boot environments in which getting the quoting right is more difficult.

I have no strong feelings either way, so i will rid the whitespace.

> > > > +					reg = <0x00000000 0x00800000>;
> > > > +				};
> > > > +				partition@800000{
> > > > +					label = "NAND Flash 2";
> > > > +					reg = <0x00800000 0x0F800000>;
> > > > +				};
> > > > +			};
> > > > +		};
> > > > +	};
> ...
> 
> > > > diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
> > > > new file mode 100644
> > > > index 0000000..5ad78ce
> > > > --- /dev/null
> > > > +++ b/drivers/mtd/nand/stm_nand_bch.c
> > > > @@ -0,0 +1,2415 @@
> ...
> > > > +/*
> > > > + * ONFI NAND Timing Mode Specifications
> > > > + *
> > > > + * Note, 'tR' field (maximum page read time) is extracted from the ONFI
> > > > + * parameter page during device probe.
> > > > + */
> > > > +const struct nand_sdr_timings st_nand_onfi_timing_specs[] = {
> > > 
> > > Did you ever take a look at Boris Brezillon's timing patch series? He
> > > hasn't submitted an update recently, but it was looking good:
> > > 
> > >   http://article.gmane.org/gmane.comp.hardware.netbook.arm.sunxi/7976
> > > 
> > > Perhaps you could even modify/test/resubmit it (it's got a GPL Sign-off,
> > > after all!). I'd prefer not to stick this stuff in your driver.
> > 
> > Not yet.  Will do that now.
> 
> FYI, some of the ONFI stubs are queued for 3.17, see l2-mtd.git
> drivers/mtd/nand/nand_timings.c. There's also some discussion of adding
> helpers that could reduce these to a more useful set of timings (e.g.,
> some timings used by a NAND controller may actually be a composite of
> two or more of the nand_sdr_timings fields).

Very well.  I will rebase onto l2-mtd.git (master?) and have a look.

> > > > +	/*
> > > > +	 * ONFI Timing Mode '0' (supported on all ONFI compliant devices)
> > > > +	 */
> > > > +	[0] = {
> > > > +		.tCLS_min	= 50,
> > > > +		.tCS_min	= 70,
> > > > +		.tALS_min	= 50,
> > > > +		.tDS_min	= 40,
> > > > +		.tWP_min	= 50,
> > > > +		.tCLH_min	= 20,
> > > > +		.tCH_min	= 20,
> > > > +		.tALH_min	= 20,
> > > > +		.tDH_min	= 20,
> > > > +		.tWB_max	= 200,
> > > > +		.tWH_min	= 30,
> > > > +		.tWC_min	= 100,
> > > > +		.tRP_min	= 50,
> > > > +		.tREH_min	= 30,
> > > > +		.tRC_min	= 100,
> > > > +		.tREA_max	= 40,
> > > > +		.tRHOH_min	= 0,
> > > > +		.tCEA_max	= 100,
> > > > +		.tCOH_min	= 0,
> > > > +		.tCHZ_max	= 100,
> > > > +	},
> ...
> > > (Related: Coverity caught a whole bunch of these type of bugs in the MTD
> > > test modules. I have fixes queued up that I meant to test and submit
> > > soon.)
> > 
> > I will attempt to play around with Coverity.
> 
> Good luck :) Coverity isn't always the easiest to get running
> individually. You might have better luck (once your stuff is merged)

Sorry merged where?

> checking out the free service offered for open source projects through
> github. There's a project instance set up for mainline:
> 
>   https://scan.coverity.com/projects/128?tab=overview

Thanks.  I'll have a play.

> > > > +/*
> > > > + * Detect an erased page, tolerating and correcting up to a specified number of
> > > > + * bits at '0'.  (For many devices, it is now deemed within spec for an erased
> > > > + * page to include a number of bits at '0', either as a result of read-disturb
> > > > + * behaviour or 'stuck-at-zero' failures.)  Returns the number of corrected
> > > > + * bits, or a '-1' if we have exceeded the maximum number of bits at '0' (likely
> > > > + * to be a genuine uncorrectable ECC error).  In the latter case, the data must
> > > > + * be returned unmodified, in accordance with the MTD API.
> > > > + */
> > > > +static int check_erased_page(uint8_t *data, uint32_t page_size, int max_zeros)
> > > 
> > > Another "check erased page" implementation? Sigh... it would be nice if
> > > we could agree on a common implementation to share. My last attempt was
> > > unsuccessful, since some drivers have some very odd requirements.
> > > 
> > > > +{
> > > > +	uint8_t *b = data;
> > > > +	int zeros = 0;
> > > > +	int i;
> > > > +
> > > > +	for (i = 0; i < page_size; i++) {
> > > > +		zeros += hweight8(~*b++);
> > > > +		if (zeros > max_zeros)
> > > > +			return -1;
> > > > +	}
> > > > +
> > > > +	if (zeros)
> > > > +		memset(data, 0xff, page_size);
> > > 
> > > It seems like you're not considering the spare area at all. What if this
> > > is a mostly-blank page, with ECC data, but most of the bitflips are in
> > > the spare area? Then you will "correct" this page to all 0xFF, not
> > > noticing that this was really not a blank page at all.
> > 
> > I could really use Angus' advice on this one.  Although, I fear he may
> > have disappeared into the cosmos.  If I remember correctly (I'm
> > getting rusty on this now), this controller doesn't allow access to
> > the spare area easily.  I think it's all handled automatically
> > i.e. without intervention.
> 
> That's tough. It's pretty hard to support NAND without *any* access to
> spare area.

I think we _can_ do it, via the second (Flex) interface, but it appears
to be readonly and we only do so when initially scanning/building the
BBTs.

I'm not sure I follow your example precisely.  When you say that most
of the bitflips are in the spare area, do you mean that there's usable
data in there?

> > > > +static int bch_block_markbad(struct mtd_info *mtd, loff_t offs)
> > > > +{
> > > > +	struct nand_chip *chip = mtd->priv;
> > > > +	struct nandi_controller *nandi = chip->priv;
> > > > +
> > > > +	uint32_t block;
> > > > +	int ret;
> > > > +
> > > > +	/* Is block already considered bad? (will also catch invalid offsets) */
> > > > +	ret = mtd_block_isbad(mtd, offs);
> > > 
> > > You're violating some of the layering here; the low-level driver
> > > probably shouldn't be calling the high-level mtd_*() APIs.
> > 
> > I'll try to figure out a way to keep the low-level code, low level.
> 
> I was actually second-guessing my statement above after I wrote it.
> You'll notice that nand_bbt uses mtd_read() and mtd_read_oob().

Yes, I saw Pekon's comments, which completely countered your own.

> But then, this is all moot, because I'm pretty sure this check is
> redundant. Note in nand_block_markbad():
> 
> 	ret = nand_block_isbad(mtd, ofs);
> 	if (ret) {
> 		/* If it was bad already, return success and do nothing */
> 		if (ret > 0)
> 			return 0;
> 
> So I think you can drop any bad block check within bch_block_markbad().

I'll look into this, thanks.

> > > > +#ifdef CONFIG_PM
> > > 
> > > Should this be CONFIG_PM_SLEEP?
> > > 
> > > > +static int stm_nand_bch_suspend(struct device *dev)
> > > > +{
> > > > +	struct nandi_controller *nandi = dev_get_drvdata(dev);
> > > > +
> > > > +	nandi_clk_disable(nandi);
> > > > +
> > > > +	return 0;
> > > > +}
> > > > +static int stm_nand_bch_resume(struct device *dev)
> > > > +{
> > > > +	struct nandi_controller *nandi = dev_get_drvdata(dev);
> > > > +
> > > > +	nandi_clk_enable(nandi);
> > > > +
> > > > +	return 0;
> > > > +}
> > > > +
> > > > +static int stm_nand_bch_restore(struct device *dev)
> > > > +{
> > > > +	struct nandi_controller *nandi = dev_get_drvdata(dev);
> > > > +	struct stm_plat_nand_bch_data *pdata = dev->platform_data;
> > > > +	struct stm_nand_bank_data *bank = pdata->bank;
> > > > +
> > > > +	nandi_init_controller(nandi, bank->csn);
> > > > +
> > > > +	return 0;
> > > > +}
> > > > +
> > > > +static const struct dev_pm_ops stm_nand_bch_pm_ops = {
> > > > +	.suspend = stm_nand_bch_suspend,
> > > > +	.resume = stm_nand_bch_resume,
> > > > +	.restore = stm_nand_bch_restore,
> > > > +};
> > > > +#else
> > > > +static const struct dev_pm_ops stm_nand_bch_pm_ops;
> > > 
> > > I think this might as well be:
> > > 
> > > #define stm_nand_bch_pm_ops	NULL
> > 
> > Actually, I think it's all better written with SET_SYSTEM_SLEEP_PM_OPS()
> 
> Or even better, SIMPLE_DEV_PM_OPS().

SIMPLE_DEV_PM_OPS() doesn't support restore().

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
