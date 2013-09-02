Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932269Ab3IBQ34 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 12:29:56 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:49682 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756270Ab3IBQ3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 12:29:51 -0400
Message-ID: <5224BCB2.9090305@ti.com>
Date: Mon, 2 Sep 2013 12:28:34 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Eduardo Valentin <eduardo.valentin@ti.com>
CC: Mark Rutland <mark.rutland@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "wni@nvidia.com" <wni@nvidia.com>,
        "durgadoss.r@intel.com" <durgadoss.r@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 02/14] drivers: thermal: introduce device tree parser
References: <1377299755-5134-1-git-send-email-eduardo.valentin@ti.com> <1377299755-5134-3-git-send-email-eduardo.valentin@ti.com> <20130827102205.GC19893@e106331-lin.cambridge.arm.com> <521CAD48.2030306@ti.com> <20130827162309.GR19893@e106331-lin.cambridge.arm.com> <521CED34.2090008@ti.com> <521FD70F.7080104@ti.com>
In-Reply-To: <521FD70F.7080104@ti.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="KRWvKoulJrSb08iFN5SRUQsiVhVPM4oON"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--KRWvKoulJrSb08iFN5SRUQsiVhVPM4oON
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 29-08-2013 19:19, Eduardo Valentin wrote:
> Mark, Pawel and Stephen,
>=20
>=20
> On 27-08-2013 14:17, Eduardo Valentin wrote:
>> On 27-08-2013 12:23, Mark Rutland wrote:
>>> On Tue, Aug 27, 2013 at 02:44:40PM +0100, Eduardo Valentin wrote:
>>>> Hello Mark,
>=20
> <cut>
>=20
> I believe now we need to align on thermal bindings, before I propose
> next version of this series. So, following the discussions on this
> thread, I believe a typical CPU thermal zone would look like the follow=
ing:
> + #include <dt-bindings/thermal/thermal.h>
> +
> + cpu_thermal: cpu_thermal {
> +         passive-delay =3D <250>; /* milliseconds */
> +         polling-delay =3D <1000>; /* milliseconds */
> +                 /*
> +                  * sensor       ID
> +                  */
> +         sensors =3D <&bandgap0     0>;
> +                         /*
> +                          * cooling
> +                          * device       Usage   Trip            lower=

> bound             upper bound
> +                          */
> +         cooling-devices =3D <&cpu0        100     &cpu-alert
> THERMAL_NO_LIMITS        THERMAL_NO_LIMITS>;
> +         trips {
> +                 cpu-alert: cpu-alert {
> +                         temperature =3D <100000>; /* milliCelsius */
> +                         hysteresis =3D <2000>; /* milliCelsius */
> +                         type =3D <THERMAL_TRIP_PASSIVE>;
> +                 };
> +                 cpu-crit: cpu-crit {
> +                         temperature =3D <125000>; /* milliCelsius */
> +                         hysteresis =3D <2000>; /* milliCelsius */
> +                         type =3D <THERMAL_TRIP_CRITICAL>;
> +                 };
> +         };
> + };
>=20
> *Note: THERMAL_NO_LIMIT means, it will be using the cooling device
> minimum and maximum limits.
>=20
> Couple of comments.
> 1. I am keeping the pooling intervals. A possible alternative way to
> describe that would be specifying the maximum dT/dt. Essentially becaus=
e
> I am still convinced that this is part of hw specs.
>=20
> 2. The above follows your suggestion to use consumer pointing to
> producers. Although, I still need to figure out how this could be
> implemented for Linux. But I think that is another story, at least for
> now. We need to first align on the DT binding itself.
>=20
> 3. The link from cooling device specification to trip points, from my
> perspective, should be enough, and thus we shall not need the thermal
> cells and size for trip points, as you proposed. Let me know what you t=
hink.
>=20
> Below is another example, on a more complex scenario, board specific
> case (hypothetical, just for exemplification):
>=20
> + #include <dt-bindings/thermal/thermal.h>
> +
> + board_thermal: board_thermal {
> +         passive-delay =3D <1000>; /* milliseconds */
> +         polling-delay =3D <2500>; /* milliseconds */
> +                 /*
> +                  * sensor       ID
> +                  */
> +         sensors =3D <&adc-dummy     0>,
> +		    <&adc-dummy     1>,
> +		    <&adc-dymmy     2>;
> +                         /*
> +                          * cooling
> +                          * device       Usage   Trip		lower	upper
> +                          */
> +         cooling-devices =3D <&cpu0       75     &cpu-trip	0      2>,
> +			    <&gpu0       40     &gpu-trip	0      2>;
> +			    <&lcd0       25     &lcd-trip	5      10>;
> +         trips {
> +                 cpu-trip: cpu-trip {
> +                         temperature =3D <60000>; /* milliCelsius */
> +                         hysteresis =3D <2000>; /* milliCelsius */
> +                         type =3D <THERMAL_TRIP_PASSIVE>;
> +                 };
> +                 gpu-trip: gpu-trip {
> +                         temperature =3D <55000>; /* milliCelsius */
> +                         hysteresis =3D <2000>; /* milliCelsius */
> +                         type =3D <THERMAL_TRIP_PASSIVE>;
> +                 }
> +                 lcd-trip: lcp-trip {
> +                         temperature =3D <53000>; /* milliCelsius */
> +                         hysteresis =3D <2000>; /* milliCelsius */
> +                         type =3D <THERMAL_TRIP_PASSIVE>;
> +                 };
> +                 crit-trip: crit-trip {
> +                         temperature =3D <68000>; /* milliCelsius */
> +                         hysteresis =3D <2000>; /* milliCelsius */
> +                         type =3D <THERMAL_TRIP_CRITICAL>;
> +                 };
> +         };
> + };
>=20
> Now writing the above example, one might want to have a way to say the
> sensor correlation equation.
>=20
> Another example:
> + #include <dt-bindings/thermal/thermal.h>
> +
> + dsp_thermal: dsp_thermal {
> +         passive-delay =3D <250>; /* milliseconds */
> +         polling-delay =3D <1000>; /* milliseconds */
> +                 /*
> +                  * sensor       ID
> +                  */
> +         sensors =3D <&bandgap0     1>;
> +                         /*
> +                          * cooling
> +                          * device       Usage   Trip            lower=

> bound             upper bound
> +                          */
> +         cooling-devices =3D <&dsp0        100     &dsp-alert
> THERMAL_NO_LIMIT        THERMAL_NO_LIMIT>;
> +         trips {
> +                 dsp-alert: dsp-alert {
> +                         temperature =3D <100000>; /* milliCelsius */
> +                         hysteresis =3D <2000>; /* milliCelsius */
> +                         type =3D <THERMAL_TRIP_PASSIVE>;
> +                 };
> +                 dsp-crit: cdsp-crit {
> +                         temperature =3D <125000>; /* milliCelsius */
> +                         hysteresis =3D <2000>; /* milliCelsius */
> +                         type =3D <THERMAL_TRIP_CRITICAL>;
> +                 };
> +         };
> + };
> +
> + gpu_thermal: gpu_thermal {
> +         passive-delay =3D <500>; /* milliseconds */
> +         polling-delay =3D <1000>; /* milliseconds */
> +                 /*
> +                  * sensor       ID
> +                  */
> +         sensors =3D <&bandgap0     2>;
> +                         /*
> +                          * cooling
> +                          * device       Usage   Trip            lower=

> bound             upper bound
> +                          */
> +         cooling-devices =3D <&gpu0        100     &gpu-alert
> THERMAL_NO_LIMIT        THERMAL_NO_LIMIT>;
> +         trips {
> +                 gpu-alert: gpu-alert {
> +                         temperature =3D <100000>; /* milliCelsius */
> +                         hysteresis =3D <2000>; /* milliCelsius */
> +                         type =3D <THERMAL_TRIP_PASSIVE>;
> +                 };
> +                 gpu-crit: gpu-crit {
> +                         temperature =3D <125000>; /* milliCelsius */
> +                         hysteresis =3D <2000>; /* milliCelsius */
> +                         type =3D <THERMAL_TRIP_CRITICAL>;
> +                 };
> +         };
> + };
>=20
>=20
> Wei, I think the above would cover for the IPs with multiple internal
> sensors cases you were looking for, right?
>=20
> Durga, please also check if I am missing something to cover for your
> plans to, in case you will be using DT to describe your HW.
>=20
> Anyways, Mark and Pawel, let me know if I missed something from our
> discussion. I believe the above bindings would look more like regular
> standard DT bindings. And also they should be now slim enough, without
> Linux implementation details and also without policies.

Any objections on the above binding proposal?

>=20
>>
>>
>=20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--KRWvKoulJrSb08iFN5SRUQsiVhVPM4oON
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlIkvLgACgkQCXcVR3XQvP2K2wEA74jalbsT1C8NPiyRQLZxxAby
H5DyhozwZCrWqsQQ9h4BAOu2/Opag6a7Try10r1ILmiyzsnpp6WrQi/ZQmDaihby
=Ou0V
-----END PGP SIGNATURE-----

--KRWvKoulJrSb08iFN5SRUQsiVhVPM4oON--
