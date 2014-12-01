Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932246AbaLAToX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 14:44:23 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:56986 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932119AbaLAToV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 14:44:21 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
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
Subject: Re: [PATCH v3 05/11] memory: add Atmel EBI (External Bus Interface) driver
Date: Mon, 01 Dec 2014 20:43:31 +0100
Message-ID: <2476626.8iiXDzb2Te@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141201192923.6a85e52b@bbrezillon>
References: <1417429647-3419-1-git-send-email-boris.brezillon@free-electrons.com> <4214030.Z2iCEM6hVA@wuerfel> <20141201192923.6a85e52b@bbrezillon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:hWtdWL4J9AVuwNyeMBu4/lCwx51tIxhDdxaB4hLfL6p
 3Oo13Q7QjDt0kmFRhTdsWrfbzrAHfA8co6x0FjgB19YVkZC8EH
 1PxsvTUqMeZUgq+P+Mg4ldbyQ1HNp+NLzadbK4sp+5WlvSEWA3
 3VtECY3mY6KzHBqbFbN0G9wzQskddn62Rbws66dqoJ/fahIKs5
 RQojceR3so7dqhOP5F0/Q/UrSoiCu2Iy3CplOLZaXfhQYI1iT/
 rONwX3Dxit0UdTFkJwlOzGLsZ18azXqxXq5aFfzfPX/QsYyyO3
 ql8abpFUlTtscdXVri9/mPD4NAFeG94RYysgc/8pHYJDR1+Qnu
 dxvunmL77UnQr0vSAdpg=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 December 2014 19:29:23 Boris Brezillon wrote:
> Hi Arnd,
> 
> On Mon, 01 Dec 2014 17:26:27 +0100
> Arnd Bergmann <arnd@arndb.de> wrote:
> 
> > On Monday 01 December 2014 11:27:21 Boris Brezillon wrote:
> > > The EBI (External Bus Interface) is used to access external peripherals
> > > (NOR, SRAM, NAND, and other specific devices like ethernet controllers).
> > > Each device is assigned a CS line and an address range and can have its
> > > own configuration (timings, access mode, bus width, ...).
> > > This driver provides a generic DT binding to configure a device according
> > > to its requirements.
> > > For specific device controllers (like the NAND one) the SMC timings
> > > should be configured by the controller driver through the matrix and
> > > smc syscon regmaps.
> > 
> > Nice!
> > 
> > > +
> > > +#define AT91_EBICSA_REGFIELD(soc)			\
> > > +	REG_FIELD(soc ## _MATRIX_EBICSA_OFF, 0,		\
> > > +		  AT91_MATRIX_EBI_NUM_CS - 1)
> > > +
> > > +#define AT91_MULTI_EBICSA_REGFIELD(soc, n)		\
> > > +	REG_FIELD(soc ## _MATRIX_EBI ## n ## CSA_OFF,	\
> > > +		  0, AT91_MATRIX_EBI_NUM_CS - 1)
> > 
> > I don't like the use macros that concatenate symbol names like
> > this. Why not do either
> > 
> > - open-code the macro contents in the few uses, to allow
> >   grepping for them, or
> 
> I'm not sure to get this one, are you suggesting to do something like
> this:
> 
> #define AT91_EBICSA_REGFIELD(off)			\
> 	REG_FIELD(ebicsa_off, AT91_MATRIX_EBI_NUM_CS - 1)
> 

That would be acceptable too, but what I really meant is one step further:

static const struct reg_field at91sam9260_ebi_csa = 
	REG_FIELD(AT91SAM9260_MATRIX_EBICSA_OFF, 0, AT91_MATRIX_EBI_NUM_CS - 1);

> > - put the register number in the syscon reference and look it
> >   up from there (this would be slightly more complicated for the
> >   second macro)
> 
> I've told several times not to encode register offsets or register ids
> in the DT :-) (and if I'm not mistaken that's what you're suggesting
> here).

I think it's actually fine for syscon references, although in general
I would agree with that. The difference in my opinion is that syscon
by nature is a set of registers.

	Arnd
