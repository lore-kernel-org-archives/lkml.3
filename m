Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751121AbaAGMC4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 07:02:56 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:53324 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750843AbaAGMCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 07:02:52 -0500
Date: Tue, 7 Jan 2014 12:02:48 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Wei Ni <wni@nvidia.com>
Cc: Eduardo Valentin <eduardo.valentin@ti.com>,
        Matthew Longnecker <MLongnecker@nvidia.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "durgadoss.r@intel.com" <durgadoss.r@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv9 02/20] thermal: introduce device tree parser
Message-ID: <20140107120248.GD4180@e106331-lin.cambridge.arm.com>
References: <1384285582-16933-1-git-send-email-eduardo.valentin@ti.com>
 <1384285582-16933-3-git-send-email-eduardo.valentin@ti.com>
 <52C4D612.2090808@nvidia.com>
 <52C5A6CE.5060904@nvidia.com>
 <20140106135145.GD21906@e106331-lin.cambridge.arm.com>
 <52CAC3AF.9020401@ti.com>
 <52CB69FA.9080903@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52CB69FA.9080903@nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 02:44:10AM +0000, Wei Ni wrote:
> On 01/06/2014 10:54 PM, Eduardo Valentin wrote:
> > * PGP Signed by an unknown key
> > 
> > On 06-01-2014 09:51, Mark Rutland wrote:
> >> On Thu, Jan 02, 2014 at 05:50:06PM +0000, Matthew Longnecker wrote:
> >>>
> >>>> I think the platform driver may set governor for the thermal zone,
> >>>> so how about to add a property named as "governor",
> >>>> and parse it to tzp->governor_name,
> >>>> something like:
> >>>>                  ret = of_property_read_string(child, "governor", &str);
> >>>>                  if (ret == 0)
> >>>>                          if (strlen(str) < THERMAL_NAME_LENGTH)
> >>>>                                  strcpy(tzp->governor_name, str);
> >>>>
> >>>> Thanks.
> >>>> Wei.
> >>>
> >>> DT is supposed to describe the hardware, right? The governor isn't 
> >>> hardware -- it's a software control policy. On the other hand, that 
> >>> control policy must be tuned according to the behaviors of the platform 
> >>> hardware otherwise the system will be unstable.
> >>>
> >>> Is it appropriate to be naming the governor in DT? If so, is it equally 
> >>> appropriate to describe any governor-specific parameters in DT (even 
> >>> though they are pure software constructs)?
> >>
> >> The dt should be relatively static -- if the hardware doesn't change the
> >> dt shouldn't have to.
> >>
> >> The governers are not static. We can introduce new ones and throw away
> >> old ones at any time. Tuning parameters can also change at any time.
> >>
> >> I'd prefer to not have governer details described in the dt, and the
> >> choice of governer and configuration of its tuning parameters should be
> >> made at runtime somehow.
> >
> > Agreed.
> 
> Yes, I think so, but the of-thermal driver handle the
> thermal_zone_device_register, and pass the "tzp" without governor_name,
> so the created thermal_zone's governor will be NULL, then it can't run
> into the governor->throttle() if needed. And currently there have no
> interface to support updating governor and configuration at runtime.
> I think it's better to initialize the governor_name when register the
> thermal zone device in the of-thermal driver.

Initialising it in the driver doesn't mean it has to come from the
device tree. That's still a run-time decision, even though it's made
immediately after parsing the DT.

Thanks,
Mark.
