Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759077AbaGDQvJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 12:51:09 -0400
Received: from www.linutronix.de ([62.245.132.108]:35695 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbaGDQvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 12:51:06 -0400
Message-ID: <53B6DB74.2050401@linutronix.de>
Date: Fri, 04 Jul 2014 18:51:00 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>, Robert Nelson <robertcnelson@gmail.com>
CC: Aaro Koskinen <aaro.koskinen@iki.fi>, Felipe Balbi <balbi@ti.com>,
        linux kernel <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH] tty: serial: Add 8250-core based omap driver
References: <1404316809-20637-1-git-send-email-bigeasy@linutronix.de> <20140702160932.GF5541@saruman.home> <20140702190944.GA567@drone.musicnaut.iki.fi> <CAOCHtYgxMeA+Arfe40XeFDEKuCJ8qo1RqNR0hYBGr_Wp6sRfdA@mail.gmail.com> <20140703073411.GX28884@atomide.com>
In-Reply-To: <20140703073411.GX28884@atomide.com>
X-Enigmail-Version: 1.6+git0.20140323
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2014 09:34 AM, Tony Lindgren wrote:
> Heh. Just to summarize the reason ttyO needs to be a separate name
> and device entry from ttyS is because we also have external 8250
> devices on GPMC and hotplug busses.

So the GPMC devices will first get a higher minor/device number. The
internal serial ports should show up first. I don't see the problem
(yet).

If you need a separate major number (and name) like we do have it now
(between ttySx and ttyOx) then one of requirements would be to tell
Kconfig that one driver can be active at a time.

For me the ttyS vs ttyO thing is purely cosmetic. I personally don't
like that it is different on different platforms like ttymxc, ttySC,
ttyTHS, …

I understand that it is easier to have a specific name for it so one
does not need to find out which node is which (but then there is udev
which could create unique device names based on attributes). And then
you need enter this thingy to securetty & inittab.

That said I am easy on it. Whatever the majority here decides to be a
sane solution I will try to make it happen.

> 
> Regards,
> 
> Tony
> 

Sebastian
