Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578AbaCaJlb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 05:41:31 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:54694 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbaCaJl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 05:41:29 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [RFC 0/5] of: Automatic console registration cleanups
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: devicetree@vger.kernel.org, christoffer.dall@linaro.org,
        linux-kernel@vger.kernel.org, olof@lixom.net, benh@kernel.crashing.org,
        rob.herring@linaro.org
In-Reply-To: <20140331071014.GN17250@pengutronix.de>
References: <1396022885-6102-1-git-send-email-grant.likely@linaro.org> < 20140331071014.GN17250@pengutronix.de>
Date: Mon, 31 Mar 2014 10:41:24 +0100
Message-Id: <20140331094124.6DEF3C408E1@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Mar 2014 09:10:15 +0200, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> On Fri, Mar 28, 2014 at 09:08:00AM -0700, Grant Likely wrote:
> > Hi all,
> > 
> > This is a series that I've been playing with over the last few days to
> > clean up the selection of default console devices when using the device
> > tree. The device tree defines a way of specifying the console by using a
> > "stdout-path" property in the /chosen node, but very few drivers
> > actually attempt to use that data, and so for most platforms there needs
> > to be a "console=" line in the command line if a serial port is intended
> > to be used as the console.
> > 
> > With this series, if there is a /chosen/stdout-path property, and if
> > that property points to a serial port node, then when the serial driver
> > registers the port, the core uart_add_one_port() function will notice
> > and if no console= argument was provided then add it as a preferred
> > console.
> > 
> > I've not tested this very extensively yet, but I want to get some
> > feedback before I go further.
> 
> I gave it a test on i.MX. It works as expected with both
> linux,stdout-path and stdout-path. Specifying a console on the
> commandline still works and overrides the devicetree setting.
> 
> Tested-by: Sascha Hauer <s.hauer@pengutronix.de>

Brilliant! Thanks Sascha.

Can you supply a patch to add stdout to the imx dts files?

g.

