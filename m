Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760191Ab3CZTrb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 15:47:31 -0400
Received: from mail.active-venture.com ([67.228.131.205]:54575 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023Ab3CZTra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 15:47:30 -0400
X-Originating-IP: 108.223.40.66
Date: Tue, 26 Mar 2013 12:47:37 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Lubomir Rintel <lkundrak@v3.sk>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@wwwdotorg.org>,
        Wim Van Sebroeck <wim@iguana.be>, linux-rpi-kernel@lists.infradead.org,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH v2] watchdog: Add Broadcom BCM2835 watchdog timer driver
Message-ID: <20130326194737.GA26646@roeck-us.net>
References: <1363956907-5644-1-git-send-email-lkundrak@v3.sk>
 <1364134973-26592-1-git-send-email-lkundrak@v3.sk>
 <20130324161241.GB15620@roeck-us.net>
 <1364320075.18728.26.camel@hobbes.kokotovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364320075.18728.26.camel@hobbes.kokotovo>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 06:47:55PM +0100, Lubomir Rintel wrote:
> On Sun, 2013-03-24 at 09:12 -0700, Guenter Roeck wrote:
> > On Sun, Mar 24, 2013 at 03:22:53PM +0100, Lubomir Rintel wrote:
> > > This adds a driver for watchdog timer hardware present on Broadcom BCM2835 SoC,
> > > used in Raspberry Pi and Roku 2 devices.
> > > 
> > > Interface to the Broadcom BCM2835 watchdog timer hardware is based on
> > > "bcm2708_wdog" driver written by Luke Diamand that was obtained from branch
> > > "rpi-3.6.y" of git://github.com/raspberrypi/linux.git
> > > 
> > I would suggest to put that into the coments at the top of the driver.
> > Also, if the original code has a copyright statement, you might want
> > to copy that.
> 
> Okay.
> 
> > > +#include <linux/miscdevice.h>
> > 
> > Just noticed - you should not need that include.
> 
> Well, I think the bottommost line of the driver uses that and it's a
> good practice to provide a device number alias. Is that one completely
> useless?
> 
>   MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
> 
Ah, I didn't realize this is still used. The documentation suggests that it can be
kept when converting drivers to the watchdog core, so I guess there must be a reason.

Thanks,
Guenter
