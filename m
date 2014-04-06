Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbaDFJbC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 05:31:02 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37817 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143AbaDFJbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 05:31:00 -0400
Date: Sun, 6 Apr 2014 11:30:53 +0200
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Axel Lin <axel.lin@ingics.com>
Cc: Thierry Reding <thierry.reding@gmail.com>, Bryan Wu <cooloney@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Maximilian =?iso-8859-1?Q?G=FCntner?= 
	<maximilian.guentner@gmail.com>,
        linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [PATCH RFC] leds: pca9685: Remove leds-pca9685 driver
Message-ID: <20140406093053.GH12170@pengutronix.de>
References: <1396754381.13341.4.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396754381.13341.4.camel@phoenix>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:16:02 up 224 days, 18:46, 40 users,  load average: 0,01, 0,02,
 0,05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: str@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Sun, Apr 06, 2014 at 11:19:41AM +0800, Axel Lin wrote:
> This driver is replaced by pwm-pca9685 driver and there is no user uses this
> driver in current tree. So remove it.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
> Hi,
> I found there is a modalias conflict between leds-pca9685.ko and pwm-pca9685.ko.
> I think this conflict will cause problem.
> After checking the code, I think leds-pca9685 is replaced by pwm-pca9685.

This confused me for a second, as there was no driver to replace when I wrote
the pwm-pca9685 driver and I thought I missed something. But it seems I didn't
and the pwm-pca9685 is actually older.

> Use git grep to check current tree and found there is no user uses leds-pca9685.
> So this patch removes leds-pca9685 driver.
> 

If the platform setup is needed, maybe this can be integrated into the pwm driver
instead of completely dropping it. I don't care for platform code, but if someone
does, I don't want him to lose the support for it.

Otherwise I am okay with this drop (okay, I'm completely biased of course ;-)).
But technically the pca9685 is not solely a LED driver IC, but a PWM IC, so it
is in the wrong place anyhow.

Regards,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
