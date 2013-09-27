Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632Ab3I0Um7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 16:42:59 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:59869 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574Ab3I0Um4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 16:42:56 -0400
Date: Fri, 27 Sep 2013 13:42:51 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Mark Brown <broonie@kernel.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Jean Delvare <khali@linux-fr.org>,
        Jonathan Cameron <jic23@kernel.org>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-spi@vger.kernel.org
Subject: Re: [PATCH 1/3] spi: Add a spi_w8r16be() helper
Message-ID: <20130927204251.GA30199@roeck-us.net>
References: <1380292469-17347-1-git-send-email-lars@metafoo.de>
 <20130927183456.GM19304@sirena.org.uk>
 <5245D2A0.4090909@metafoo.de>
 <20130927192233.GN19304@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130927192233.GN19304@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 08:22:33PM +0100, Mark Brown wrote:
> On Fri, Sep 27, 2013 at 08:46:56PM +0200, Lars-Peter Clausen wrote:
> 
> > According to the documentation of spi_w8r16() it is a feature.
> 
> > 	* The number is returned in wire-order, which is at least sometimes
> >  	* big-endian.
> 
> Indeed.  I don't think that's terribly well thought through though,
> especially not now we have annotations for endianness (as you noticed!).
> 
> > There seem to be at least two users though which assume that the result is
> > in native endianness drivers/hwmon/ads7871.c and drivers/mfd/stmpe-spi.c
> 
> Yeah, I saw.  The ads7871 is just going to break when run on the
> opposite endianness to the one it was (hopefully) tested on since it
> doesn't make any effort I saw to cope with endianness.  Looking at the
> history it's not terribly obvious which that was but it'd be surprising
> to see a little endian register...
> 
It might make sense to convert the ads7871 driver to an iio driver;
it doesn't look like the chip is commonly used for hardware monitoring.

At least if someone finds the time to do it ;).

Guenter
