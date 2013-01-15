Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540Ab3AOIs2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 03:48:28 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:62276 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565Ab3AOIs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 03:48:26 -0500
Date: Tue, 15 Jan 2013 08:48:21 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Joe Perches <joe@perches.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com, cbouatmailru@gmail.com,
        Jonas Aaberg <jonas.aberg@stericsson.com>
Subject: Re: [PATCH 04/18] power: ab8500_fg: Replace msleep() with
 usleep_range() for greater accuracy
Message-ID: <20130115084821.GT12385@gmail.com>
References: <1357909986-9262-1-git-send-email-lee.jones@linaro.org>
 <1357909986-9262-5-git-send-email-lee.jones@linaro.org>
 <1358183857.19400.13.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1358183857.19400.13.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jan 2013, Joe Perches wrote:

> On Fri, 2013-01-11 at 13:12 +0000, Lee Jones wrote:
> > Doing so provides a greater degree of accuracy when dealing with
> > time-frames between 1us and 20ms. msleep() is only accurate for
> > wake-ups greater than 20ms.
> []
> > diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
> []
> > @@ -956,7 +956,7 @@ static int ab8500_fg_load_comp_volt_to_capacity(struct ab8500_fg *di)
> >  	do {
> >  		vbat += ab8500_fg_bat_voltage(di);
> >  		i++;
> > -		msleep(5);
> > +		usleep_range(5000, 5001);
> 
> If you're going to give a range that small
> you might as well use usleep instead.
> 
> Otherwise, add some tolerance to allow any
> other coalesced wakeup to occur.

I can't increase the tolerance, as I don't know how that would
effect the running of the system, and the person who would know
is off on parental leave.

What I can tell you is we're only using usleep_range() because
there is no usleep in the kernel. At least that's what we've
been led to believe:

Documentation/timers/timers-howto.txt:

                - Why is there no "usleep" / What is a good range?
                        Since usleep_range is built on top of hrtimers, the
                        wakeup will be very precise (ish), thus a simple
                        usleep function would likely introduce a large number
                        of undesired interrupts.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
