Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129AbaIJBDG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 21:03:06 -0400
Received: from mga01.intel.com ([192.55.52.88]:31581 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809AbaIJBDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 21:03:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,494,1406617200"; 
   d="scan'208";a="588912426"
Message-ID: <1410310946.25559.12.camel@rzhang1-toshiba>
Subject: Re: [PATCH v4 2/4] dt-bindings: document Rockchip thermal
From: Zhang Rui <rui.zhang@intel.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Caesar Wang <caesar.wang@rock-chips.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        huangtao@rock-chips.com, cf@rock-chips.com, dianders@chromium.org,
        dtor@chromium.org, zyw@rock-chips.com, addy.ke@rock-chips.com,
        dmitry.torokhov@gmail.com, zhaoyifeng <zyf@rock-chips.com>
Date: Wed, 10 Sep 2014 09:02:26 +0800
In-Reply-To: <20140909150916.GA6095@developer>
References: <1409710239-19941-1-git-send-email-caesar.wang@rock-chips.com>
	 <5407BA10.2030402@rock-chips.com>
	 <1410229637.8085.158.camel@rzhang1-toshiba> <8397565.n78cHk4EtL@diego>
	 <20140909150916.GA6095@developer>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-09 at 11:09 -0400, Eduardo Valentin wrote:
> Hello
> 
> On Tue, Sep 09, 2014 at 01:35:31PM +0200, Heiko Stübner wrote:
> > Am Dienstag, 9. September 2014, 10:27:17 schrieb Zhang Rui:
> > > On Thu, 2014-09-04 at 09:02 +0800, Caesar Wang wrote:
> > > > 在 2014年09月03日 16:07, Heiko Stübner 写道:
> > > > > Am Mittwoch, 3. September 2014, 10:10:37 schrieb Caesar Wang:
> > > > >> This add the necessary binding documentation for the thermal
> > > > >> found on Rockchip SoCs
> > > > >> 
> > > > >> Signed-off-by: zhaoyifeng <zyf@rock-chips.com>
> > > > >> Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
> > > > >> ---
> > > > >> 
> > > > >>   .../devicetree/bindings/thermal/rockchip-thermal.txt | 20
> > > > >> 
> > > > >> ++++++++++++++++++++ 1 file changed, 20 insertions(+)
> > > > >> 
> > > > >>   create mode 100644
> > > > >> 
> > > > >> Documentation/devicetree/bindings/thermal/rockchip-thermal.txt
> > > > >> 
> > > > >> diff --git
> > > > >> a/Documentation/devicetree/bindings/thermal/rockchip-thermal.txt
> > > > >> b/Documentation/devicetree/bindings/thermal/rockchip-thermal.txt new
> > > > >> file
> > > > >> mode 100644
> > > > >> index 0000000..1ed4d4c
> > > > >> --- /dev/null
> > > > >> +++ b/Documentation/devicetree/bindings/thermal/rockchip-thermal.txt
> > > > >> @@ -0,0 +1,20 @@
> > > > >> +* Temperature Sensor ADC (TSADC) on rockchip SoCs
> > > > >> +
> > > > >> +Required properties:
> > > > >> +- compatible: "rockchip,rk3288-tsadc"
> > > > >> +- reg: physical base address of the controller and length of memory
> > > > >> mapped
> > > > >> +       region.
> > > > >> +- interrupts: The interrupt number to the cpu. The interrupt specifier
> > > > >> format +	      depends on the interrupt controller.
> > > > >> +- clocks: Must contain an entry for each entry in clock-names.
> > > > >> +- clock-names: Shall be "tsadc" for the converter-clock, and
> > > > >> "apb_pclk" for +	       the peripheral clock.
> > > > > 
> > > > > You're using the passive-temp, critical-temp and force-shut-temp
> > > > > properties in your driver without declaring them here.
> > > > 
> > > > frankly,the about are need be declared. but  there are 4 types[0] for
> > > > trip in thermal framework,
> > > > there is no force-shut for me. So I want to change it three additional
> > > > properties in [PATCH V4 4/4],
> > > > 
> > > > 
> > > > [0]
> > > > {
> > > > 
> > > >      THERMAL_TRIP_CRITICAL,
> > > >      THERMAL_TRIP_HOT,
> > > >      THERMAL_TRIP_PASSIVE,
> > > >      THERMAL_TRIP_ACTIVE,
> > > > 
> > > > }
> > > 
> > > this sounds reasonable to me.
> > > 
> > > > > But more importantly, please use the generic trip-points for this. I
> > > > > guess it shouldn't be a problem to introduce a "forced-shutdown"
> > > > > trippoint [0] for the additional trip-point you have - thermal
> > > > > maintainers, please shout if I'm wrong :-)
> > > 
> > > what is the difference between a critical trip point and a
> > > "forced-shutdown" trip point?
> > > Thermal core will do a shutdown in case the critical trip point is
> > > triggered.
> > 
> > The forced-shutdown is where the thermal controller is supposed to also do a 
> 
> Currently, there is no discrimination between hardware configured /
> triggered thermal shutdown and software detected / triggered thermal shutdown.
> One way to implement it though is to reuse the critical trip type. Even
> if you use more than one trip type it is doable, it will depend on the
> priorities you give to software triggered and hardware triggered.
> 
> > shutdown in hardware. As you said the thermal core will also shutdown at the 
> > critical trip point, I guess we could map Caesar's value like
> > 
> > trip-point		tsadc
> > critical		forced-shutdown (the 120 degrees in patch 4)
> 
> > hot			critical (the 100 degrees)
> > ...
> > 
> > 
> 
> In the case we are planing to expand the trip type range, adding one
> specific to hardware configurable shutdown makes sense to me too.
hmmm, why? you don't want an orderly shutdown? I still do not understand
why we need a hardware shutdown trip point.
Say, if we expect the system to be shutdown at 100C, I don't think we
have a chance to trigger the hardware shutdown trip point.
Further more, if my understanding is right, thermal core won't do
anything for the hardware shutdown trip point because the system will be
shutdown automatically, right? If this is true, why bother introducing
this to thermal core?

thanks,
rui
> Alhtough, as I mention, I believe with the current generic trip types,
> this situation can be covered already.
>  Besides, I believe
> 'forced-shutdown' does not sound a descriptive enough though. I would
> suggest something more specific, say 'hardware-shutdown'. 
> 
> > > 
> > > thanks,
> > > rui
> > > 
> > > > It's a good option.
> > > > I can send a patch,but I don't know whether the thermal maintainers will
> > > > accept it.
> > > > 
> > > > Maybe,they have a better way to suggest it.:-)
> > > > 
> > > > 
> > > > PS:I will sent a new patch If I still have no received their suggestions
> > > > in two days.
> > > > 
> > > > > Heiko
> > > > > 
> > > > > 
> > > > > [0] in a separate patch, changing
> > > > > - thermal_trip_type enum in include/linux/thermal.h
> > > > > - trip_types mapping in drivers/thermal/of-thermal.c
> > > > > - Documentation/devicetree/bindings/thermal/thermal.txt
> > > > > 
> > > > >> +
> > > > >> +Example:
> > > > >> +tsadc: tsadc@ff280000 {
> > > > >> +	compatible = "rockchip,rk3288-tsadc";
> > > > >> +	reg = <0xff280000 0x100>;
> > > > >> +	interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
> > > > >> +	clocks = <&cru SCLK_TSADC>, <&cru PCLK_TSADC>;
> > > > >> +	clock-names = "tsadc", "apb_pclk";
> > > > >> +};
> > 
> 


