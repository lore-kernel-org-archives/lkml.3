Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932465AbaLAU2a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 15:28:30 -0500
Received: from down.free-electrons.com ([37.187.137.238]:55370 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932268AbaLAU23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 15:28:29 -0500
Date: Mon, 1 Dec 2014 21:28:20 +0100
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH v3 05/11] memory: add Atmel EBI (External Bus Interface)
 driver
Message-ID: <20141201212820.6a7fc4b0@bbrezillon>
In-Reply-To: <2476626.8iiXDzb2Te@wuerfel>
References: <1417429647-3419-1-git-send-email-boris.brezillon@free-electrons.com>
	<4214030.Z2iCEM6hVA@wuerfel>
	<20141201192923.6a85e52b@bbrezillon>
	<2476626.8iiXDzb2Te@wuerfel>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 01 Dec 2014 20:43:31 +0100
Arnd Bergmann <arnd@arndb.de> wrote:

> On Monday 01 December 2014 19:29:23 Boris Brezillon wrote:
> > Hi Arnd,
> > 
> > On Mon, 01 Dec 2014 17:26:27 +0100
> > Arnd Bergmann <arnd@arndb.de> wrote:
> > 
> > > On Monday 01 December 2014 11:27:21 Boris Brezillon wrote:
> > > > The EBI (External Bus Interface) is used to access external peripherals
> > > > (NOR, SRAM, NAND, and other specific devices like ethernet controllers).
> > > > Each device is assigned a CS line and an address range and can have its
> > > > own configuration (timings, access mode, bus width, ...).
> > > > This driver provides a generic DT binding to configure a device according
> > > > to its requirements.
> > > > For specific device controllers (like the NAND one) the SMC timings
> > > > should be configured by the controller driver through the matrix and
> > > > smc syscon regmaps.
> > > 
> > > Nice!
> > > 
> > > > +
> > > > +#define AT91_EBICSA_REGFIELD(soc)			\
> > > > +	REG_FIELD(soc ## _MATRIX_EBICSA_OFF, 0,		\
> > > > +		  AT91_MATRIX_EBI_NUM_CS - 1)
> > > > +
> > > > +#define AT91_MULTI_EBICSA_REGFIELD(soc, n)		\
> > > > +	REG_FIELD(soc ## _MATRIX_EBI ## n ## CSA_OFF,	\
> > > > +		  0, AT91_MATRIX_EBI_NUM_CS - 1)
> > > 
> > > I don't like the use macros that concatenate symbol names like
> > > this. Why not do either
> > > 
> > > - open-code the macro contents in the few uses, to allow
> > >   grepping for them, or
> > 
> > I'm not sure to get this one, are you suggesting to do something like
> > this:
> > 
> > #define AT91_EBICSA_REGFIELD(off)			\
> > 	REG_FIELD(ebicsa_off, AT91_MATRIX_EBI_NUM_CS - 1)
> > 
> 
> That would be acceptable too, but what I really meant is one step further:
> 
> static const struct reg_field at91sam9260_ebi_csa = 
> 	REG_FIELD(AT91SAM9260_MATRIX_EBICSA_OFF, 0, AT91_MATRIX_EBI_NUM_CS - 1);

That's what I did in the first place (in a version I didn't submitted),
and I guess I'll go for that one unless you really prefer the
alternative (I ran into a lot of trouble with DT bindings ABI
stability, and I'd prefer to keep DT bindings as simple as
possible).

> 
> > > - put the register number in the syscon reference and look it
> > >   up from there (this would be slightly more complicated for the
> > >   second macro)
> > 
> > I've told several times not to encode register offsets or register ids

    ^ "I've been told" :-).

> > in the DT :-) (and if I'm not mistaken that's what you're suggesting
> > here).
> 
> I think it's actually fine for syscon references, although in general
> I would agree with that. The difference in my opinion is that syscon
> by nature is a set of registers.

Okay, good to know.



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
