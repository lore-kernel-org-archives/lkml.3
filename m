Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934789Ab3E1QV5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 12:21:57 -0400
Received: from mail.active-venture.com ([67.228.131.205]:54260 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934758Ab3E1QVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 12:21:54 -0400
X-Originating-IP: 108.223.40.66
Date: Tue, 28 May 2013 09:22:18 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Johannes Thumshirn <johannes.thumshirn@men.de>
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/2] watchdog: New watchdog driver for MEN A21
 watchdogs
Message-ID: <20130528162218.GA22351@roeck-us.net>
References: <20130527090756.GA14258@spo001.leaseweb.com>
 <1369678434-13515-1-git-send-email-johannes.thumshirn@men.de>
 <20130527182554.GB14258@spo001.leaseweb.com>
 <20130528081053.GC818@jtlinux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130528081053.GC818@jtlinux>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 10:10:53AM +0200, Johannes Thumshirn wrote:
> On Mon, May 27, 2013 at 08:25:54PM +0200, Wim Van Sebroeck wrote:
> [...]
> > > +	watchdog_set_drvdata(&a21_wdt, drv);
> >
> > I am missing the initialisation of the watchdog's timeout value here...
> 
> This watchdog only knows two timeout values, 1s and 30s with the constraint
> that you can't go back to 30s once your in a 1s timeout without a reset of the
> CPLD. I could initially set it to 30s but that would be redundant.
> 
I wonder - why bother with supporting one-second timeouts ?

Is this realistic, ie can you guarantee that the watchdog will be pinged fast
enough to keep the system alive under all load conditions ? As far as I know
you can not even configure the watchdog application for less than 1 second
ping intervals.

Thanks,
Guenter
