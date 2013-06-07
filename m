Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952Ab3FGXHe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 19:07:34 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:32870 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756718Ab3FGXH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 19:07:29 -0400
MIME-Version: 1.0
In-Reply-To: <20130607220853.GR14209@lukather>
References: <CAPweEDx3mAy40BZrzrKPRbvg7vKMj7KevDQ3m_v4p6Yo50eSGg@mail.gmail.com>
	<1370475609.20454.44.camel@localhost>
	<CAPweEDwS3tR=wh-bZJb3vqR8fVQra=3XxDitowGRdH9c7WRfmQ@mail.gmail.com>
	<1733666.lHUBcfUXq9@flatron>
	<20130606112723.71ddd70c@skate>
	<CAPweEDzW60poOYahm31aW3_A=NvZmyBPPPgM9PzdvuPJnju69A@mail.gmail.com>
	<20130607220853.GR14209@lukather>
Date: Sat, 8 Jun 2013 00:07:28 +0100
Message-ID: <CAPweEDwFHY_AbBxjspm7BvfdFHsxL5H594cFN4ZVC6QFpu4QGA@mail.gmail.com>
Subject: Re: [Arm-netbook] getting allwinner SoC support upstream (was Re:
 Uploading linux (3.9.4-1))
From: "luke.leighton" <luke.leighton@gmail.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss <devicetree-discuss@ozlabs.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        debian-arm@lists.debian.org, "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        Linux on small ARM machines 
	<arm-netbook@lists.phcomp.co.uk>,
        debian-kernel@lists.debian.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 7, 2013 at 11:08 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:
> On Fri, Jun 07, 2013 at 07:26:49PM +0100, luke.leighton wrote:
>>  maxime: we need to talk :)
>>
>>  please tell me in 4 or 5 sentences what you've managed to do so far,
>> expanding a little on what thomas says below, more specifically what
>> it achieves and/or allows rather than technically what it does
>> (suitable for managers and directors in other words), and what plans
>> you'd like to see happen.
>
> You mean something like http://linux-sunxi.org/Linux_mainlining_effort ?

 ahh, fantastic.  with references too.  magic.  exactly what i need.
thank you.  listed now at
http://hands.com/~lkcl/allwinner_linux_proposal.txt

> You should really do a bit of research before starting a thread like
> this one.

 then that gives you some idea of how busy i've been and still am, to
not be aware even of things like this, to have kicked a project off
some 18-24 months ago and not be able to keep up with one of the many
branches and initiatives that it's spawned.

 when i said i've been caught off-guard by this opportunity i meant
exactly what i said.

> This webpage has been around for like 9 monthes now on the wiki
> of a community you pretend to represent

 i pretend no such thing and apologise for giving any impression of such.

> (even though I fail to get how
> you can pretend such thing, but that's another topic).

 i have a different focus: a meta-project of sorts, where allwinner
happened to be the first.  look up rhombus-tech and EOMA68 and it'll
become a bit clearer.

>> > is the maintainer of the mainline Allwinner sunxi
>> > effort. It already supports a number of boards, has a pinctrl driver, a
>> > GPIO driver, serial port is working, network is working, I2C is
>> > working.
>> >
>> > All in mainline, completely Device Tree based.
>>
>>  great.  which version did it first hit, i.e. what will the first
>> signs of this be when allwinner begin doing "git pulls"?
>
> 3.8, as shown in the wiki page

 got that.

>>  and which boards.  bear in mind that one of those "boards" should
>> really be "the total range of products available across hundreds of
>> chinese tablet clone manufacturers".
>>
>>  specific question: is one of the "boards" the one that tom cubie
>> submitted, which covers virtually every android tablet product
>> manufactured in the millions by chinese tablet clone manufacturers?
>
> Again, wiki.

 yep, am there now.

>> > So isn't this entire discussion completely moot?
>>
>>  no because it's totally in isolation from allwinner.  i need to give
>> them a heads-up, and get them involved, giving them specific
>> incentives [which nobody's yet given!!] for following a particular
>> path [or paths] yet to be recommended.
>>
>> > The mainline support
>> > for sunxi has already started since 6 months or so, and has been Device
>> > Tree based from day one.
>>
>> to clarify: the *community-driven* mainline support for sunxi.  ok -
>> which chips?  sun3i (ARM9), sun4i (Cortex A8), sun5i, sun6i and sun7i
>> (Dual-Core Cortex A7)?  which ones are in?
>
> A10, A13 for the moment. I just received hardware with A10s, A20 and A31
> that I need to work on, but support should come quite soon.

 superb.  question: what help or other resources could you do with?
what additional information?


> I already
> have some patches pending to be tested on an A31 board, but didn't have
> as much time as I wanted lately to actually set a proper environment to
> test them.

 ok - good to know.  btw when you get to it please note a bug found in
the "vanilla" [allwinner-released] A20 3.3 tree where they reduced a
128 byte buffer to 78 bytes for spurious reasons; the critical fix is
at line 989, of the following patch:

 http://git.rhombus-tech.net/?p=linux.git;a=commitdiff;h=refs/heads/lkcl-3.3-a20;hp=6c5753e5dc1fafff288d522c94b40a7dd2a81adc

 i found this by running a diff -u of sun4i_usb from the 3.4 sunxi
community tree against the sun7i_usb tree from the allwinner 3.3
release.  amongst the desperate attempts to disable DMA (probably due
to stack corruption of the above bug) and various renaming attempts of
*SUN4I* to *SUN7I*, that one stuck out like a sore thumb.  the other
bits - which may or may not be relevant - are the spinlock protection
and the call to sw_udc_enable which is present in the sun4i_usb 3.4
code but not the A20 3.3 code.

mileage may vary, and the buffer overrun only happens if you enable
the OTG interface as "dual" (auto-detect) because that's enough
features in the bitfield to cause there to be enough strcpy's... oops
:)

l.
