Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933783AbbA2CYX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:24:23 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:31565 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761719AbbA2CYT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:24:19 -0500
From: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        "sylvain.rochet@finsecur.com" <sylvain.rochet@finsecur.com>,
        "peda@axentia.se" <peda@axentia.se>,
        "linux@maxim.org.za" <linux@maxim.org.za>
Subject: RE: [PATCH v2 3/3] pm: at91: add disable/enable the L1/L2 cache
 while suspend/resume
Thread-Topic: [PATCH v2 3/3] pm: at91: add disable/enable the L1/L2 cache
 while suspend/resume
Thread-Index: AQHQOqGWhx01SRZMPkSnJ57qqrXM+pzUyZGAgAGU0PA=
Date: Thu, 29 Jan 2015 02:22:43 +0000
Message-ID: <B256D81BAE5131468A838E5D7A243641BFD38E20@penmbx01>
References: <1422411707-10945-1-git-send-email-wenyou.yang@atmel.com>
 <1422411844-13241-1-git-send-email-wenyou.yang@atmel.com>
 <54C8B54B.3090607@cogentembedded.com>
In-Reply-To: <54C8B54B.3090607@cogentembedded.com>
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
> Sent: Wednesday, January 28, 2015 6:09 PM
> To: Yang, Wenyou; Ferre, Nicolas; linux@arm.linux.org.uk
> Cc: linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org;
> alexandre.belloni@free-electrons.com; sylvain.rochet@finsecur.com;
> peda@axentia.se; linux@maxim.org.za
> Subject: Re: [PATCH v2 3/3] pm: at91: add disable/enable the L1/L2 cache while
> suspend/resume
> 
> Hello.
> 
> On 1/28/2015 5:24 AM, Wenyou Yang wrote:
> 
> > For the sama5, disable L1 D-cache and L2 cache before the cpu go to
> > wfi, after wakeing up, enable L1 D-cache and L2 cache.
> 
>     Waking.
> 
> > Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
> > ---
> >   arch/arm/mach-at91/pm.c         |   12 +++++
> >   arch/arm/mach-at91/pm_suspend.S |  107
> +++++++++++++++++++++++++++++++++++++++
> >   2 files changed, 119 insertions(+)
> 
> [...]
> > diff --git a/arch/arm/mach-at91/pm_suspend.S
> > b/arch/arm/mach-at91/pm_suspend.S index 311cc23..02d4e56 100644
> > --- a/arch/arm/mach-at91/pm_suspend.S
> > +++ b/arch/arm/mach-at91/pm_suspend.S
> [...]
> > @@ -324,3 +325,109 @@ ram_restored:
> [...]
> > +l2x_sync:
> 
>     I don't see where this label is used.
I thought it is an indication the following is for L2 cache synchronization. 

It is redundant, remove it.

> 
> > +	ldr	r0, [r2, #L2X0_CACHE_SYNC]
> > +	bic	r0, r0, #0x1
> > +	str	r0, [r2, #L2X0_CACHE_SYNC]
> > +sync:
> > +	ldr	r0, [r2, #L2X0_CACHE_SYNC]
> > +	ands	r0, r0, #0x1
> > +	bne	sync
> > +
> > +skip_l2disable:
> > +	ldmfd	sp!, {r4 - r12, pc}
> > +ENDPROC(at91_disable_l1_l2_cache)
> [...]
> 
> WBR, Sergei

Best Regards,
Wenyou Yang
