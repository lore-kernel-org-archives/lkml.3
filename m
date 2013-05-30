Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758988Ab3E3V7f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 17:59:35 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:48977 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758219Ab3E3V7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 17:59:30 -0400
Date: Thu, 30 May 2013 23:59:28 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Johannes Thumshirn <johannes.thumshirn@men.de>,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/2] watchdog: New watchdog driver for MEN A21 watchdogs
Message-ID: <20130530215928.GL14258@spo001.leaseweb.com>
References: <20130527090756.GA14258@spo001.leaseweb.com> <1369678434-13515-1-git-send-email-johannes.thumshirn@men.de> <20130527182554.GB14258@spo001.leaseweb.com> <20130528081053.GC818@jtlinux> <20130528162218.GA22351@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130528162218.GA22351@roeck-us.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

> On Tue, May 28, 2013 at 10:10:53AM +0200, Johannes Thumshirn wrote:
> > On Mon, May 27, 2013 at 08:25:54PM +0200, Wim Van Sebroeck wrote:
> > [...]
> > > > +	watchdog_set_drvdata(&a21_wdt, drv);
> > >
> > > I am missing the initialisation of the watchdog's timeout value here...
> > 
> > This watchdog only knows two timeout values, 1s and 30s with the constraint
> > that you can't go back to 30s once your in a 1s timeout without a reset of the
> > CPLD. I could initially set it to 30s but that would be redundant.
> > 
> I wonder - why bother with supporting one-second timeouts ?
> 
> Is this realistic, ie can you guarantee that the watchdog will be pinged fast
> enough to keep the system alive under all load conditions ? As far as I know
> you can not even configure the watchdog application for less than 1 second
> ping intervals.

that's why certain drivers use a timer to keep kicking the watchdog at
a rate of 0.5s (do a grep on HZ/2) untill userspace times out.
(example: drivers/watchdog/pika_wdt.c or drivers/watchdog/pcwd.c).

Kind regards,
Wim.

