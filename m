Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965178Ab3E2ITu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 04:19:50 -0400
Received: from mail1.bemta14.messagelabs.com ([193.109.254.105]:30425 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965165Ab3E2ITo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 04:19:44 -0400
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 May 2013 04:19:43 EDT
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-14.tower-193.messagelabs.com!1369815171!14771134!1
X-Originating-IP: [83.171.138.125]
X-StarScan-Received: 
X-StarScan-Version: 6.9.6; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Wed, 29 May 2013 10:12:52 +0200
Date: Wed, 29 May 2013 10:14:44 +0200
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: Guenter Roeck <linux@roeck-us.net>
CC: Wim Van Sebroeck <wim@iguana.be>, <linux-watchdog@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 1/2] watchdog: New watchdog driver for MEN A21
 watchdogs
Message-ID: <20130529081444.GA11195@jtlinux>
References: <20130527090756.GA14258@spo001.leaseweb.com>
 <1369678434-13515-1-git-send-email-johannes.thumshirn@men.de>
 <20130527182554.GB14258@spo001.leaseweb.com>
 <20130528081053.GC818@jtlinux>
 <20130528162218.GA22351@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130528162218.GA22351@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [192.1.1.31]
X-OriginalArrivalTime: 29 May 2013 08:12:51.0520 (UTC) FILETIME=[504EDC00:01CE5C44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 09:22:18AM -0700, Guenter Roeck wrote:
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
>
> Thanks,
> Guenter

Well in my tests it was possible, maybe not under extremely high load. But
considering the application these boards (the VME CPU board the watchdogs chip
is on) are usually used by our customers, I hope they can react within a single
second. Another reason why I want to support the 1s timeout is, the VxWorks BSP
does it too and we don't want a Linux driver have less features than it's
VxWorks counterpart, do we ;-). Just kidding. My opinion is, the hardware
supports it and so should the driver, especially for the (safety critical)
industrial control and automation applications our customers usually do. Just
my point of view though.

Regards,
Johannes
