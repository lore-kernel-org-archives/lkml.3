Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab3I3Pk4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 11:40:56 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:44788 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754790Ab3I3Pkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 11:40:52 -0400
Date: Mon, 30 Sep 2013 16:40:50 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "wni@nvidia.com" <wni@nvidia.com>, "joe@perches.com" <joe@perches.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "durgadoss.r@intel.com" <durgadoss.r@intel.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCHv6 02/16] drivers: thermal: introduce device tree parser
Message-ID: <20130930154050.GB22259@e106331-lin.cambridge.arm.com>
References: <1379537849-28425-1-git-send-email-eduardo.valentin@ti.com>
 <1379540136-28378-1-git-send-email-eduardo.valentin@ti.com>
 <20130923104003.GA16069@e106331-lin.cambridge.arm.com>
 <5242051F.70609@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5242051F.70609@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 10:33:19PM +0100, Eduardo Valentin wrote:
> On 23-09-2013 06:40, Mark Rutland wrote:
> > 
> > It would be nice to have a name for the cells after a phandle which
> > describe the cooling device's configuration. You've called them
> > parameters here, but it probably makes sense to call them a
> > cooling-specifier (following clock-specifier and interrupt-specifier).
> 
> Maybe it was not very clear, and I am working on improving this, but
> what I am proposing is simply to have:
>  cooling-device = <&cdev min max>
> 
> where min and max are one cell unsigned values referring to minimum
> cooling level and maximum cooling level, for this reference. Note that
> 'cdev' may have 10 levels, but in this reference we may use only from 6
> to 10:
>  cooling-device = <&cdev 6 10>;
> 
> I don't see a need to have a cooling-names for this case. And for now, I
> also don't see why we would use other specifiers. But we can leave it
> open for future extensions.

There seesm to be some confusion ehre, so let me clarify.  I was asking
for consistent terminology (i.e. "cooling-specifier" rather than
"parameters"), not *-names properties. Consistent terminology and style
makes binding far easier to read.

> 
> It does make sense to have thermal-sensor-names (using thermal-sensor as
> per your suggestion). Because it makes clear where the sensor is in the
> case of using several sensors in one zone. Just like in the example I
> already gave:

Is there a way this can be useful at run-time, or could this just be
achieved with comments in the dt?

> > +cpu-thermal: cpu-thermal {
> > +	polling-delay-passive = <250>; /* milliseconds */
> > +	polling-delay = <1000>; /* milliseconds */
> > +
> > +		/* sensor       ID */
> > +     thermal-sensors = <&bandgap0	0>,
> > +		  	  <&adc		0>;
> > +	thermal-sensors-names = "cpu", "pcb north";
> > +
> > +		/* hotspot = 100 * bandgap - 120 * adc + 484 */
> > +	coefficients = 		<100	-120	484>;
> > +
> > +        trips {
> > +		...
> > +        };
> > +
> > +	cooling-attachments {
> > +		...
> > +	};
> > +};

Cheers,
Mark.
