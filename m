Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356Ab3EAVCQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 17:02:16 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:46353 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756882Ab3EAVCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 17:02:13 -0400
Date: Wed, 1 May 2013 23:02:02 +0200
From: Oskar Andero <oskar.andero@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [PATCH] iio: adc: add driver for MCP3204/08 12-bit ADC
Message-ID: <20130501210202.GB21719@skinner.xfiles.lan>
References: <1367360497-16820-1-git-send-email-oskar.andero@gmail.com>
 <51812195.3030305@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51812195.3030305@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 16:07 Wed 01 May     , Lars-Peter Clausen wrote:
> On 05/01/2013 12:21 AM, Oskar Andero wrote:
> > This adds support for Microchip's 12 bit AD converters MCP3204 and
> > MCP3208. These chips communicates over SPI and supports single-ended
> > and pseudo-differential configurations.
> > 
> > Cc: Jonathan Cameron <jic23@cam.ac.uk>
> > Cc: Lars-Peter Clausen <lars@metafoo.de>
> > Signed-off-by: Oskar Andero <oskar.andero@gmail.com>
> 
> Hi,
> 
> Looks very good in general. A few minor things, mostly related to the regulator
> handling and a couple of nitpicks inline.

Thanks for reviewing! I will prepare version 2 shortly.

> > +
> > +		ret = regulator_enable(adc->reg);
> > +		if (ret < 0)
> > +			goto reg_free;
> > +	} else {
> > +		adc->ref_mv = pdata->ref_mv;
> 
> I'd like to see this fallback path go away. For supplies with a const voltage
> the fixed-voltage-regulator can be used.
> 

Ok. I added this since the voltage I use for reference is behind a level-shifter,
meaning there is actually no regulator on the board providing that exact
voltage level. Not sure what you mean with "the fixed-voltage-regulator", but
maybe that is what I am looking for in my case?

Thanks!

-Oskar
