Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780AbaEUSnb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 14:43:31 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:28170 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752098AbaEUSn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 14:43:29 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/2jgFpY0ZZLhVBY0s9amZi
Date: Wed, 21 May 2014 11:43:19 -0700
From: Tony Lindgren <tony@atomide.com>
To: Sebastian Reichel <sre@kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCHv5 09/10] DTS: ARM: OMAP3-N900: Add SSI support
Message-ID: <20140521184319.GL17417@atomide.com>
References: <1399739870-13526-1-git-send-email-sre@kernel.org>
 <1399739870-13526-10-git-send-email-sre@kernel.org>
 <20140514215503.GM27426@atomide.com>
 <20140520003538.GD15793@atomide.com>
 <20140521182513.GA26285@earth.universe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140521182513.GA26285@earth.universe>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Reichel <sre@kernel.org> [140521 11:26]:
> Hi,
> 
> On Mon, May 19, 2014 at 05:35:39PM -0700, Tony Lindgren wrote:
> > * Tony Lindgren <tony@atomide.com> [140514 14:57]:
> > > * Sebastian Reichel <sre@kernel.org> [140510 09:40]:
> > > > Add SSI device tree data for OMAP3 and Nokia N900.
> > > 
> > > Picking this patch into omap-for-v3.16/dt thanks.
> > 
> > Just noticed that this patch seems to somehow break idle
> > modes on n900, so dropping both dts changes for now.
> > 
> > Basically the n900 debug LEDs won't ever go off with
> > these two dts patches enabled, even without the modem
> > drivers loaded. I did not dig deeper, but it's probably
> > something related to hwmod using this data for some
> > settings.
> 
> Is hwmod data interpreted at all without the DT entries?

Yes for autoidling unused devices. We parse that with
omap_device_build_from_dt().

> The hwmod data may be wrong. The information from commit
> 398917ce161e10d3c66afaefdb89c73c64c4b02d was simply
> interpolated from all information I found. The OMAP3
> public TRM does not contain *any* information about the
> ssi IP-Core.

It's probably something with the sysc or idlemodes that
keeps things from idling. Maybe wrong address? Or wrong
flags? I'm pretty sure it was the first .dts patch out of
these two as the second one alone did not apply.
 
> > Sorry did not notice it earlier as I did not have the
> > PM regression fix patches merged with my testing branch.
> 
> I hoped to see working modem in 3.16, which will probably
> be used for the next Debian stable :(

That would indeed be nice, let's try to debug it as we
still have few days. I'm finally able to test for PM
regressions with DT patches, too bad we did not have
that earlier because of multiple issues.

Anyways, this dts issue should not prevent merging the
driver changes, I'm all for that!

Regards,

Tony
