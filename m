Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbbA0Eog (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 23:44:36 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:7116 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbbA0Eod convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 23:44:33 -0500
From: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
CC: "sylvain.rochet@finsecur.com" <sylvain.rochet@finsecur.com>,
        "Vilchez, Patrice" <Patrice.VILCHEZ@atmel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        "peda@axentia.se" <peda@axentia.se>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH 2/7] pm: at91: pm_suspend: add the WFI support for ARMv7
Thread-Topic: [PATCH 2/7] pm: at91: pm_suspend: add the WFI support for ARMv7
Thread-Index: AQHQOU/HdMw+T88Z+Em9nd3GGfCtCpzR2LYAgAF2HsA=
Date: Tue, 27 Jan 2015 04:44:02 +0000
Message-ID: <B256D81BAE5131468A838E5D7A243641BFD35CC6@penmbx01>
References: <1422266617-24381-1-git-send-email-wenyou.yang@atmel.com>
 <1422266761-24487-1-git-send-email-wenyou.yang@atmel.com>
 <54C63B8A.9000702@cogentembedded.com>
In-Reply-To: <54C63B8A.9000702@cogentembedded.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.5.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sergei,

Thank you for your review.

> -----Original Message-----
> From: Sergei Shtylyov [mailto:sergei.shtylyov@cogentembedded.com]
> Sent: Monday, January 26, 2015 9:05 PM
> To: Yang, Wenyou; Ferre, Nicolas; linux@arm.linux.org.uk
> Cc: sylvain.rochet@finsecur.com; Vilchez, Patrice; linux-kernel@vger.kernel.org;
> alexandre.belloni@free-electrons.com; peda@axentia.se; linux-arm-
> kernel@lists.infradead.org
> Subject: Re: [PATCH 2/7] pm: at91: pm_suspend: add the WFI support for ARMv7
> 
> Hello.
> 
> On 1/26/2015 1:06 PM, Wenyou Yang wrote:
> 
> > Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
> > ---
> >   arch/arm/mach-at91/pm_suspend.S |   54
> ++++++++++++++++++++++++++++++++++++++-
> >   1 file changed, 53 insertions(+), 1 deletion(-)
> 
> > diff --git a/arch/arm/mach-at91/pm_suspend.S
> > b/arch/arm/mach-at91/pm_suspend.S index 122a3f1..e796722 100644
> > --- a/arch/arm/mach-at91/pm_suspend.S
> > +++ b/arch/arm/mach-at91/pm_suspend.S
> > @@ -53,6 +53,58 @@ mode	.req	r6
> >   	beq	1b
> >   	.endm
> >
> > +/*
> > + * Put the processor to enter the WFI state  */
> > +	.macro _do_wfi
> > +
> > +#if defined(CONFIG_CPU_V7)
> > +	/*
> > +	 * Execute an ISB instruction to flush the pipeline to ensure
> > +	 * that all of operations have beem completed.
> 
>     Been.
> 
> > +	 */
> > +	isb
> > +
> > +	/*
> > +	 * Execute an ISB instruction to ensure that all of the
> 
>     ISB again, while you're executing DSB/DMB?
>
Thank you for your pointing.
 
> > +	 * CP15 register changes have been committed.
> > +	 */
> > +	dsb
> > +	dmb
> > +
> > +	/* Disable the processor's clock */
> > +	mov	tmp1, #AT91_PMC_PCK
> 
>     What's 'tmp1'? Is that a register name?
Yes, a register name defined at the head of file.

> 
> > +	str	tmp1, [pmc, #AT91_PMC_SCDR]
> > +
> > +	/* Execute a WFI instruction */
> 
>     Self-obvious comment, I'd say...
> 
> > +	wfi	@ Wait For Interrupt
> > +
> > +	/*
> > +	 * CPU can specualatively prefetch the instructions
> 
>     Speculatively.
Thanks.
> 
> [...]
> 
> WBR, Sergei


Best Regards,
Wenyou Yang
