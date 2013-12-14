Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab3LNVhx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 16:37:53 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39586 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568Ab3LNVhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 16:37:52 -0500
Date: Sat, 14 Dec 2013 22:37:43 +0100
From: Philipp Zabel <pza@pengutronix.de>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>, linux-kernel@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] drivers: reset: Mark function as static in core.c
Message-ID: <20131214213743.GA11872@pengutronix.de>
References: <20131214132610.GA8691@rashika>
 <20131214141534.GD5443@mwanda>
 <20131214205657.GQ17601@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131214205657.GQ17601@leaf>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 22:07:15 up 3 days, 10:34, 14 users,  load average: 0,41, 0,40, 0,39
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: pza@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 14, 2013 at 12:56:57PM -0800, Josh Triplett wrote:
> On Sat, Dec 14, 2013 at 05:15:34PM +0300, Dan Carpenter wrote:
> > On Sat, Dec 14, 2013 at 06:56:10PM +0530, Rashika Kheria wrote:
> > > This patch marks the function of_reset_simple_xlate() and
> > > devm_reset_control_put() as static in core.c because it is not used
> > > outside this file.
> > > 
> > > Thus, it also eliminate the following warnings in core.c:
> > > drivers/reset/core.c:46:5: warning: no previous prototype for ‘of_reset_simple_xlate’ [-Wmissing-prototypes]
> > > drivers/reset/core.c:262:6: warning: no previous prototype for ‘devm_reset_control_put’ [-Wmissing-prototypes]
> > > 
> > 
> > These are EXPORT_SYMBOL_GPL() so that doesn't make sense.
> > devm_reset_control_put() is not used at all and of_reset_simple_xlate()
> > doesn't look like it needs to be exported.  Philipp?
> 
> That sounds like the right fix to me: drop devm_reset_control_put and
> its export completely, and drop the export of make
> of_reset_simple_xlate.  Unless there's some relevant out-of-tree caller
> of either function, that seems sensible.

Yes, of_reset_simple_xlate() is used as default if the driver does not specify
the .of_xlate field of the rcdev parameter to reset_controller_register().
It does not need to be exported. This is analogous to of_gpio_simple_xlate.

devm_reset_control_put would be needed if a driver wanted to release
the reset control before the devres cleanup for some reason. I added
it for symmetry with devm_reset_control_get but forgot the header
prototypes.
If this is considered not useful, we should probably also review
devm_{clk,gpiod,phy,pinctrl,pwm,regulator,usb}_put.

regards
Philipp
