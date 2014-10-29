Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933521AbaJ2PFj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 11:05:39 -0400
Received: from palmtree.beeroclock.net ([178.79.160.154]:57178 "EHLO
	palmtree.beeroclock.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933169AbaJ2PFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 11:05:37 -0400
Date: Wed, 29 Oct 2014 15:05:36 +0000
From: Karl Palsson <karlp@tweak.net.au>
To: NEO-Technologies / Julien CHAUVEAU 
	<julien.chauveau@neo-technologies.fr>
Cc: Max Schwarz <max.schwarz@online.de>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Addy Ke <addy.ke@rock-chips.com>, wsa@the-dreams.de,
        Mark Rutland <mark.rutland@arm.com>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        "moderated list:ARM/Rockchip SoC..." 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2] ARM: dts: rockchip: use internal pull-up resistors on
 I2C busses
Message-ID: <20141029150536.GA3876@palmtree.beeroclock.net>
References: <1414492597-13566-1-git-send-email-julien.chauveau@neo-technologies.fr>
 <2234299.BSD6RSf1dG@diego>
 <20141029134415.GA3499@palmtree.beeroclock.net>
 <32904940.RFLKbTnBmv@xq-nb>
 <5450FAF3.2010208@neo-technologies.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5450FAF3.2010208@neo-technologies.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


However, and possibly out of line, but should we consider submitting a patch to remove the
pullups by default for exynos that Doug hinted at?  

Cheers,
Karl P


On Wed, Oct 29, 2014 at 03:34:27PM +0100, NEO-Technologies / Julien CHAUVEAU wrote:
> Hi everyone,
> 
> Okay, I understand your opinion. So let's drop my patch in this case.
> 
> Thank you for your comments.
> 
> Julien
> 
> 
> Le 29/10/2014 15:02, Max Schwarz a écrit :
> >Hi,
> >
> >I'll agree with Karl and Doug. If you (as a board vendor/maintainer/etc) want
> >to use I2C, it's *your* responsibility to provide the pullup resistors by
> >either including pullup resistors on the board or by enabling the internal
> >ones.
> >Either way, you should think a moment about the consequences (frequency/trace
> >length limitations), which is why I'm also against the pullup-by-default
> >behavior.
> >
> >Also, it's much harder to diagnose effects like Doug is describing (slightly
> >out-of-spec due to internal + external pulls) than the effects you are seeing
> >without any pullups. With your i2cdetect results my first thought would have
> >been "are there pullups on the bus?".
> >
> >Cheers,
> >   Max
> >
> >Am Mittwoch, 29. Oktober 2014, 13:44:15 schrieb Karl Palsson:
> >>I'd be more inclined to have pulls disabled by default, it's more standard
> >>with what smaller micros do, but I've no experience with these bigger
> >>cortex-a parts.  It's also the "least surprise" path.  If you want to try
> >>and use the onboard pullups, you can specify that in your board file, but
> >>for people deliberately selecting pullups for their timing and load
> >>expectations, being required to take an extra step to turn off something
> >>seems unexpected.
> >>
> >>If you _want_ to be able to probe an i2c bus for devices added aftermarket,
> >>on a board that didn't get i2c pull ups because no devices were planned,
> >>and you want to turn on the internal pullups for that, I think that's
> >>something you need to do yourself, not making it a hard default in the SoC
> >>dtsi file.
> >>
> >>so, if it's off by default, you get this
> >>                                          dtsi   dts
> >>Board1, i2c periphs, designed pullups => off     -
> >>board2, no peripsh, pulls in case     => off     -
> >>board3, no periphs, forgot pulls, pray=> off    on
> >>
> >>If you turn it on by default, sure, it causes no harm in most cases, but
> >>you're no longer getting the values you expect, without having to turn off
> >>things that are not default anyway.
> >>
> >>Sincerely,
> >>Karl Palsson
> >>
> >>On Wed, Oct 29, 2014 at 02:17:23PM +0100, Heiko Stübner wrote:
> >>>Hi Addy, Max, Wolfram,
> >>>
> >>>after Doug's explanation of disfavour [0] and Julien's subsequent response
> >>>I'm not sure which direction to go. So if possible I'd like to collect
> >>>some more opinions of people knowing a lot more about i2c internals than
> >>>myself :-) .
> >>>
> >>>
> >>>Thanks
> >>>Heiko
> >>>
> >>>
> >>>[0] http://lists.infradead.org/pipermail/linux-rockchip/2014-October/000934.html
> 
