Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834Ab3HTPfH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 11:35:07 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:41733 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab3HTPfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 11:35:02 -0400
Date: Tue, 20 Aug 2013 08:34:56 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Oleksandr Kozaruk <oleksandr.kozaruk@ti.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jonathan Cameron <jic23@kernel.org>
Subject: Re: [PATCH] iio: adc: Add bindigs documentation for twl6030 GPADC
Message-ID: <20130820153456.GA12618@roeck-us.net>
References: <1376911765-7821-1-git-send-email-oleksandr.kozaruk@ti.com>
 <20130820091228.GW3719@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130820091228.GW3719@e106331-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 10:12:28AM +0100, Mark Rutland wrote:
> Hi Oleksandr,
> 
> [Adding Jonathan Cameron and Guenter Roeck to Cc]
> 
> Apologies for the delay replying to this. In attempting to verify this
> made sense I went and read the IIO bindings documentation, and I'm
> somewhat confused by the model.
> 
> As far as I can see, the only consumer of IIO channels is the
> "iio-hwmon" binding, which seems to be a binding for Linux-specific
> infrastructure rather than any actual device. This runs counter to the

In respect to "iio-hwmon", I think you may actually be correct; we should
have found a better means to describe the system.
The intend was to describe that a set of adc inputs is connected
to a set of voltages or temperature sensors.

Is there a better way ? I am sure there is, but I have no idea what
it might be, nor do I have the time to find out.

However, I think that the "io-channels" property is well defined.

"gpios" describes a group of gpio pins which have a common purpose.
"io-channels" describes a group of io channels (or, ultimately, pins)
which have a common purpose. So this is not really linux specific,
unless other operating systems don't see the need of describing a group
of io channels as single entity. But then the same could be claimed
about groups of gpio pins.

> way DT is supposed to function (describing the hardware rather than how
> it's used). As far as I can see, this linkage is described because only
> a subset of the ADCs on the device are actually wired to something?
> 
Is that a problem ? I would think that the same is true for many chips
with multiple inputs and/or outputs.

> I also see a couple of IIO bindings ("adi,adf435x*, and "adi,ad7303")
> which don't describe any iio channel cells at all, so I'm somewhat
> confused by what the IIO channels actually represent, and why they must
> be consumed elsewhere. As far as I can see, an IIO channel represents a
> single ADC's registers in an IIO device, so I'm not sure why this must
> be exported via the channel concept -- it's not physically wired.
> 
I am sure there would be some other means to describe the same,
so I would agree that it does not _have_ to be the way it is.

Question is if there is a better way. Again, "io-channels" describes
a group of io channels with a common purpose. Sure, that does not _have_
to be described as a single property, but then I could argue that the same
is true for "gpios" and probably many other properties.

Thanks,
Guenter
