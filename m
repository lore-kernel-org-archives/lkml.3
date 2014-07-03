Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964802AbaGCHeZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 03:34:25 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:52625 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932239AbaGCHeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 03:34:22 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/K8uocFnkAJvF0ehqnr4Ls
Date: Thu, 3 Jul 2014 00:34:11 -0700
From: Tony Lindgren <tony@atomide.com>
To: Robert Nelson <robertcnelson@gmail.com>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, Felipe Balbi <balbi@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux kernel <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH] tty: serial: Add 8250-core based omap driver
Message-ID: <20140703073411.GX28884@atomide.com>
References: <1404316809-20637-1-git-send-email-bigeasy@linutronix.de>
 <20140702160932.GF5541@saruman.home>
 <20140702190944.GA567@drone.musicnaut.iki.fi>
 <CAOCHtYgxMeA+Arfe40XeFDEKuCJ8qo1RqNR0hYBGr_Wp6sRfdA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOCHtYgxMeA+Arfe40XeFDEKuCJ8qo1RqNR0hYBGr_Wp6sRfdA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Robert Nelson <robertcnelson@gmail.com> [140702 12:27]:
> On Wed, Jul 2, 2014 at 2:09 PM, Aaro Koskinen <aaro.koskinen@iki.fi> wrote:
> > Hi,
> >
> > On Wed, Jul 02, 2014 at 11:09:32AM -0500, Felipe Balbi wrote:
> >> > It has been only tested as console UART.
> >> > The tty name is ttyS based instead of ttyO. How big is the pain here,
> >> > what could be the easiest way to provide compatibility?
> >>
> >> have been considering that myself for months. You could pass an optional
> >> argument to serial8250_register_8250_port() but that only solves part of
> >> the problem :-(

Some kind of compability layer sure would be nice.

> > When ttyS -> ttyO change was done on OMAP, compatibility was not an issue.
> > Why should we care about it now?
> 
> It would be a good opportunity to force everyone to update their bootloader. ;)
> 
> Besides the BeagleBoard forum is quiet now, no one is complaining
> about that old (ttyS -> ttyO) transition anymore..

How about a Kconfig option to provide ttyO by default? The not even
do that if kernel has cmdline option nottyomap.
 
> I'll just end up carrying a patch like, to support bb.org users over
> the transition..
> 
> https://github.com/RobertCNelson/stable-kernel/blob/v3.7.x/patches/omap_beagle/0004-zeroMAP-Open-your-eyes.patch

Heh. Just to summarize the reason ttyO needs to be a separate name
and device entry from ttyS is because we also have external 8250
devices on GPMC and hotplug busses.

Regards,

Tony
