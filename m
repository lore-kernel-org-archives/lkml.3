Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab3EaJf7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 05:35:59 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:63863 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367Ab3EaJfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 05:35:51 -0400
MIME-Version: 1.0
In-Reply-To: <20130530220247.GA2275@roeck-us.net>
References: <20130527090756.GA14258@spo001.leaseweb.com>
	<1369678434-13515-1-git-send-email-johannes.thumshirn@men.de>
	<20130527182554.GB14258@spo001.leaseweb.com>
	<20130528081053.GC818@jtlinux>
	<20130528162218.GA22351@roeck-us.net>
	<20130530215928.GL14258@spo001.leaseweb.com>
	<20130530220247.GA2275@roeck-us.net>
Date: Fri, 31 May 2013 15:05:50 +0530
Message-ID: <CAK7N6vpwizg3zAJtY2VTsXoccPhsAx0B5Em4TSJoRycz421S3Q@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] watchdog: New watchdog driver for MEN A21 watchdogs
From: anish singh <anish198519851985@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Wim Van Sebroeck <wim@iguana.be>,
        Johannes Thumshirn <johannes.thumshirn@men.de>,
        linux-watchdog@vger.kernel.org,
        linux-kernel-mail <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

On Fri, May 31, 2013 at 3:32 AM, Guenter Roeck <linux@roeck-us.net> wrote:
> On Thu, May 30, 2013 at 11:59:28PM +0200, Wim Van Sebroeck wrote:
>> Hi Guenter,
>>
>> > On Tue, May 28, 2013 at 10:10:53AM +0200, Johannes Thumshirn wrote:
>> > > On Mon, May 27, 2013 at 08:25:54PM +0200, Wim Van Sebroeck wrote:
>> > > [...]
>> > > > > +     watchdog_set_drvdata(&a21_wdt, drv);
>> > > >
>> > > > I am missing the initialisation of the watchdog's timeout value here...
>> > >
>> > > This watchdog only knows two timeout values, 1s and 30s with the constraint
>> > > that you can't go back to 30s once your in a 1s timeout without a reset of the
>> > > CPLD. I could initially set it to 30s but that would be redundant.
>> > >
>> > I wonder - why bother with supporting one-second timeouts ?
>> >
>> > Is this realistic, ie can you guarantee that the watchdog will be pinged fast
>> > enough to keep the system alive under all load conditions ? As far as I know
>> > you can not even configure the watchdog application for less than 1 second
>> > ping intervals.
>>
>> that's why certain drivers use a timer to keep kicking the watchdog at
>> a rate of 0.5s (do a grep on HZ/2) untill userspace times out.
>> (example: drivers/watchdog/pika_wdt.c or drivers/watchdog/pcwd.c).
>>
> Yes, I have used the same trick in a couple of my drivers. That isn't done here,
> though.
>
> I even thought about adding this capability to the infrastructure.

If you don't mind can I give it a try?
>
> Thanks,
> Guenter
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
