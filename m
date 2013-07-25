Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846Ab3GYRdj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 13:33:39 -0400
Received: from service87.mimecast.com ([91.220.42.44]:33712 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756291Ab3GYRdg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 13:33:36 -0400
Message-ID: <1374773611.3213.44.camel@hornet>
Subject: Re: RFC: device thermal limits represented in device tree nodes
From: Pawel Moll <pawel.moll@arm.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Durgadoss R <durgadoss.r@intel.com>,
        "Zhang, Rui" <rui.zhang@intel.com>, Wei Ni <wni@nvidia.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 25 Jul 2013 18:33:31 +0100
In-Reply-To: <51F15E42.1060409@ti.com>
References: <51ED40E3.5020703@ti.com> <51EF3186.9060001@wwwdotorg.org>
	 <1374664745.25700.118.camel@hornet> <51EFED19.5090900@ti.com>
	 <1374768928.3213.31.camel@hornet> <51F15E42.1060409@ti.com>
X-Mailer: Evolution 3.8.2-0ubuntu1~raring1
Mime-Version: 1.0
X-OriginalArrivalTime: 25 Jul 2013 17:33:31.0810 (UTC) FILETIME=[15078020:01CE895D]
X-MC-Unique: 113072518333400201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-25 at 18:20 +0100, Eduardo Valentin wrote:
> >> 	thermal_zone {
> >> 		type = "CPU";
> > 
> > So what does this exactly mean? What is so special about CPU? What other
> > types you've got there? (Am I just lazy not looking at the numerous
> > links you provided? ;-)
> 
> Hehehe. OK. Type is supposed to describe what your zone is representing.

As in "a name"? So, for example "The board", "PSU"? What I meant to ask
was: does the string carry any meaning?

> >> 		monitoring_device = <&sensor@xxxx
> >> 				    &sensor@yyyy>;
> >>
> >> 		mask = <0x03>; /* trips writability */
> >> 		passive_delay = <250>; /* milliseconds */
> >> 		polling_delay = <1000>; /* milliseconds */
> >> 		policy = "step_wise";
> > 
> > The word "policy" doesn't sound to me like a "hardware feature",
> > wouldn't you agree?
> 
> Agreed. As I mentioned in other email, we can leave this to OS decide
> what to use, by default, for instance.

Cool, I believe it is the right thing to do.

> > 
> >> 		trips {
> >> 			alert@100000{
> >> 				temperature = <100000>; /* milliCelsius
> >> 				hysteresis = <2000>; /* milliCelsius */
> >> 				type = <THERMAL_TRIP_PASSIVE>;
> >> 			};
> >> 			crit@125000{
> >> 				temperature = <125000>; /* milliCelsius
> >> 				hysteresis = <2000>; /* milliCelsius */
> >> 				type = <THERMAL_TRIP_CRITICAL>;
> >> 			};
> >> 		};
> >> 		bind_params {
> >> 			action@0{
> >>				cooling_device = "thermal-cpufreq";
> > 
> > Why is it a string? It seems very Linux-y... (cpufreq) Is there any
> > particular reason not to have phandles to the fans that have any impact
> > on the zone? 
> 
> Because fans are not the only way to cool your system, specially those
> systems that don't feature fans. Managing the speed of your CPU is one
> example of lowering temperature without fans. Managing the load on your
> system is another way. These are obviously, virtual concepts. And
> because we have physical ways and logical ways to cool the zone, then I
> didnt put a phandle to a device there.

"virtual concepts"... This is where my problem lies... It's not hardware
so it doesn't seem to belong in the tree at the first sight. Shouldn't
it focus on "physical data" instead? As in: point at devices that have
some impact on the conditions? For example, you can say "please, do the
right thing to cool your environment down" to both CPU and fan, can't
you? The "cooling driver" for the CPU would know that it has to slow
down, while a driver for the fan would know that it has to speed up ;-)

What I'm trying to say is that in my opinion the tree should simply link
the object, the sensor and the actuator. Nothing more, nothing less.

Thanks for your time!

Pawel


