Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759004Ab3GRNyb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 09:54:31 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52071 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756621Ab3GRNy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 09:54:29 -0400
Message-ID: <51E7F341.8020508@ti.com>
Date: Thu, 18 Jul 2013 09:53:05 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        <devicetree-discuss@lists.ozlabs.org>, <wni@nvidia.com>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lm-sensors@lm-sensors.org>, <l.stach@pengutronix.de>
Subject: Re: [lm-sensors] [RESEND PATCH V1 0/9] thermal: introduce DT thermal
 zone build
References: <1374074248-31690-1-git-send-email-eduardo.valentin@ti.com> <20130717220942.GB990@roeck-us.net>
In-Reply-To: <20130717220942.GB990@roeck-us.net>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2PKIAKWKUPUGLHIHAOKRL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2PKIAKWKUPUGLHIHAOKRL
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello Guenter,

On 17-07-2013 18:09, Guenter Roeck wrote:
> On Wed, Jul 17, 2013 at 11:17:19AM -0400, Eduardo Valentin wrote:
>> Hello all,
>>
>> As you noticed, I am working in a way to represent thermal data
>> using device tree [1]. Essentially, this should be a way to say
>> what to do with a sensor and how to associate (cooling) actions
>> with it.
>>
> Seems to me that goes way beyond the supposed scope of devicetree data.=

> Devicetree data is supposed to describe hardware, not its configuration=
 or use.
> This is clearly a use case.

Thanks for rising your voice here. It is important to know what hwmon
ppl think about this.

>=20
> Guenter

As your answers to the series are giving same argument, I chose to
answer on patch 0. I would be happier if you could elaborate a bit more
on your concern, specially if you take hwmon cap here, and give your
view with that perspective.

I also considered that this work could be abusing of DT purposes. But
let me explain why I still think it makes sense to have it.

First thing is that this series intend to describe the thermal data
required for a specific board. That means, considering your board
layout, mechanics, power dissipation and composition of your ICs, etc,
that will impose thermal requirements on your system. That is not
configuration, but part of your board design and non-functional
requirement. To me, configuration would be something like saying you
want to use a specific keyboard layout, or defining your wifi card
channel, or display size, etc.

Here what is described and setup may get confused with configuration,
but it is not because what goes in DT in this case must be actually
derived from your HW needs. Putting a sensor  close to your battery has
a strong meaning behind. Same if you put a sensor close to your
processor. For instance, we have cases we need to consider external heat
in order to properly determine our CPU hotspot level, using a board
sensor. That is what I mean by HW requirement/need.

Again, just to refresh our minds, this is about protecting your board
and ICs from operating out of their spec and extending their lifetime.
This is not about configuring something just because user has chosen to.
That is definitely not a configuration.

Being a use case, well, these new DT nodes can still be seen as a use
case, yes. But depends on your understanding of use case. Because a
sensor device may be used on different needs, composing different use
cases. But still here we are talking about HW needs and composition. And
yes, if you take that perspective, there are use cases already described
in DT.

For instance, just because you use an LDO to power a MMC, does it mean
you always will use it to power MMC on all boards. Would that be a use
case? And in that example, because your MMC requires 2.8V, if you have a
DT property to say that, does it mean it is  configuration? Well, yes,
but that is based on HW needs, otherwise it wont operate properly. Same
thing here, leave your hw operating out of temperature specs and you
will see what is the outcome.

Similar example would be cpufreq, or OPPs for opp layer. Defining an OPP
in DT could be considered a configuration?  Well in theory yes, one can
pick what ever configuration for your (D)PLL then match with a
minimalist voltage level. And in theory, a voltage level can sustain
more than one frequency level. An OPP is still a virtual concept, and we
still describe it in DT. Why? To me is because it is a HW need, because
HW folks have actually validated that configuration of PLL (frequency)
and voltage level. Sometimes they have even optimized it (for low power
consumption for instance), as one may achieve same OPP with different
configuration. Then why thermal data, which is again, a 'HW
configuration' that has been optimized by HW folks, known to be a HW
requirement, cannot be described in DT?

Similar argument goes to the fact that one may think this is subsystem
specific. Again, describing your OPPs is not OPP layer specific?
Besides, one can still read the device tree nodes I have written for
describing thermal data and implement the HW requirement elsewhere, if
wanted (say in user land). I don't see as subsystem specific.

Keep in mind that these very same concepts are actually derived from
ACPI specification. They don't come from nowhere. And just because your
system does not have ACPI support, does not mean it won't have a need to
describe thermal?

So, because with this work (i) we are describing something that is
required for properly usage of your HW (and not choice of the user),
because (ii) same data is used on different specification (that is used
on different OSes too), because (iii) you don't need thermal fw to read
this data and you could implement the HW requirement elsewhere, because
(iv) there are other similar requirements already implemented via DT; I
still think this work is within DT scope. And that is based on evidence
of existing work not because DT is nice and I would want to use it.

Hope that clarifies.

Of course it is always welcome to hear ppl opinion. I would be really
interested to know what ppl from OF think about this topic.

If still, this does not fit DT, I would like to understand a proper
argument. Better than, this is configuration/use case.

