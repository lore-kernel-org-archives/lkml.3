Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab3EaKJU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 06:09:20 -0400
Received: from mail.active-venture.com ([67.228.131.205]:58135 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864Ab3EaKJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 06:09:11 -0400
X-Originating-IP: 108.223.40.66
Date: Fri, 31 May 2013 03:09:41 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: anish singh <anish198519851985@gmail.com>
Cc: Wim Van Sebroeck <wim@iguana.be>,
        Johannes Thumshirn <johannes.thumshirn@men.de>,
        linux-watchdog@vger.kernel.org,
        linux-kernel-mail <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 1/2] watchdog: New watchdog driver for MEN A21
 watchdogs
Message-ID: <20130531100941.GA31434@roeck-us.net>
References: <20130527090756.GA14258@spo001.leaseweb.com>
 <1369678434-13515-1-git-send-email-johannes.thumshirn@men.de>
 <20130527182554.GB14258@spo001.leaseweb.com>
 <20130528081053.GC818@jtlinux>
 <20130528162218.GA22351@roeck-us.net>
 <20130530215928.GL14258@spo001.leaseweb.com>
 <20130530220247.GA2275@roeck-us.net>
 <CAK7N6vpwizg3zAJtY2VTsXoccPhsAx0B5Em4TSJoRycz421S3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK7N6vpwizg3zAJtY2VTsXoccPhsAx0B5Em4TSJoRycz421S3Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 03:05:50PM +0530, anish singh wrote:
> Hi Guenter,
> 
> On Fri, May 31, 2013 at 3:32 AM, Guenter Roeck <linux@roeck-us.net> wrote:
> > On Thu, May 30, 2013 at 11:59:28PM +0200, Wim Van Sebroeck wrote:
> >> Hi Guenter,
> >>
> >> > On Tue, May 28, 2013 at 10:10:53AM +0200, Johannes Thumshirn wrote:
> >> > > On Mon, May 27, 2013 at 08:25:54PM +0200, Wim Van Sebroeck wrote:
> >> > > [...]
> >> > > > > +     watchdog_set_drvdata(&a21_wdt, drv);
> >> > > >
> >> > > > I am missing the initialisation of the watchdog's timeout value here...
> >> > >
> >> > > This watchdog only knows two timeout values, 1s and 30s with the constraint
> >> > > that you can't go back to 30s once your in a 1s timeout without a reset of the
> >> > > CPLD. I could initially set it to 30s but that would be redundant.
> >> > >
> >> > I wonder - why bother with supporting one-second timeouts ?
> >> >
> >> > Is this realistic, ie can you guarantee that the watchdog will be pinged fast
> >> > enough to keep the system alive under all load conditions ? As far as I know
> >> > you can not even configure the watchdog application for less than 1 second
> >> > ping intervals.
> >>
> >> that's why certain drivers use a timer to keep kicking the watchdog at
> >> a rate of 0.5s (do a grep on HZ/2) untill userspace times out.
> >> (example: drivers/watchdog/pika_wdt.c or drivers/watchdog/pcwd.c).
> >>
> > Yes, I have used the same trick in a couple of my drivers. That isn't done here,
> > though.
> >
> > I even thought about adding this capability to the infrastructure.
> 
> If you don't mind can I give it a try?

I don't mind, but you might want to wait for Wim's feedback.

Thanks,
Guenter
