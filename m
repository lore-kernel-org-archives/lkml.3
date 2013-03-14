Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215Ab3CNOGu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 10:06:50 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42487 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756661Ab3CNOGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 10:06:48 -0400
Date: Thu, 14 Mar 2013 15:06:31 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Fabio Porcedda <fabio.porcedda@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-ide@vger.kernel.org, lm-sensors@lm-sensors.org,
        linux-input@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 10/10] drivers: misc: use module_platform_driver_probe()
Message-ID: <20130314140631.GM1906@pengutronix.de>
References: <1363266691-15757-1-git-send-email-fabio.porcedda@gmail.com>
 <1363266691-15757-12-git-send-email-fabio.porcedda@gmail.com>
 <201303141358.05616.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201303141358.05616.arnd@arndb.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 15:02:16 up 264 days,  5:13, 119 users,  load average: 2.42, 3.07,
 2.74
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 01:58:05PM +0000, Arnd Bergmann wrote:
> On Thursday 14 March 2013, Fabio Porcedda wrote:
> > This patch converts the drivers to use the
> > module_platform_driver_probe() macro which makes the code smaller and
> > a bit simpler.
> > 
> > Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > ---
> >  drivers/misc/atmel_pwm.c  | 12 +-----------
> >  drivers/misc/ep93xx_pwm.c | 13 +------------
> >  2 files changed, 2 insertions(+), 23 deletions(-)
> 
> The patch itself seems fine, but there are two issues around it:
> 
> * The PWM drivers should really get moved to drivers/pwm and converted to the new
>   PWM subsystem. I don't know if Hartley or Hans-Christian have plans to do
>   that already.
> 
> * Regarding the use of module_platform_driver_probe, I'm a little worried about
>   the interactions with deferred probing. I don't think there are any regressions,
>   but we should probably make people aware that one cannot return -EPROBE_DEFER
>   from a platform_driver_probe function.

I'm worried about this aswell. I think platform_driver_probe shouldn't
be used anymore. Even if a driver does not explicitly make use of
-EPROBE_DEFER, it leaks in very quickly if a driver for example uses a
regulator and just returns the error value from regulator_get.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