>=20
>> The motivation to create such infrastructure is:
>> (i) - to reuse the existing temperature sensor code base;
>> (ii) - have a way to easily describe thermal data across different
>> boards for the same sensor. Say you have an i2c temp sensor,
>> which is placed close to your battery on board A but on
>> board B, another instance of this same senor is placed
>> close to your display, for instance.
>>
>> This series introduces then a DT parser. The data expected in
>> DT must contain the needed properties to build a thermal zone
>> out of the desired sensor. All properties are documented and
>> they are derived from the existing requirements of current
>> thermal API.
>>
>> In order to perform a binding with cooling devices,
>> the new thermal zone built using DT nodes will use
>> the existing thermal API that uses binding parameters. This is
>> the current proposed way to register thermal zones with platform
>> information, written by Durga.
>>
>> There are some virtual concepts that are pushed to device tree,
>> I know. But I believe using device tree to do this makes sense
>> because we are still describing the HW and how they are related
>> to each other. Things like cooling devices are not represented
>> in device tree though, as I believe that will cause a lot of
>> confusion with real devices (as already does).
>>
>> So the series is short but I think it makes sense to describe
>> how it is organized, as it touches several places. First four
>> patches are a preparation for this parser. There is a change
>> on cpufreq-cpu0, so that it knows now how to load its
>> corresponding cooling device. There is a change on thermal_core
>> to split its hwmon code, because I think we may need to improve
>> this code base when we start to integrate better with hwmon
>> temperature sensors. Then, another needed preparation is to
>> improve the bind_params, so that we are able to bind with
>> upper and lower limits. The remaining patches are the changes
>> with the proposed DT parser. A part from the DT thermal zone
>> builder itself (patch 05), I also changed the ti-soc-thermal
>> driver to use this new API and the omap4430 bandgap DT node,
>> as an example (this has been tested on panda omap4430); and also chang=
ed
>> the hwmon drivers lm75 and tmp102 to have the option to build
>> a thermal zone using DT. I haven't touched any dts file using
>> lm75 or tmp102 because this should come on a need basis.
>>
>> I believe this code is pretty usable the way it is, but might
>> need to be revisited, in case the enhancement proposed by Durga
>> get in. This is because representing virtual thermal zones
>> built out of several sensors may need a different representation
>> in DT.
>>
>> [1] - RFC of this work:
>> http://comments.gmane.org/gmane.linux.power-management.general/35874
>>
>> Changes from RFC:
>> - Added a way to load cpufreq cooling device out of DT
>> - Added a way to bind with upper and lower limits using bind_params
>> - Added a way to specify upper and lower binding limits on DT
>> - Added DT thermal builder support to lm75 and tmp102 hwmon drivers
>> - Changed ERANGE to EDOM
>> - Added thermal constants for zone type and bind limit, so that
>>   dts file could be more readable
>>
>> Tested on panda omap4430 (3.11-rc1 with minor changes for getting cpuf=
req working)
>>
>> BR,
>>
>> Eduardo Valentin (9):
>>   cpufreq: cpufreq-cpu0: add dt node parsing for 'needs-cooling'
>>   thermal: hwmon: move hwmon support to single file
>>   thermal: thermal_core: allow binding with limits on bind_params
>>   arm: dts: flag omap4430 with needs-cooling for cpu node
>>   thermal: introduce device tree parser
>>   thermal: ti-soc-thermal: use thermal DT infrastructure
>>   arm: dts: add omap4430 thermal data
>>   hwmon: lm75: expose to thermal fw via DT nodes
>>   hwmon: tmp102: expose to thermal fw via DT nodes
>>
>>  .../devicetree/bindings/cpufreq/cpufreq-cpu0.txt   |   3 +
>>  .../devicetree/bindings/thermal/thermal.txt        | 133 ++++++
>>  Documentation/thermal/sysfs-api.txt                |   7 +
>>  arch/arm/boot/dts/omap443x.dtsi                    |  32 +-
>>  drivers/cpufreq/cpufreq-cpu0.c                     |   8 +
>>  drivers/hwmon/lm75.c                               |  29 ++
>>  drivers/hwmon/tmp102.c                             |  25 ++
>>  drivers/thermal/Kconfig                            |  22 +
>>  drivers/thermal/Makefile                           |   4 +
>>  drivers/thermal/thermal_core.c                     | 274 +-----------=

>>  drivers/thermal/thermal_dt.c                       | 458 ++++++++++++=
+++++++++
>>  drivers/thermal/thermal_hwmon.c                    | 269 ++++++++++++=

>>  drivers/thermal/thermal_hwmon.h                    |  49 +++
>>  drivers/thermal/ti-soc-thermal/ti-thermal-common.c |  46 ++-
>>  include/dt-bindings/thermal/thermal.h              |  27 ++
>>  include/linux/thermal.h                            |  13 +
>>  16 files changed, 1129 insertions(+), 270 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/thermal/thermal.=
txt
>>  create mode 100644 drivers/thermal/thermal_dt.c
>>  create mode 100644 drivers/thermal/thermal_hwmon.c
>>  create mode 100644 drivers/thermal/thermal_hwmon.h
>>  create mode 100644 include/dt-bindings/thermal/thermal.h
>>
>> --=20
>> 1.8.2.1.342.gfa7285d
>>
>>
>> _______________________________________________
>> lm-sensors mailing list
>> lm-sensors@lm-sensors.org
>> http://lists.lm-sensors.org/mailman/listinfo/lm-sensors
>>
>=20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


------enig2PKIAKWKUPUGLHIHAOKRL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlHn80EACgkQCXcVR3XQvP0U/AD/YaTy1Wieu+UNVS83/L+/GIOh
iAl9GTntj08Q35gE4gAA/A7odvUyrYolC/Ea2dc3oN3ksOXA64njo5V2xR05q1Ib
=5wJ9
-----END PGP SIGNATURE-----

------enig2PKIAKWKUPUGLHIHAOKRL--
