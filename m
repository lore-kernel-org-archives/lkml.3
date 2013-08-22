Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982Ab3HVN7e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 09:59:34 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:41707 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752470Ab3HVN7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 09:59:32 -0400
Date: Thu, 22 Aug 2013 14:59:30 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
Cc: Rob Herring <robherring2@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jonas Bonn <jonas@southpole.se>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Michal Simek <monstr@monstr.eu>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>
Subject: Re: [RFC PATCH v2 3/4] powerpc: refactor of_get_cpu_node to
 support other architectures
Message-ID: <20130822135930.GC23152@e106331-lin.cambridge.arm.com>
References: <1376586580-5409-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
 <1376674791-28244-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
 <1376674791-28244-2-git-send-email-Sudeep.KarkadaNagesha@arm.com>
 <2032060.4bgTKOdEX2@flatron>
 <1376777376.25016.11.camel@pasglop>
 <20130819101922.GI3719@e106331-lin.cambridge.arm.com>
 <5212177C.8000709@gmail.com>
 <521223FA.5050903@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <521223FA.5050903@arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 02:56:10PM +0100, Sudeep KarkadaNagesha wrote:
> On 19/08/13 14:02, Rob Herring wrote:
> > On 08/19/2013 05:19 AM, Mark Rutland wrote:
> >> On Sat, Aug 17, 2013 at 11:09:36PM +0100, Benjamin Herrenschmidt wrote:
> >>> On Sat, 2013-08-17 at 12:50 +0200, Tomasz Figa wrote:
> >>>> I wonder how would this handle uniprocessor ARM (pre-v7) cores, for
> >>>> which 
> >>>> the updated bindings[1] define #address-cells = <0> and so no reg 
> >>>> property.
> >>>>
> >>>> [1] - http://thread.gmane.org/gmane.linux.ports.arm.kernel/260795
> >>>
> >>> Why did you do that in the binding ? That sounds like looking to create
> >>> problems ... 
> >>>
> >>> Traditionally, UP setups just used "0" as the "reg" property on other
> >>> architectures, why do differently ?
> >>
> >> The decision was taken because we defined our reg property to refer to
> >> the MPIDR register's Aff{2,1,0} bitfields, and on UP cores before v7
> >> there's no MPIDR register at all. Given there can only be a single CPU
> >> in that case, describing a register that wasn't present didn't seem
> >> necessary or helpful.
> > 
> > What exactly reg represents is up to the binding definition, but it
> > still should be present IMO. I don't see any issue with it being
> > different for pre-v7.
> > 
> Yes it's better to have 'reg' with value 0 than not having it.
> Otherwise this generic of_get_cpu_node implementation would need some
> _hack_ to handle that case.

I'm not sure that having some code to handle a difference in standard
between two architectures is a hack. If anything, I'd argue encoding a
reg of 0 that corresponds to a nonexistent MPIDR value (given that's
what the reg property is defined to map to on ARM) is more of a hack ;)

I'm not averse to having a reg value of 0 for this case, but given that
there are existing devicetrees without it, requiring a reg property will
break compatibility with them.

Mark.
