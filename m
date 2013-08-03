Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751303Ab3HCFaz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 01:30:55 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:57993 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab3HCFay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 01:30:54 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <CAHCPf3v75tJyUGzxcrPfWW7V+bVxPCJupnDV4UbDQsrsXBXTrQ@mail.gmail.com>
References: <20130731073802.GT7656@atomide.com>
	<20130731152131.GW2296@suse.de>
	<20130802081315.GA7656@atomide.com>
	<CAHCPf3v75tJyUGzxcrPfWW7V+bVxPCJupnDV4UbDQsrsXBXTrQ@mail.gmail.com>
Date: Fri, 2 Aug 2013 22:30:53 -0700
Message-ID: <CAOesGMgASk8yH0Og4sEREkwxcZLx11gtj4buSEXxoJHDEV9F8g@mail.gmail.com>
Subject: Re: [Ksummit-2013-discuss] [ATTEND] [ARM ATTEND] kernel data bloat
 and how to avoid it
From: Olof Johansson <olof@lixom.net>
To: Matt Sealey <neko@bakuhatsu.net>
Cc: Tony Lindgren <tony@atomide.com>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 2, 2013 at 2:31 PM, Matt Sealey <neko@bakuhatsu.net> wrote:
> On Fri, Aug 2, 2013 at 3:13 AM, Tony Lindgren <tony@atomide.com> wrote:
>> * Mel Gorman <mgorman@suse.de> [130731 08:28]:
>>> On Wed, Jul 31, 2013 at 12:38:03AM -0700, Tony Lindgren wrote:
>>> > Hi all,
>>> >
>>> > Probably the biggest kernel data bloat issue is in the ARM land, but
>>> > it also seems that it's becoming a Linux generic issue too, so I
>>> > guess it could be discussed in either context.
>>> >
>>>
>>> Would scripts/bloat-o-meter highlight where the growth problems are?
>>
>> Well to some extent yes, the board/SoC/driver specific options are
>> often behind Kconfig options. So if you want to limit the set of
>> supported SoCs and drivers for the kernel you can optimize it out.
>>
>> The bloat-o-meter won't help for things like checking that a device
>> tree binding really describes the hardware, and is not just pointing
>> to a table of defined registers in the device driver.
>
> Specifically naming and shaming, like arch/arm/mach-imx/clk-*.c kind

[...]

TL;DR. Some friendly advice is to reduce the verbosity of your emails.
I lost patience a couple of paragraphs in.


I think we could come a long way on this if we could sort out probe
and init order enough that we could modularize some of this data (and
init code). I.e. if you could load some of these tables and drivers as
modules a lot of the bloat would no longer be an issue.

The problem, of course, is that things like clock, pinmux, etc tables
(and drivers) tend to be needed very early during boot and thus can
definitely not wait to the point where we usually run ramdisk
contents.

We could mandate that whatever drivers are needed on top also be
modules, which would take care of some of the dependency chain, but we
don't have a great way today to describe the needed probe/load order
of said modules. So it'd still need some new and additional
functionality to work well.

Pushing everything out into modules will also add some complexity for
embedded platforms who rather avoid ramdisks, and it will likely add
boot time which matters a lot to some users. On the other hand, it's
less likely to matter to the users who at the same time care about the
bloat of a multiplatform kernel, i.e. you tend to ether optimize for
boot time on particular well-defined hardware, or you care more about
having something that boots on most hardware but possibly with some
overhead in boot performance.


-Olof
