Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759332AbaGDQ5o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 12:57:44 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:63228 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759256AbaGDQ5l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 12:57:41 -0400
MIME-Version: 1.0
In-Reply-To: <53B6DB74.2050401@linutronix.de>
References: <1404316809-20637-1-git-send-email-bigeasy@linutronix.de>
	<20140702160932.GF5541@saruman.home>
	<20140702190944.GA567@drone.musicnaut.iki.fi>
	<CAOCHtYgxMeA+Arfe40XeFDEKuCJ8qo1RqNR0hYBGr_Wp6sRfdA@mail.gmail.com>
	<20140703073411.GX28884@atomide.com>
	<53B6DB74.2050401@linutronix.de>
Date: Fri, 4 Jul 2014 11:57:40 -0500
Message-ID: <CAOCHtYhJODfoB10VXKtGC=_UaB4uVSZOtDwYG-XxL1wvcxi+fA@mail.gmail.com>
Subject: Re: [RFC PATCH] tty: serial: Add 8250-core based omap driver
From: Robert Nelson <robertcnelson@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Tony Lindgren <tony@atomide.com>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Felipe Balbi <balbi@ti.com>,
        linux kernel <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 4, 2014 at 11:51 AM, Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
> On 07/03/2014 09:34 AM, Tony Lindgren wrote:
>> Heh. Just to summarize the reason ttyO needs to be a separate name
>> and device entry from ttyS is because we also have external 8250
>> devices on GPMC and hotplug busses.
>
> So the GPMC devices will first get a higher minor/device number. The
> internal serial ports should show up first. I don't see the problem
> (yet).
>
> If you need a separate major number (and name) like we do have it now
> (between ttySx and ttyOx) then one of requirements would be to tell
> Kconfig that one driver can be active at a time.
>
> For me the ttyS vs ttyO thing is purely cosmetic. I personally don't
> like that it is different on different platforms like ttymxc, ttySC,
> ttyTHS, …

Maybe it's time to migrate them all to one name? (ttyS)  Does the end
user really care if they have a soc with an omap/imx serial port
driver? Or do they just want to access /dev/ttySx and connect to their
device?

Regards,

-- 
Robert Nelson
http://www.rcn-ee.com/
