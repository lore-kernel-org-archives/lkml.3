Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552AbaHZMJH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 08:09:07 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:58957 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757684AbaHZMJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 08:09:05 -0400
Date: Tue, 26 Aug 2014 08:08:57 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Wei Ni <wni@nvidia.com>
Cc: khali@linux-fr.org, linux@roeck-us.net, swarren@wwwdotorg.org,
        lm-sensors@lm-sensors.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/4] thermal: add more description for thermal-zones
Message-ID: <20140826120855.GA15219@developer>
References: <1408948188-4181-1-git-send-email-wni@nvidia.com>
 <1408948188-4181-4-git-send-email-wni@nvidia.com>
 <20140825110711.GA12349@developer>
 <53FBF8F9.7070708@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53FBF8F9.7070708@nvidia.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Aug 26, 2014 at 11:03:21AM +0800, Wei Ni wrote:
> On 08/25/2014 07:07 PM, Eduardo Valentin wrote:
> > Hello Wei Ni,
> > 
> > On Mon, Aug 25, 2014 at 02:29:47PM +0800, Wei Ni wrote:
> >> Add more description for the "polling-delay" property.
> >> Set "trips" and "cooling maps" as optional property, because
> >> if missing these two sub-nodes, the thermal zone device still
> >> work properly.
> >>
> >> Signed-off-by: Wei Ni <wni@nvidia.com>
> >> ---
> >>  Documentation/devicetree/bindings/thermal/thermal.txt | 10 ++++++----
> >>  1 file changed, 6 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/Documentation/devicetree/bindings/thermal/thermal.txt b/Documentation/devicetree/bindings/thermal/thermal.txt
> >> index f5db6b7..e3d3ed9 100644
> >> --- a/Documentation/devicetree/bindings/thermal/thermal.txt
> >> +++ b/Documentation/devicetree/bindings/thermal/thermal.txt
> >> @@ -136,8 +136,8 @@ containing trip nodes and one sub-node containing all the zone cooling maps.
> >>  
> >>  Required properties:
> >>  - polling-delay:	The maximum number of milliseconds to wait between polls
> >> -  Type: unsigned	when checking this thermal zone.
> >> -  Size: one cell
> >> +  Type: unsigned	when checking this thermal zone. If this value is 0, the
> >> +  Size: one cell	driver will not run polling queue, but just cancel it.
> >>  
> > 
> > The description above is specific to Linux kernel implementation
> > nomenclature. DT description needs to be OS agnostic.
> 
> Normally, the user may think a delay of 0 means that software
> continually polls this zone, but in here it mean no polling. May be it's
> better to add this description.
> 

Sure, I am fine adding it. Just please do not use Linux specific
nomenclature.

> > 
> >>  - polling-delay-passive: The maximum number of milliseconds to wait
> >>    Type: unsigned	between polls when performing passive cooling.
> >> @@ -148,14 +148,16 @@ Required properties:
> >>    phandles + sensor
> >>    specifier
> >>  
> >> +Optional property:
> >>  - trips:		A sub-node which is a container of only trip point nodes
> >>    Type: sub-node	required to describe the thermal zone.
> >>  
> >>  - cooling-maps:		A sub-node which is a container of only cooling device
> >>    Type: sub-node	map nodes, used to describe the relation between trips
> >> -			and cooling devices.
> >> +			and cooling devices. If missing the "trips" property,
> >> +			This sub-node will not be parsed, because no trips can
> >> +			be bound to cooling devices.
> > 
> > Do you mean if the thermal zone misses the "trips" property? Actually,
> > the binding describes both, cooling-maps and trips, as required
> > properties. Thus, both needs to be in place to consider the thermal zone
> > as a proper described zone.
> > 
> >>  
> >> -Optional property:
> >>  - coefficients:		An array of integers (one signed cell) containing
> >>    Type: array		coefficients to compose a linear relation between
> >>    Elem size: one cell	the sensors listed in the thermal-sensors property.
> >> -- 
> >> 1.8.1.5
> >>
> 
