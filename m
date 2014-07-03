Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690AbaGCIFg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 04:05:36 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48495 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755177AbaGCIF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 04:05:26 -0400
Date: Thu, 3 Jul 2014 10:05:22 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Brian Norris <computersforpeace@gmail.com>
Cc: Lee Jones <lee.jones@linaro.org>, devicetree@vger.kernel.org,
        Boris BREZILLON <b.brezillon.dev@gmail.com>, kernel@stlinux.com,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        "Gupta, Pekon\"" <pekon@ti.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH] mtd: nand: stm_nand_bch: add new driver
Message-ID: <20140703100522.756f9715@bbrezillon>
In-Reply-To: <20140703002237.GM3599@ld-irv-0074>
References: <1401268805-26043-1-git-send-email-lee.jones@linaro.org>
	<20140703002237.GM3599@ld-irv-0074>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Brian,

On Wed, 2 Jul 2014 17:22:37 -0700
Brian Norris <computersforpeace@gmail.com> wrote:

> Hi Lee,
> 
> On Wed, May 28, 2014 at 10:20:05AM +0100, Lee Jones wrote:
> > This is a squashed version of the submission to avoid re-sending the
> > entire set over and over, essentially clogging up the MLs.
> 
> Thanks. I think I'd prefer to accept your driver in a form like this
> too. A few comments below.
> 
> And I'll get one big comment out of the way here: can you abstract your
> ST BBT code into its own self-contained portion, preferably in a
> separate source file, a la nand_bbt.c? Then, provide a way to optionally
> use either your ST BBT or the existing BBT -- perhaps a NAND_BBT_ST flag
> for chip->bbt_options, and a matching device tree property. That way,
> even though you require a legacy format for bootloader interoperability,
> someone can theoretically utilize more mainstream (albeit, not
> necessarily better...) BBT support from nand_bbt.c. I think this will
> provide the best balance between your existing product support and
> upstream-friendly modularity/flexibility. I'm open to other suggestions,
> of course.
> 
> > Cc: computersforpeace@gmail.com
> > Cc: Gupta, Pekon" <pekon@ti.com>
> > Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
> > Cc: linux-mtd@lists.infradead.org
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> 
> Please add versioning to your next patch(es), and describe changes here.
> 
> >  Documentation/devicetree/bindings/mtd/stm-nand.txt |   87 +
> 
> See:
> 
>   Documentation/devicetree/bindings/submitting-patches.txt
> 

[...]

> > +
> > +	nand_timing0: nand-timing {
> > +		sig-setup	= <10>;
> > +		sig-hold	= <10>;
> > +		CE-deassert	= <0>;
> > +		WE-to-RBn	= <100>;
> > +		wr-on		= <10>;
> > +		wr-off		= <30>;
> > +		rd-on		= <10>;
> > +		rd-off		= <30>;
> > +		chip-delay	= <30>;		/* delay in us */
> > +	};
> 
> You didn't document any of this node. And I don't think we want to
> specify every single timing parameter in DT; it may make sense to use
> Boris Brezillon's approach (I note this further down, in the driver
> code) for mapping non-ONFI NAND timings into a compatible ONFI timing
> mode. This will greatly simplify the bindings needed, since it's
> standardized and auto-detectable in many cases.


AFAIR, the NAND timing representation for non-ONFI chips question was
left unanswered:

https://lkml.org/lkml/2014/5/20/581

I can definitely respin my NAND timings series, but I'd like to be sure
this is how you want it done before doing so.

Just as a reminder, you and Jason thought NAND timings for non-ONFI
chips could be auto detected thanks to READID informations (by storing
some sort of "NANDID <-> timings" association table).

Best Regards,

Boris


-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
