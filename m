Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583AbaGCNer (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 09:34:47 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:53203 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbaGCNep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 09:34:45 -0400
MIME-Version: 1.0
In-Reply-To: <20140703132509.GA5814@saruman.home>
References: <1404316809-20637-1-git-send-email-bigeasy@linutronix.de>
	<20140702160932.GF5541@saruman.home>
	<20140702190944.GA567@drone.musicnaut.iki.fi>
	<CAOCHtYgxMeA+Arfe40XeFDEKuCJ8qo1RqNR0hYBGr_Wp6sRfdA@mail.gmail.com>
	<20140703073411.GX28884@atomide.com>
	<20140703132509.GA5814@saruman.home>
Date: Thu, 3 Jul 2014 08:34:44 -0500
Message-ID: <CAOCHtYi0JwRO12gHa+KFGH1k7pPk4TL40igwhzRRxutw-tqf6A@mail.gmail.com>
Subject: Re: [RFC PATCH] tty: serial: Add 8250-core based omap driver
From: Robert Nelson <robertcnelson@gmail.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux kernel <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 3, 2014 at 8:25 AM, Felipe Balbi <balbi@ti.com> wrote:
> On Thu, Jul 03, 2014 at 12:34:11AM -0700, Tony Lindgren wrote:
>> * Robert Nelson <robertcnelson@gmail.com> [140702 12:27]:
>> > On Wed, Jul 2, 2014 at 2:09 PM, Aaro Koskinen <aaro.koskinen@iki.fi> wrote:
>> > > Hi,
>> > >
>> > > On Wed, Jul 02, 2014 at 11:09:32AM -0500, Felipe Balbi wrote:
>> > >> > It has been only tested as console UART.
>> > >> > The tty name is ttyS based instead of ttyO. How big is the pain here,
>> > >> > what could be the easiest way to provide compatibility?
>> > >>
>> > >> have been considering that myself for months. You could pass an optional
>> > >> argument to serial8250_register_8250_port() but that only solves part of
>> > >> the problem :-(
>>
>> Some kind of compability layer sure would be nice.
>>
>> > > When ttyS -> ttyO change was done on OMAP, compatibility was not an issue.
>> > > Why should we care about it now?
>> >
>> > It would be a good opportunity to force everyone to update their bootloader. ;)
>> >
>> > Besides the BeagleBoard forum is quiet now, no one is complaining
>> > about that old (ttyS -> ttyO) transition anymore..
>>
>> How about a Kconfig option to provide ttyO by default? The not even
>> do that if kernel has cmdline option nottyomap.
>
> what about single zImage ? I don't want to use ttyO on my
> Allwinner/Exynos/Snapdragon/whatever SoC just because OMAP is in the
> same image ;-)

What if we just kept it simple, leave the ttyO driver enabled and add
a warning (pr_info) that it's deprecated.  It's not like it's broken,
it just won't get later features or devices support added.

Regards,

-- 
Robert Nelson
http://www.rcn-ee.com/
