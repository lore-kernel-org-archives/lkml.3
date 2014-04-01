Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918AbaDAGMV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 02:12:21 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54374 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbaDAGMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 02:12:19 -0400
Date: Tue, 1 Apr 2014 08:12:16 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Grant Likely <grant.likely@linaro.org>
Cc: devicetree@vger.kernel.org, christoffer.dall@linaro.org,
        linux-kernel@vger.kernel.org, olof@lixom.net, benh@kernel.crashing.org,
        rob.herring@linaro.org
Subject: Re: [RFC 0/5] of: Automatic console registration cleanups
Message-ID: <20140401061216.GQ17250@pengutronix.de>
References: <1396022885-6102-1-git-send-email-grant.likely@linaro.org>
 <20140331071014.GN17250@pengutronix.de>
 <20140331094124.6DEF3C408E1@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140331094124.6DEF3C408E1@trevor.secretlab.ca>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:10:17 up 219 days, 15:41, 43 users,  load average: 0.13, 0.09,
 0.12
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 10:41:24AM +0100, Grant Likely wrote:
> On Mon, 31 Mar 2014 09:10:15 +0200, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> > On Fri, Mar 28, 2014 at 09:08:00AM -0700, Grant Likely wrote:
> > > Hi all,
> > > 
> > > This is a series that I've been playing with over the last few days to
> > > clean up the selection of default console devices when using the device
> > > tree. The device tree defines a way of specifying the console by using a
> > > "stdout-path" property in the /chosen node, but very few drivers
> > > actually attempt to use that data, and so for most platforms there needs
> > > to be a "console=" line in the command line if a serial port is intended
> > > to be used as the console.
> > > 
> > > With this series, if there is a /chosen/stdout-path property, and if
> > > that property points to a serial port node, then when the serial driver
> > > registers the port, the core uart_add_one_port() function will notice
> > > and if no console= argument was provided then add it as a preferred
> > > console.
> > > 
> > > I've not tested this very extensively yet, but I want to get some
> > > feedback before I go further.
> > 
> > I gave it a test on i.MX. It works as expected with both
> > linux,stdout-path and stdout-path. Specifying a console on the
> > commandline still works and overrides the devicetree setting.
> > 
> > Tested-by: Sascha Hauer <s.hauer@pengutronix.de>
> 
> Brilliant! Thanks Sascha.
> 
> Can you supply a patch to add stdout to the imx dts files?

The information which console is used on each board is not in the
kernel. I can create a patch adding stdout for a handful of boards I
know, but I won't catch all.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
