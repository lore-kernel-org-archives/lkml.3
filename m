Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757750Ab3E3VwN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 17:52:13 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:48966 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757925Ab3E3VwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 17:52:04 -0400
Date: Thu, 30 May 2013 23:52:03 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Johannes Thumshirn <johannes.thumshirn@men.de>
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/2] watchdog: New watchdog driver for MEN A21 watchdogs
Message-ID: <20130530215203.GJ14258@spo001.leaseweb.com>
References: <20130527090756.GA14258@spo001.leaseweb.com> <1369678434-13515-1-git-send-email-johannes.thumshirn@men.de> <20130527182554.GB14258@spo001.leaseweb.com> <20130528081053.GC818@jtlinux>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130528081053.GC818@jtlinux>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johannes,

> On Mon, May 27, 2013 at 08:25:54PM +0200, Wim Van Sebroeck wrote:
> [...]
> > > +	watchdog_set_drvdata(&a21_wdt, drv);
> >
> > I am missing the initialisation of the watchdog's timeout value here...
> 
> This watchdog only knows two timeout values, 1s and 30s with the constraint
> that you can't go back to 30s once your in a 1s timeout without a reset of the
> CPLD. I could initially set it to 30s but that would be redundant.

Yes, but if I use a WDIOC_GETTIMEOUT ioctl call then I will get 0 because
you didn't initialize a21_wdt.timeout so you don't know wether or not
it's 30 or 1.

You can also set it default to 1 and use a timer to do the bridge between userspace
and an in kernel timer of 0.5msec. (see git/linux-watchdog/drivers/watchdog/pika_wdt.c
as an example).

Kind regards,
Wim.

