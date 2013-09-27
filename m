Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545Ab3I0SpP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 14:45:15 -0400
Received: from smtp-out-093.synserver.de ([212.40.185.93]:1046 "EHLO
	smtp-out-091.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754341Ab3I0SpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 14:45:13 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 2125
Message-ID: <5245D2A0.4090909@metafoo.de>
Date: Fri, 27 Sep 2013 20:46:56 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130922 Icedove/17.0.9
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>,
        Jonathan Cameron <jic23@kernel.org>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-spi@vger.kernel.org
Subject: Re: [PATCH 1/3] spi: Add a spi_w8r16be() helper
References: <1380292469-17347-1-git-send-email-lars@metafoo.de> <20130927183456.GM19304@sirena.org.uk>
In-Reply-To: <20130927183456.GM19304@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2013 08:34 PM, Mark Brown wrote:
> On Fri, Sep 27, 2013 at 04:34:27PM +0200, Lars-Peter Clausen wrote:
>> This patch adds a new spi_w8r16be() helper, which is similar to spi_w8r16()
>> except that it converts the read data word from big endian to native endianness
>> before returning it. The reason for introducing this new helper is that for SPI
> 
> This actually feels like a bug in spi_w8r16() - I'd expect it to be
> returning native endian in the first place since in SPI a word is by
> default big endian so I'd expect this to have more of a register I/O
> model.  It certainly seems to match what almost all of the users are
> doing.

According to the documentation of spi_w8r16() it is a feature.

	* The number is returned in wire-order, which is at least sometimes
 	* big-endian.

There seem to be at least two users though which assume that the result is
in native endianness drivers/hwmon/ads7871.c and drivers/mfd/stmpe-spi.c

> 
> That said I'm not sure this is worth fixing in which case the new API
> makes sense.  Or converting the users to regmap I guess.
> 

regmap is always my first choice, but the users are all devices having
varying register sizes, so regmap is not working that nicely.

- Lars

