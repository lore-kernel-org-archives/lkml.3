Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284Ab3C0Qjn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 12:39:43 -0400
Received: from norkia.v3.sk ([91.210.183.14]:34936 "EHLO norkia.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140Ab3C0Qjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 12:39:41 -0400
Subject: Re: [PATCH v3] watchdog: Add Broadcom BCM2835 watchdog timer driver
From: Lubomir Rintel <lkundrak@v3.sk>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@wwwdotorg.org>,
        Wim Van Sebroeck <wim@iguana.be>, linux-rpi-kernel@lists.infradead.org,
        linux-watchdog@vger.kernel.org
In-Reply-To: <20130326210348.GA23436@roeck-us.net>
References: <1364135137-26691-1-git-send-email-lkundrak@v3.sk>
	 <1364320200-23569-1-git-send-email-lkundrak@v3.sk>
	 <20130326210348.GA23436@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Mar 2013 17:39:37 +0100
Message-ID: <1364402377.17807.7.camel@hobbes.kokotovo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-26 at 14:03 -0700, Guenter Roeck wrote:
> On Tue, Mar 26, 2013 at 06:50:00PM +0100, Lubomir Rintel wrote:
> > This adds a driver for watchdog timer hardware present on Broadcom BCM2835 SoC,
> > used in Raspberry Pi and Roku 2 devices.

...
> > +static unsigned int heartbeat = 0;
> 
> checkpatch.pl says:
> 
> ERROR: do not initialise statics to 0 or NULL
> #178: FILE: drivers/watchdog/bcm2835_wdt.c:44:
> +static unsigned int heartbeat = 0;

Whoops. Will remove.

> > +	dev_info(dev, "Broadcom BCM2835 watchdog timer");
> > +
> Hmm .. that means you'll get the info message even in the error case.
> Is that intentional ? It is inconsistent with the remap error message
> above, which does not result in the info message.

That was unintentional -- will change that.

> > +	platform_set_drvdata(pdev, NULL);
> 
> Still unnecessary.

Oops -- I'll actually remove it this time.

-- 
Lubomir Rintel <lkundrak@v3.sk>

