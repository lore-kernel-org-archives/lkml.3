Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757821AbbA0D2N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 22:28:13 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:46448 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757784AbbA0D2K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 22:28:10 -0500
From: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
CC: "sylvain.rochet@finsecur.com" <sylvain.rochet@finsecur.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        "peda@axentia.se" <peda@axentia.se>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH v2 04/12] pm: at91: move the copying the sram function
 to the sram initializationi phase
Thread-Topic: [PATCH v2 04/12] pm: at91: move the copying the sram function
 to the sram initializationi phase
Thread-Index: AQHQOUwkahzBNCxcJkeV4NHUBtyaqZzR1o6AgAF5DZA=
Date: Tue, 27 Jan 2015 03:27:46 +0000
Message-ID: <B256D81BAE5131468A838E5D7A243641BFD35C38@penmbx01>
References: <1422265005-22937-1-git-send-email-wenyou.yang@atmel.com>
 <1422265201-23110-1-git-send-email-wenyou.yang@atmel.com>
 <54C639B5.7050106@cogentembedded.com>
In-Reply-To: <54C639B5.7050106@cogentembedded.com>
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
> Sent: Monday, January 26, 2015 8:57 PM
> To: Yang, Wenyou; Ferre, Nicolas; linux@arm.linux.org.uk
> Cc: sylvain.rochet@finsecur.com; linux-kernel@vger.kernel.org;
> alexandre.belloni@free-electrons.com; peda@axentia.se; linux-arm-
> kernel@lists.infradead.org
> Subject: Re: [PATCH v2 04/12] pm: at91: move the copying the sram function to
> the sram initializationi phase
> 
> Hello.
> 
> On 1/26/2015 12:40 PM, Wenyou Yang wrote:
> 
> > To decrease the suspend time, move the copying the sram function to
> > the sram initialization phase, instead of every time go to suspend.
> 
> > Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
> > Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> > ---
> >   arch/arm/mach-at91/pm.c |    7 +++----
> >   1 file changed, 3 insertions(+), 4 deletions(-)
> 
> > diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c index
> > 5dd4e41..409185e 100644
> > --- a/arch/arm/mach-at91/pm.c
> > +++ b/arch/arm/mach-at91/pm.c
> > @@ -161,10 +161,6 @@ static int at91_pm_enter(suspend_state_t state)
> >   			 * turning off the main oscillator; reverse on wakeup.
> >   			 */
> >   			if (slow_clock) {
> > -#ifdef CONFIG_AT91_SLOW_CLOCK
> > -				/* copy slow_clock handler to SRAM, and call it */
> > -				memcpy(slow_clock, at91_slow_clock,
> at91_slow_clock_sz);
> > -#endif
> >   				slow_clock(at91_pmc_base, at91_ramc_base[0],
> >   					   at91_ramc_base[1],
> >   					   at91_pm_data.memctrl);
> > @@ -272,6 +268,9 @@ static void __init at91_pm_sram_init(void)
> >   	sram_pbase = gen_pool_virt_to_phys(sram_pool, sram_base);
> >   	slow_clock = __arm_ioremap_exec(sram_pbase, at91_slow_clock_sz,
> > false);
> >
> > +	/* Copy slow_clock handler to SRAM, and call it */
> 
>     You're not calling it here.
> 
> > +	memcpy(slow_clock, at91_slow_clock, at91_slow_clock_sz);
> > +
> >   put_node:
> >   	of_node_put(node);
> >   }
> 
> WBR, Sergei

Best Regards,
Wenyou Yang
