Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060Ab3CZRsD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:48:03 -0400
Received: from norkia.v3.sk ([91.210.183.14]:34025 "EHLO norkia.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755389Ab3CZRsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:48:00 -0400
Subject: Re: [PATCH v2] watchdog: Add Broadcom BCM2835 watchdog timer driver
From: Lubomir Rintel <lkundrak@v3.sk>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@wwwdotorg.org>,
        Wim Van Sebroeck <wim@iguana.be>, linux-rpi-kernel@lists.infradead.org,
        linux-watchdog@vger.kernel.org
In-Reply-To: <20130324161241.GB15620@roeck-us.net>
References: <1363956907-5644-1-git-send-email-lkundrak@v3.sk>
	 <1364134973-26592-1-git-send-email-lkundrak@v3.sk>
	 <20130324161241.GB15620@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Mar 2013 18:47:55 +0100
Message-ID: <1364320075.18728.26.camel@hobbes.kokotovo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-03-24 at 09:12 -0700, Guenter Roeck wrote:
> On Sun, Mar 24, 2013 at 03:22:53PM +0100, Lubomir Rintel wrote:
> > This adds a driver for watchdog timer hardware present on Broadcom BCM2835 SoC,
> > used in Raspberry Pi and Roku 2 devices.
> > 
> > Interface to the Broadcom BCM2835 watchdog timer hardware is based on
> > "bcm2708_wdog" driver written by Luke Diamand that was obtained from branch
> > "rpi-3.6.y" of git://github.com/raspberrypi/linux.git
> > 
> I would suggest to put that into the coments at the top of the driver.
> Also, if the original code has a copyright statement, you might want
> to copy that.

Okay.

> > +#include <linux/miscdevice.h>
> 
> Just noticed - you should not need that include.

Well, I think the bottommost line of the driver uses that and it's a
good practice to provide a device number alias. Is that one completely
useless?

  MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);

> > +#define PM_RSTS				0x20
> 
> Not used

Dropped.

> > +#define PM_RSTC_WRCFG_MASK		0x00000030
> 
> Not used

Dropped.

> > +#define PM_RSTS_HADWRH_SET		0x00000040
> 
> Not used

Dropped.

> > +#define PM_RSTC_WRCFG_SET		0x00000030
> 
> Not used 

Dropped.

> > +#define PM_RSTC_WRCFG_FULL_RESET	0x00000020
> 
> Defined twice

Extra occurrence dropped.

> 
> > +#define PM_RSTC_RESET			0x00000102
> > +
> > +#define SECS_TO_WDOG_TICKS(x) ((x) << 16)
> > +#define WDOG_TICKS_TO_SECS(x) ((x) >> 16)
> > +
> > +struct bcm2835_wdt {
> > +	void __iomem		*base;
> > +	spinlock_t		lock;
> > +};
> > +
> > +static int heartbeat = -1;
> 
> The parameter passed to watchdog_init_timeout is an unsigned int, so you should
> really use an unsigned int here. Depending on -1 being converted to maxuint is a
> bit of side effect programming. Easier to just set it to 0, which the watchdog
> core interprets as invalid as well.

Done.

> > +	dev_info(dev, "Broadcom BCM2835 watchdog timer");
> > +
> I think this should come later, after you are sure that there will be
> no failure.

Moved.

> > +	platform_set_drvdata(pdev, NULL);
> 
> It is unnecessary to set this to NULL (the infrastructure does it for you).

Okay.

I've seen this being done on way too many places. I've really should
have checked that though.

Thank you for your response, I'll submit an updated revision shortly.
-- 
Lubomir Rintel <lkundrak@v3.sk>

