Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375AbaCaHKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 03:10:22 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55502 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283AbaCaHKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 03:10:18 -0400
Date: Mon, 31 Mar 2014 09:10:15 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Grant Likely <grant.likely@linaro.org>
Cc: devicetree@vger.kernel.org, christoffer.dall@linaro.org,
        linux-kernel@vger.kernel.org, olof@lixom.net, benh@kernel.crashing.org,
        rob.herring@linaro.org
Subject: Re: [RFC 0/5] of: Automatic console registration cleanups
Message-ID: <20140331071014.GN17250@pengutronix.de>
References: <1396022885-6102-1-git-send-email-grant.likely@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396022885-6102-1-git-send-email-grant.likely@linaro.org>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:05:09 up 218 days, 16:35, 47 users,  load average: 0.11, 0.25,
 0.22
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2014 at 09:08:00AM -0700, Grant Likely wrote:
> Hi all,
> 
> This is a series that I've been playing with over the last few days to
> clean up the selection of default console devices when using the device
> tree. The device tree defines a way of specifying the console by using a
> "stdout-path" property in the /chosen node, but very few drivers
> actually attempt to use that data, and so for most platforms there needs
> to be a "console=" line in the command line if a serial port is intended
> to be used as the console.
> 
> With this series, if there is a /chosen/stdout-path property, and if
> that property points to a serial port node, then when the serial driver
> registers the port, the core uart_add_one_port() function will notice
> and if no console= argument was provided then add it as a preferred
> console.
> 
> I've not tested this very extensively yet, but I want to get some
> feedback before I go further.

I gave it a test on i.MX. It works as expected with both
linux,stdout-path and stdout-path. Specifying a console on the
commandline still works and overrides the devicetree setting.

Tested-by: Sascha Hauer <s.hauer@pengutronix.de>

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
