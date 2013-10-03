Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab3JCKhp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 06:37:45 -0400
Received: from smtp-out-164.synserver.de ([212.40.185.164]:1109 "EHLO
	smtp-out-164.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158Ab3JCKhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 06:37:43 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 25208
Message-ID: <524D4967.4030300@metafoo.de>
Date: Thu, 03 Oct 2013 12:39:35 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130922 Icedove/17.0.9
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>,
        Jonathan Cameron <jic23@kernel.org>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-spi@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 1/3] spi: Add a spi_w8r16be() helper
References: <1380292469-17347-1-git-send-email-lars@metafoo.de> <20130927183456.GM19304@sirena.org.uk> <5245D2A0.4090909@metafoo.de> <20130927192233.GN19304@sirena.org.uk> <5245E420.2030207@metafoo.de> <20130929123019.GT19304@sirena.org.uk>
In-Reply-To: <20130929123019.GT19304@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2013 02:30 PM, Mark Brown wrote:
> On Fri, Sep 27, 2013 at 10:01:36PM +0200, Lars-Peter Clausen wrote:
>> On 09/27/2013 09:22 PM, Mark Brown wrote:
> 
>>> Indeed.  I don't think that's terribly well thought through though,
>>> especially not now we have annotations for endianness (as you noticed!).
> 
>> I wouldn't mind updating spi_w8r16() to do the conversion to big-endian.
>> Especially considering that a driver using the function will probably always
>> need to do a endian conversion anyway to work correctly on both
>> endiannesses. We can add a LE variant if we should ever need it.
> 
> I think that's probably the way to go, the API seems to error prone as
> it is.

It looks as if for the ads7871 the wire order is actually little endian.
I'm still not sure about the STMPE as the datasheet and code seem to
contradict each other. But considering that the code probably was tested on
a LE platform, the driver also assumes that spi_w8r16() returns a little
endian word. Maybe we can merge this series as it is, then add a LE version
for the ads7871 and STMPE driver and afterward remove the wire-order
spi_w8r16().

- Lars
