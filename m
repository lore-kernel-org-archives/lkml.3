Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758763Ab3DAPcy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 11:32:54 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37932 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757463Ab3DAPcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 11:32:53 -0400
Date: Mon, 1 Apr 2013 16:32:47 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jean Delvare <jdelvare@suse.de>
Cc: Marek Vasut <marek.vasut@gmail.com>, Guenter Roeck <linux@roeck-us.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: gpio-ucb1400
Message-ID: <20130401153247.GA13517@sirena.org.uk>
References: <1364586399.4216.312.camel@amber.site>
 <201303302020.44584.marek.vasut@gmail.com>
 <20130330232559.GA12864@roeck-us.net>
 <201303311919.06030.marek.vasut@gmail.com>
 <1364814403.4943.7.camel@amber.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364814403.4943.7.camel@amber.site>
X-Cookie: Check your local listings.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 01, 2013 at 01:06:43PM +0200, Jean Delvare wrote:

> My point was, the upstream gpio-ucb1400 driver in its current form is
> unusable (on top of being ugly.) I have no doubt that someone used that
> driver successfully in some external kernel tree, but the code that was
> merged upstream is incomplete and no good.

What the driver is doing is, unfortunately, the best practice for an
AC'97 connected device like this - we've got an uncomfortable mix of
an enumerable bus and platform data combined with a subsystem which has
never had enough love to work in a nice way with the kernel.  The idea
is that any boards which have the device will call the _set_data()
function in their board-specific code.

Sadly we're a little short on volunteers to clean up the AC'97
subsystem so this situation shows little sign of improving.
