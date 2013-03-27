Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130Ab3C0Qg2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 12:36:28 -0400
Received: from norkia.v3.sk ([91.210.183.14]:42996 "EHLO norkia.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036Ab3C0Qg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 12:36:26 -0400
Subject: Re: [PATCH v3] watchdog: Add Broadcom BCM2835 watchdog timer driver
From: Lubomir Rintel <lkundrak@v3.sk>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-kernel@vger.kernel.org, Wim Van Sebroeck <wim@iguana.be>,
        Guenter Roeck <linux@roeck-us.net>,
        linux-rpi-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org
In-Reply-To: <51526A41.5090703@wwwdotorg.org>
References: <1364135137-26691-1-git-send-email-lkundrak@v3.sk>
	 <1364320200-23569-1-git-send-email-lkundrak@v3.sk>
	 <51526A41.5090703@wwwdotorg.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Mar 2013 17:36:19 +0100
Message-ID: <1364402179.17807.4.camel@hobbes.kokotovo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-26 at 21:40 -0600, Stephen Warren wrote:
> On 03/26/2013 11:50 AM, Lubomir Rintel wrote:
> > This adds a driver for watchdog timer hardware present on Broadcom BCM2835 SoC,
> > used in Raspberry Pi and Roku 2 devices.
> 
> Since this patch defines a new DT binding, you should send it to
> devicetree-discuss@lists.ozlabs.org too.

Okay.

...
> > + * Interface to the Broadcom BCM2835 watchdog timer hardware is based on
> > + * "bcm2708_wdog" driver written by Luke Diamand that was obtained from branch
> > + * "rpi-3.6.y" of git://github.com/raspberrypi/linux.git
> 
> I see that the patch isn't S-o-b Luke in the downstream kernel. However,
> it is S-o-b Dom Cobley (popcornmix), and they both work for Broadcom, so
> I think that's OK.

Okay, I'll add it.

...
> > +	platform_set_drvdata(pdev, wdt);
> > +	watchdog_set_drvdata(&bcm2835_wdt_wdd, wdt);
> 
> Do you really need both of those? I would have thought just one would
> have been enough.

I think so; I would like to get rid of the platform_*() one, but we need
that in remove hook. All of the existing drivers in drivers/watchdog/
tree either use global data to represent a single device or use two of
the *_set_drvdata() functions -- the watchdog_*() one and dev_*(),
platform_*(), amba_*() or the like.

> I'd be tempted to put the platform_set_drvdata() call right after the
> devm_kzalloc() of wdt, but it's not a big deal either way.

Done.

I'm actually rather thankful for style fixes such as this, since I'm
only getting familiar with what's customary to do there.

Updated patch will follow shortly.

-- 
Lubomir Rintel <lkundrak@v3.sk>

