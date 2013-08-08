Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964843Ab3HHJdo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 05:33:44 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:60107 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964801Ab3HHJdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 05:33:43 -0400
Date: Thu, 8 Aug 2013 10:33:40 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "kishon@ti.com" <kishon@ti.com>, Stephen Warren <swarren@nvidia.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "broonie@kernel.org" <broonie@kernel.org>
Subject: Re: [PATCH V4] drivers/rtc/rtc-palmas.c: support for backup
 battery charging
Message-ID: <20130808093340.GG14648@e106331-lin.cambridge.arm.com>
References: <1375871392-871-1-git-send-email-ldewangan@nvidia.com>
 <20130807163804.GL28558@e106331-lin.cambridge.arm.com>
 <520295F3.2020401@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520295F3.2020401@nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 07:46:11PM +0100, Laxman Dewangan wrote:
> On Wednesday 07 August 2013 10:08 PM, Mark Rutland wrote:
> > On Wed, Aug 07, 2013 at 11:29:52AM +0100, Laxman Dewangan wrote:
> >> +Optional properties:
> >> +- ti,back-battery-charge-enable: The Palmas series device like TPS65913 or
> >> +	TPS80036 supports the battery backup for powering the RTC when main
> >> +	battery is removed or in very low power state. This flag will enable
> >> +	the backup battery charging.
> > I don't like the wording here as it implies that an OS *must* charge the
> > device, rather than that it *can* charge the device. How about:
> >
> >   - ti,backup-battery-chargeable: There is a chargeable backup battery
> >                                   present.
> >
> 
> The *org* property tells whether charging should be enable or not. This 
> is enabled during init and it is not the runtime configuration for 
> enable/disable.
> By saying "backup-battery-chargeable" means it need other 
> interface/calls to start charging. It does not reflect that charging 
> will be enabled by default.

It doesn't mean that the OS needs to provide some interface to control
charging. It simply means that it's up to the OS as to whether it
charges it (for which Linux's choice can be to always charge the
battery). An OS may choose not implement any charging code at all...

> 
> 
> 
> >> +- ti,back-battery-charge-low-current: Configure lower charging current. Device
> >> +	supports the charging current as < 100mA or >100mA. Low current will
> >> +	set as <100mA.
> > This is somewhat unclear as it reads as a runtime configuration choice,
> > rather than some instances of the device only support being changed at
> > low currents (as I assume is the case?). How about:
> >
> >    - ti,backup-battery-low-current: The backup battery is only chargeable
> >                                     at currents below 100mA.
> 
> Hmm.. I think even if battery can be charge for more than 100mA, there 
> is choice of configure it for less than 100mA.

Ok.

> 
> > What happens if we charge at the wrong current?
> Not much sure but I think it can create battery damage.

If we charge a battery supporting >100mA at a current <100mA, will that
cause damage? Or only if we charge above it's supported current?

If the latter's true, it might make sense to invert the condition and
describe that the battery may be charged at a higher current, with the
default being <100mA. That way a missing property in the dt will only
result in sub-optimal charging rather than battery damage.

Thanks,
Mark.
