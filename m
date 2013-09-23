Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078Ab3IWOvF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 10:51:05 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44658 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947Ab3IWOvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 10:51:01 -0400
Date: Mon, 23 Sep 2013 16:50:29 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Johan Hovold <jhovold@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Mark Brown <broonie@linaro.org>, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-pcmcia@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-fbdev@vger.kernel.org
Subject: Re: [PATCH 0/7] driver core: prevent deferred probe with
 platform_driver_probe
Message-ID: <20130923145029.GV30088@pengutronix.de>
References: <20130923134028.GF21013@sirena.org.uk>
 <1379946452-25649-1-git-send-email-jhovold@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379946452-25649-1-git-send-email-jhovold@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 16:47:07 up 30 days, 17 min, 51 users,  load average: 0.08, 0.08,
 0.06
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 04:27:25PM +0200, Johan Hovold wrote:
> Deferred probing cannot be used with platform_driver_probe as by the
> time probing is retried either the driver has been unregistered or its
> probe function has been set to platform_drv_probe_fail.
> 
> With commit e9354576 ("gpiolib: Defer failed gpio requests by default")
> the gpio subsystem started returning -EPROBE_DEFER, which in turn
> several platform drivers using platform_driver_probe return to driver
> core. Other subsystems (e.g. regulator) has since started doing the
> same.
> 
> The first patch in this series prevents platform drivers using
> platform_driver_probe from requesting probe deferral while warning that
> it is not supported.
> 
> The remaining patches move six platform-driver probe functions that rely
> on gpio_request out of __init. There are likely other probe functions
> that might return -EPROBE_DEFER and should be moved out of __init as
> well.

As usually when I read this I wonder why platform_driver_probe exists
anyway. The only advantage I can think off is that the probe functions
are in __init and thus can be disposed of later. Now you remove the
__init annotations from these probe functions. Wouldn't it be better to
convert the drivers to regular platform_driver_register instead?

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
