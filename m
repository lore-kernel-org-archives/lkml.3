Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934696AbaH0Nca (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 09:32:30 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:47807 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934676AbaH0Nc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 09:32:27 -0400
Date: Wed, 27 Aug 2014 09:32:18 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Wei Ni <wni@nvidia.com>
Cc: khali@linux-fr.org, linux@roeck-us.net, swarren@wwwdotorg.org,
        lm-sensors@lm-sensors.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/4] thermal: add more description for thermal-zones
Message-ID: <20140827133217.GB15875@developer>
References: <1408948188-4181-1-git-send-email-wni@nvidia.com>
 <1408948188-4181-4-git-send-email-wni@nvidia.com>
 <20140825110711.GA12349@developer>
 <53FBEE39.2020001@nvidia.com>
 <20140826121210.GB15219@developer>
 <53FD484F.7030504@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53FD484F.7030504@nvidia.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Wei,

On Wed, Aug 27, 2014 at 10:54:07AM +0800, Wei Ni wrote:
> On 08/26/2014 08:12 PM, Eduardo Valentin wrote:
> > On Tue, Aug 26, 2014 at 10:17:29AM +0800, Wei Ni wrote:
> >> On 08/25/2014 07:07 PM, Eduardo Valentin wrote:
> >>> Hello Wei Ni,
> >>>
> >>> On Mon, Aug 25, 2014 at 02:29:47PM +0800, Wei Ni wrote:
> >>>> Add more description for the "polling-delay" property.
> >>>> Set "trips" and "cooling maps" as optional property, because
> >>>> if missing these two sub-nodes, the thermal zone device still
> >>>> work properly.
> >>>>
> >>>> Signed-off-by: Wei Ni <wni@nvidia.com>
> >>>> ---
> >>>>  Documentation/devicetree/bindings/thermal/thermal.txt | 10 ++++++----
> >>>>  1 file changed, 6 insertions(+), 4 deletions(-)
> >>>>
> >>>> diff --git a/Documentation/devicetree/bindings/thermal/thermal.txt b/Documentation/devicetree/bindings/thermal/thermal.txt
> >>>> index f5db6b7..e3d3ed9 100644
> >>>> --- a/Documentation/devicetree/bindings/thermal/thermal.txt
> >>>> +++ b/Documentation/devicetree/bindings/thermal/thermal.txt
> >>>> @@ -136,8 +136,8 @@ containing trip nodes and one sub-node containing all the zone cooling maps.
> >>>>  
> >>>>  Required properties:
> >>>>  - polling-delay:	The maximum number of milliseconds to wait between polls
> >>>> -  Type: unsigned	when checking this thermal zone.
> >>>> -  Size: one cell
> >>>> +  Type: unsigned	when checking this thermal zone. If this value is 0, the
> >>>> +  Size: one cell	driver will not run polling queue, but just cancel it.
> >>>>  
> >>>
> >>> The description above is specific to Linux kernel implementation
> >>> nomenclature. DT description needs to be OS agnostic.
> >>>
> >>>>  - polling-delay-passive: The maximum number of milliseconds to wait
> >>>>    Type: unsigned	between polls when performing passive cooling.
> >>>> @@ -148,14 +148,16 @@ Required properties:
> >>>>    phandles + sensor
> >>>>    specifier
> >>>>  
> >>>> +Optional property:
> >>>>  - trips:		A sub-node which is a container of only trip point nodes
> >>>>    Type: sub-node	required to describe the thermal zone.
> >>>>  
> >>>>  - cooling-maps:		A sub-node which is a container of only cooling device
> >>>>    Type: sub-node	map nodes, used to describe the relation between trips
> >>>> -			and cooling devices.
> >>>> +			and cooling devices. If missing the "trips" property,
> >>>> +			This sub-node will not be parsed, because no trips can
> >>>> +			be bound to cooling devices.
> >>>
> >>> Do you mean if the thermal zone misses the "trips" property? Actually,
> >>> the binding describes both, cooling-maps and trips, as required
> >>> properties. Thus, both needs to be in place to consider the thermal zone
> >>> as a proper described zone.
> >>
> >> I moved the "trips" and "cooling-maps" to optional property, because if
> >> missing these two properties, the thermal zone devices still can be
> >> registered, and the driver can work properly, it has the basic function,
> >> can read temperature from thermal sysfs, although it doesn't have trips
> >> and bind with cooling devices.
> > 
> > 
> > If a thermal zone is used only for monitoring, then I believe it lost
> > its purpose. As  Maybe a different framework shall be used, such as hwmon,
> > for instance?
> 
> Yes, if we only use it for monitoring, we can use hwmon. But we have
> more functions base on these two thermal zone devices. We have a
> skin-temperature driver, which used nct1008's remote and local
> temperatures to estimator the skin temperature. As you know the thermal
> framework is more powerful, the remote/local sensors can be register as
> thermal zone, then the skin-temp driver can use thermal_zone_get_temp()
> to read their temperatures and then estimator skin's temp. We also will
> set trips and cooling devices for this skin-temp.

In this case, don't you think it would make sense to create a thermal
zone for the skin temperature and add the required sensors (including
the nct1008) in it?

> 
> Wei.
> 
> > 
> > The purpose of a thermal zone is to describe thermal behavior of a
> > hardware. As it is mentioned in the thermal.txt file.
> > 
> > 
> >>
> >> Thanks.
> >> Wei.
> >>
> >>>
> >>>>  
> >>>> -Optional property:
> >>>>  - coefficients:		An array of integers (one signed cell) containing
> >>>>    Type: array		coefficients to compose a linear relation between
> >>>>    Elem size: one cell	the sensors listed in the thermal-sensors property.
> >>>> -- 
> >>>> 1.8.1.5
> >>>>
> >>
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
