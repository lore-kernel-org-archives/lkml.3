Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073AbaGXMpk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 08:45:40 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:10000 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758059AbaGXMpi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 08:45:38 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18zBIWE1mgPaMt/vTlLnAEnuXFwlDkbD+8=
X-DKIM: OpenDKIM Filter v2.0.1 titan C79345B4E08
Date: Thu, 24 Jul 2014 08:45:20 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Benoit Masson <benoitm@perenite.com>, Andrew Lunn <andrew@lunn.ch>,
        Benoit Masson <yahoo@perenite.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>
Subject: Re: [PATCH 2/2] ARM: mvebu: Added dts defintion for Lenovo Iomega
 ix4-300d NAS
Message-ID: <20140724124520.GV23220@titan.lakedaemon.net>
References: <1406154923-13612-1-git-send-email-yahoo@perenite.com>
 <1406154923-13612-2-git-send-email-yahoo@perenite.com>
 <20140723224236.GC28485@lunn.ch>
 <94F87063-D717-435B-B7C5-EDAC9B26742C@perenite.com>
 <20140723225841.GD28485@lunn.ch>
 <10A7C530-7CD2-4ED0-889A-7FAC1922320F@perenite.com>
 <20140723231535.GK23220@titan.lakedaemon.net>
 <53D0FA2F.6050209@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <53D0FA2F.6050209@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 02:21:03PM +0200, Gregory CLEMENT wrote:
> On 24/07/2014 01:15, Jason Cooper wrote:
> > On Thu, Jul 24, 2014 at 01:11:12AM +0200, Benoit Masson wrote:
> >> Le 24 juil. 2014 à 00:58, Andrew Lunn <andrew@lunn.ch> a écrit :
> >>
> >>>> For the marvell,mv78230-a0-i2c unfortunately i've spend 3 hours
> >>>> trying to understand this but it only works with this on the
> >>>> ix4-300d :(. There was multiple patch around this and maybe one
> >>>> broke the auto-detect part of this, I've tried compiling with some
> >>>> 3.10 or lower kernel but no luck here I still have to put this a0
> >>>> option.
> >>>
> >>> Lets first confirm you have an a0 SoC.
> >>>
> >>> At boot time, it should print:
> >>>
> >>> pr_info("MVEBU SoC ID=0x%X, Rev=0x%X\n", soc_dev_id, soc_rev);
> >>>
> >>> What revision do you have?
> >>>
> >>> If the auto detect code really is broken, Gregory will likely take a
> >>> look.
> >>
> >> I sure do,
> >>
> >> confirmed by u-boot  output below:
> >>
> >> U-Boot 2009.08 (Mar 04 2013 - 11:13:04) Marvell version:  2.3.2 PQ
> >> U-Boot Addressing:
> >>        Code:..00600000:006BFFF0
> >>        BSS:..00708EC0
> >>        Stack:..0x5fff70
> >>        PageTable:.0x8e0000
> >>        Heap address:.0x900000:0xe00000
> >> Board: DB-78230-BP rev 2.0 Wistron
> >> SoC:   MV78230 A0
> >>
> >> From kernel I get:
> >>
> >> mvebu-soc-id: MVEBU SoC ID=0x7823, Rev=0x1
> > 
> > Well, isn't that a peach?  :)  Gregory?
> 
> A peach?? For me it is either a fruit or a princess, so I am puzzled!

Doc Holiday quote from the movie Tombstone.  The full quote was "Well,
isn't that a peach of a hand?" while sitting at the poker table.

> Well about the issue, we patch the device tree for the i2c quirk only for
> the openblock AX3.

Ahhh, that's right.  I need to slow down and dig a bit more. :(

> If I remember well it was because the device tree was already written
> for this board before we found there was an issue with the A0 version
> of the CPU. 

No, it's because we didn't think any manufacturers would be silly enough
to use the a0 in production.  That assumption worked out well. :-P

> The rule was that for new boards then they have to set the marvell,mv78230-a0-i2c
> compatible string. I also didn't expect that we found "new" product using the A0 version.
> 
> We have 3 options now:
> 
> - remove the check on the openblock AX3 board and always try to apply the quirck for A0 version
> - add a check for this new board in the mvebu_dt_init function
> - let the compatible string marvell,mv78230-a0-i2c in this dts
> 
> I would prefer the option 1 but I fear that Arnd would prefer the 2 other options.

I like option 1 and 3.  Option 3 is a *correct* description of the
hardware, and should be done.  Option 1 makes Linux user-friendly for boards
that are exactly the same, but changed out SoC stepping mid-production.

Option 2 needs to be undone.  We shouldn't need to change compiled code
for every new board that comes along.  Which was the whole point of DT,
right?

thx,

Jason.
