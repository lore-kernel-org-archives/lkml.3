Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbaIKChR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 22:37:17 -0400
Received: from mga14.intel.com ([192.55.52.115]:6670 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903AbaIKChP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 22:37:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,503,1406617200"; 
   d="scan'208";a="589586979"
Message-ID: <1410403012.25559.69.camel@rzhang1-toshiba>
Subject: Re: [PATCH v4 2/4] dt-bindings: document Rockchip thermal
From: Zhang Rui <rui.zhang@intel.com>
To: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: "edubezval@gmail.com" <edubezval@gmail.com>,
        Caesar Wang <caesar.wang@rock-chips.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Tao Huang <huangtao@rock-chips.com>, Eddie Cai <cf@rock-chips.com>,
        Douglas Anderson <dianders@chromium.org>, dtor <dtor@chromium.org>,
        Chris Zhong <zyw@rock-chips.com>,
        "addy.ke@rock-chips.com" <addy.ke@rock-chips.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        zhaoyifeng <zyf@rock-chips.com>
Date: Thu, 11 Sep 2014 10:36:52 +0800
In-Reply-To: <1487694.oyLYSrbpA8@diego>
References: <1409710239-19941-1-git-send-email-caesar.wang@rock-chips.com>
	 <1410310946.25559.12.camel@rzhang1-toshiba>
	 <CAC-25o9qcddZLy8fcwEqWp7g5fXk31xhaQCcALuH+sXDgn5n8w@mail.gmail.com>
	 <1487694.oyLYSrbpA8@diego>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-09-10 at 09:24 +0200, Heiko Stübner wrote:
> Am Dienstag, 9. September 2014, 21:14:18 schrieb edubezval@gmail.com:
> > Hello,
> > 
> > On Tue, Sep 9, 2014 at 9:02 PM, Zhang Rui <rui.zhang@intel.com> wrote:
> > > On Tue, 2014-09-09 at 11:09 -0400, Eduardo Valentin wrote:
> > >> Hello
> > >> 
> > >> On Tue, Sep 09, 2014 at 01:35:31PM +0200, Heiko Stübner wrote:
> > >> > Am Dienstag, 9. September 2014, 10:27:17 schrieb Zhang Rui:
> > >> > > On Thu, 2014-09-04 at 09:02 +0800, Caesar Wang wrote:
> > >> > > > 在 2014年09月03日 16:07, Heiko Stübner 写道:
> > >> > > > > Am Mittwoch, 3. September 2014, 10:10:37 schrieb Caesar Wang:
> > >> > > > >> This add the necessary binding documentation for the thermal
> > >> > > > >> found on Rockchip SoCs
> > >> > > > >> 
> > >> > > > >> Signed-off-by: zhaoyifeng <zyf@rock-chips.com>
> > >> > > > >> Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
> > >> > > > >> ---
> > >> > > > >> 
> > >> > > > >>   .../devicetree/bindings/thermal/rockchip-thermal.txt | 20
> > >> > > > >> 
> > >> > > > >> ++++++++++++++++++++ 1 file changed, 20 insertions(+)
> > >> > > > >> 
> > >> > > > >>   create mode 100644
> > >> > > > >> 
> > >> > > > >> Documentation/devicetree/bindings/thermal/rockchip-thermal.txt
> > >> > > > >> 
> > >> > > > >> diff --git
> > >> > > > >> a/Documentation/devicetree/bindings/thermal/rockchip-thermal.txt
> > >> > > > >> b/Documentation/devicetree/bindings/thermal/rockchip-thermal.txt
> > >> > > > >> new
> > >> > > > >> file
> > >> > > > >> mode 100644
> > >> > > > >> index 0000000..1ed4d4c
> > >> > > > >> --- /dev/null
> > >> > > > >> +++
> > >> > > > >> b/Documentation/devicetree/bindings/thermal/rockchip-thermal.tx
> > >> > > > >> t
> > >> > > > >> @@ -0,0 +1,20 @@
> > >> > > > >> +* Temperature Sensor ADC (TSADC) on rockchip SoCs
> > >> > > > >> +
> > >> > > > >> +Required properties:
> > >> > > > >> +- compatible: "rockchip,rk3288-tsadc"
> > >> > > > >> +- reg: physical base address of the controller and length of
> > >> > > > >> memory
> > >> > > > >> mapped
> > >> > > > >> +       region.
> > >> > > > >> +- interrupts: The interrupt number to the cpu. The interrupt
> > >> > > > >> specifier
> > >> > > > >> format +           depends on the interrupt controller.
> > >> > > > >> +- clocks: Must contain an entry for each entry in clock-names.
> > >> > > > >> +- clock-names: Shall be "tsadc" for the converter-clock, and
> > >> > > > >> "apb_pclk" for +            the peripheral clock.
> > >> > > > > 
> > >> > > > > You're using the passive-temp, critical-temp and force-shut-temp
> > >> > > > > properties in your driver without declaring them here.
> > >> > > > 
> > >> > > > frankly,the about are need be declared. but  there are 4 types[0]
> > >> > > > for
> > >> > > > trip in thermal framework,
> > >> > > > there is no force-shut for me. So I want to change it three
> > >> > > > additional
> > >> > > > properties in [PATCH V4 4/4],
> > >> > > > 
> > >> > > > 
> > >> > > > [0]
> > >> > > > {
> > >> > > > 
> > >> > > >      THERMAL_TRIP_CRITICAL,
> > >> > > >      THERMAL_TRIP_HOT,
> > >> > > >      THERMAL_TRIP_PASSIVE,
> > >> > > >      THERMAL_TRIP_ACTIVE,
> > >> > > > 
> > >> > > > }
> > >> > > 
> > >> > > this sounds reasonable to me.
> > >> > > 
> > >> > > > > But more importantly, please use the generic trip-points for
> > >> > > > > this. I
> > >> > > > > guess it shouldn't be a problem to introduce a "forced-shutdown"
> > >> > > > > trippoint [0] for the additional trip-point you have - thermal
> > >> > > > > maintainers, please shout if I'm wrong :-)
> > >> > > 
> > >> > > what is the difference between a critical trip point and a
> > >> > > "forced-shutdown" trip point?
> > >> > > Thermal core will do a shutdown in case the critical trip point is
> > >> > > triggered.
> > >> > 
> > >> > The forced-shutdown is where the thermal controller is supposed to also
> > >> > do a>> 
> > >> Currently, there is no discrimination between hardware configured /
> > >> triggered thermal shutdown and software detected / triggered thermal
> > >> shutdown. One way to implement it though is to reuse the critical trip
> > >> type. Even if you use more than one trip type it is doable, it will
> > >> depend on the priorities you give to software triggered and hardware
> > >> triggered.
> > >> 
> > >> > shutdown in hardware. As you said the thermal core will also shutdown
> > >> > at the critical trip point, I guess we could map Caesar's value like
> > >> > 
> > >> > trip-point          tsadc
> > >> > critical            forced-shutdown (the 120 degrees in patch 4)
> > >> > 
> > >> > hot                 critical (the 100 degrees)
> > >> > ...
> > >> 
> > >> In the case we are planing to expand the trip type range, adding one
> > >> specific to hardware configurable shutdown makes sense to me too.
> > > 
> > > hmmm, why? you don't want an orderly shutdown? I still do not understand
> > > why we need a hardware shutdown trip point.
> > > Say, if we expect the system to be shutdown at 100C, I don't think we
> > > have a chance to trigger the hardware shutdown trip point.
> > > Further more, if my understanding is right, thermal core won't do
> > > anything for the hardware shutdown trip point because the system will be
> > > shutdown automatically, right? If this is true, why bother introducing
> > > this to thermal core?
> > 
> > Some ICs allow configuring the temperature when the shutdown will
> > happen. That is, you setup in registers the thermal shutdown
> > threshold, and one of the output pin of the IC is wired to, say, the
> > processor reset pin. Some other ICs have the threshold hardwired, and
> > cannot be configured.
> > 
> > Those options are a last chance to avoid processors to burn, in case
> > software really gets stuck at high temperatures.
> > 
> > The only thing that the thermal driver would need to worry is the
> > configuration step, that is, writing the value to the registers. In
> > the case the thermal core would have a specific trip type for such
> > case, the core itself would not do anything, except allowing designing
> > a thermal zone with hardware shutdown trips. And thus the thermal
> > driver would do the configuration.
> > 
> > 
> > Currently, the way I see to implement this is to interpret critical
> > trips as the threshold to be configured at the IC registers. That is,
> > reusing critical trips as orderly power down and as the hardware
> > shutdown threshold.
> 
> which was what I also meant to express above [but seemingly failed to do 
> properly :-) ].
> 
> Critical is specified as "Hardware not reliable", so I'd think it wouldn't 
> matter how the hw is shut down (orderly/unorderly) as long as its done.

Hmmm,

As what we want is to make thermal driver have a chance to configure the
hardware shutdown registers, I'm thinking if we can do this without
representing the hardware shutdown value as a trip point.
Say,
1. parse DT, and get the hardware shutdown temperature value, and store
it somewhere, e.g. struct __thermal_zone.
2. introduce a new parameter, int (*set_hardware_trip)(void *, long *),
in thermal_zone_of_sensor_register().
3. invoke set_hard_trip(tz, hardware_shutdown_temperature_value) in
thermal_zone_of_sensor_register().

thanks,
rui

