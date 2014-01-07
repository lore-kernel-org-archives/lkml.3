Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbaAGXzc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 18:55:32 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:15724 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754139AbaAGXzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 18:55:24 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18iVqgcq7SDxVO5tzC+VKsc
Date: Tue, 7 Jan 2014 15:55:15 -0800
From: Tony Lindgren <tony@atomide.com>
To: Sricharan R <r.sricharan@ti.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linus.walleij@linaro.org, linux@arm.linux.org.uk, rnayak@ti.com,
        marc.zyngier@arm.com, grant.likely@linaro.org, mark.rutland@arm.com,
        robherring2@gmail.com, tglx@linutronix.de, galak@codeaurora.org,
        rob.herring@calxeda.com, nm@ti.com, bcousson@baylibre.com
Subject: Re: [PATCH V5 0/4] DRIVERS: IRQCHIP: Add support for crossbar IP
Message-ID: <20140107235514.GG5074@atomide.com>
References: <1386066445-28245-1-git-send-email-r.sricharan@ti.com>
 <52B168A5.4010202@ti.com>
 <52BBB614.5010707@ti.com>
 <52BC6B16.80507@ti.com>
 <52BD856E.7010609@ti.com>
 <52C11284.2030500@ti.com>
 <20140107230733.GD5074@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140107230733.GD5074@atomide.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tony Lindgren <tony@atomide.com> [140107 15:10]:
> * Sricharan R <r.sricharan@ti.com> [131229 22:30]:
> > On Friday 27 December 2013 07:19 PM, Sricharan R wrote:
> > > On Thursday 26 December 2013 11:14 PM, Santosh Shilimkar wrote:
> > >> On Wednesday 25 December 2013 11:52 PM, Sricharan R wrote:
> > >>> On Wednesday 18 December 2013 02:49 PM, Sricharan R wrote:
> > >>>> I have addressed all the comments on this series, can this be merged now ?
> > >>>>
> > >>>   Ping..
> > >>>
> > >> Thomas has already given his reviewed-by tag so the patches can be
> > >> taken via arm-soc tree considering OMAP and GIC changes. Can you
> > >> create a branch with all these patches applied and send it
> > >> to Tony ?
> > >>
> > > Ok, i will send out a branch for this.
> > > 
> >  
> >  I have pushed the below branch
> > 
> > git://github.com/Sricharanti/sricharan.git
> > branch: crossbar
> > 
> > This is on top of Tony's linux-omap master branch
> 
> The linux-omap master branch cannot be used as a base as it
> contains tons of commit history not in mainline. So I'll
> manually applied these patches into omap-for-v3.14/crosbar
> branch.

Oops, I noticed some errors on these:

WARNING: drivers/built-in.o(.text+0xcd0): Section mismatch in reference from the function irqcrossbar_init() to the function .init.text:crossbar_of_init()
The function irqcrossbar_init() references
the function __init crossbar_of_init().
This is often because irqcrossbar_init lacks a __init 
annotation or the annotation of crossbar_of_init is wrong.

WARNING: drivers/built-in.o(.text+0xcdc): Section mismatch in reference from the function irqcrossbar_init() to the (unknown reference) .init.rodata:(unknown)
The function irqcrossbar_init() references
the (unknown reference) __initconst (unknown).
This is often because irqcrossbar_init lacks a __initconst 
annotation or the annotation of (unknown) is wrong.

So I've dropped them for now. Care to fix up those errors and
base your patches against let's say v3.13-rc5?

Regards,

Tony
