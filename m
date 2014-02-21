Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957AbaBUUEi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 15:04:38 -0500
Received: from top.free-electrons.com ([176.31.233.9]:39874 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751030AbaBUUEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 15:04:36 -0500
Date: Fri, 21 Feb 2014 21:04:34 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Boris BREZILLON <b.brezillon@overkiz.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv2 1/8] ARM: at91: Add at91sam9rl DT SoC support
Message-ID: <20140221200434.GA4436@piout.net>
References: <1392823951-26053-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1392823951-26053-2-git-send-email-alexandre.belloni@free-electrons.com>
 <20140219170020.GA25079@e106331-lin.cambridge.arm.com>
 <20140219173141.GB3038@piout.net>
 <20140219175409.GF25079@e106331-lin.cambridge.arm.com>
 <5305C3EB.5080107@overkiz.com>
 <5305C700.4090601@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5305C700.4090601@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On 20/02/2014 at 10:12:32 +0100, Nicolas Ferre wrote :
> >>>> NAK. Either this is a atmel,at91rm9200-pinctrl node or a simple-bus. Not
> >>>> both; that doesn't make any sense.
> >>>>
> >>> Simply a copy paste, I'll fix that here and also the 6 other atmel
> >>> dtsi includes.
> >>>
> >>> What is your preference for those using:
> >>> compatible = "atmel,at91sam9x5-pinctrl", "atmel,at91rm9200-pinctrl", "simple-bus"; ?
> >> A node should by either a bus or a pinctrl node.
> >>
> >> If it has chidren then the simple-bus should be separated out into a
> >> separate node. If there are no children simple-bus should go.
> > 
> > Doing this clearly break backward compatibility (the current pinctrl 
> > drivers relies on
> > gpio controller being subnodes of the pinctrl node), but I'm interested 
> > in how you would
> > have represented this.
> 
> Guys, just be warned, I do not plan to rework or even push for a rework
> of the pinctrl driver anytime soon.
> 
> So I am afraid but you will have to live with this DT representation of
> pinctrl for quite some time (even if it doesn't make sense, sorry Mark)...
> 

Those bindings have been merged in july 2012 and like others, I fear we
will definitely have to break backward compatibility when reworking
those. So, in light of what Nicolas said, I've sent v3 taking into
account all your other comments.

I believe we have 3 at91sam9 SoCs that will enter the DT world for 3.15.
I suggest that we finish the DT and CCF transition then we'll take some
time to rework the pinctrl driver.

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
