Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977Ab3IWPUZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 11:20:25 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:64223 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522Ab3IWPUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 11:20:23 -0400
Date: Mon, 23 Sep 2013 17:20:18 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Mark Brown <broonie@linaro.org>, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-pcmcia@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-fbdev@vger.kernel.org
Subject: Re: [PATCH 0/7] driver core: prevent deferred probe with
 platform_driver_probe
Message-ID: <20130923152018.GB1454@localhost>
References: <20130923134028.GF21013@sirena.org.uk>
 <1379946452-25649-1-git-send-email-jhovold@gmail.com>
 <20130923145029.GV30088@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130923145029.GV30088@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 04:50:29PM +0200, Sascha Hauer wrote:
> On Mon, Sep 23, 2013 at 04:27:25PM +0200, Johan Hovold wrote:
> > Deferred probing cannot be used with platform_driver_probe as by the
> > time probing is retried either the driver has been unregistered or its
> > probe function has been set to platform_drv_probe_fail.
> > 
> > With commit e9354576 ("gpiolib: Defer failed gpio requests by default")
> > the gpio subsystem started returning -EPROBE_DEFER, which in turn
> > several platform drivers using platform_driver_probe return to driver
> > core. Other subsystems (e.g. regulator) has since started doing the
> > same.
> > 
> > The first patch in this series prevents platform drivers using
> > platform_driver_probe from requesting probe deferral while warning that
> > it is not supported.
> > 
> > The remaining patches move six platform-driver probe functions that rely
> > on gpio_request out of __init. There are likely other probe functions
> > that might return -EPROBE_DEFER and should be moved out of __init as
> > well.
> 
> As usually when I read this I wonder why platform_driver_probe exists
> anyway. The only advantage I can think off is that the probe functions
> are in __init and thus can be disposed of later. Now you remove the
> __init annotations from these probe functions. Wouldn't it be better to
> convert the drivers to regular platform_driver_register instead?

Perhaps that paragraph was a bit unclear: I move them out of __init
_and_ use platform_driver_register instead of platform_driver_probe as
well.

Johan
