Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422Ab3KYPgF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 10:36:05 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:33342 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753580Ab3KYPgC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 10:36:02 -0500
Message-ID: <52936E08.9050404@ti.com>
Date: Mon, 25 Nov 2013 11:34:32 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Tomasz Figa <t.figa@samsung.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "wni@nvidia.com" <wni@nvidia.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "durgadoss.r@intel.com" <durgadoss.r@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv9 02/20] thermal: introduce device tree parser
References: <1384285582-16933-1-git-send-email-eduardo.valentin@ti.com> <25668725.sMcoUCgCKk@flatron> <52861F46.8020900@ti.com> <1574695.YAEZXuUskK@amdc1227> <20131125151421.GF32081@e106331-lin.cambridge.arm.com>
In-Reply-To: <20131125151421.GF32081@e106331-lin.cambridge.arm.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="E4bmB7knd5kf53k5lgwmsSkDrBigLufi0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--E4bmB7knd5kf53k5lgwmsSkDrBigLufi0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 25-11-2013 11:14, Mark Rutland wrote:
> [...]
>=20
>>>>>>> +* Trip points
>>>>>>> +
>>>>>>> +The trip node is a node to describe a point in the temperature d=
omain
>>>>>>> +in which the system takes an action. This node describes just th=
e point,
>>>>>>> +not the action.
>>>>>>> +
>>>>>>> +Required properties:
>>>>>>> +- temperature:          An integer indicating the trip temperatu=
re level,
>>>>>>> +  Type: signed          in millicelsius.
>>>>>>> +  Size: one cell
>>>>>>> +
>>>>>>> +- hysteresis:           A low hysteresis value on temperature pr=
operty (above).
>>>>>>> +  Type: unsigned        This is a relative value, in millicelsiu=
s.
>>>>>>> +  Size: one cell
>>>>>>
>>>>>> What about replacing temperature and hysteresis with a single temp=
erature
>>>>>> property that can be either one cell for 0 hysteresis or two cells=
 to
>>>>>> specify lower and upper range of temperatures?
>>>>>
>>>>> What is the problem with using two properties? I think we loose
>>>>> representation by gluing two properties into one just because one c=
ell.
>>>>
>>>> Ranges is the representation widely used in other bindings. In addit=
ion
>>>
>>> Well that sentence is arguable. It is not like all properties in DT a=
re
>>> standardized as ranges, is it?
>>
>> No, they are not, but property range is a common concept of representi=
ng
>> range of some values.
>>
>> Anyway, I won't insist on this, as it's just a minor detail. However I=
'd
>> like to see comments from more people on this.
>=20
> I'm happy with having these as separate properties.
>=20
> [...]
>=20
>>>>>>> +
>>>>>>> +- type:                 a string containing the trip type. Suppo=
rted values are:
>>>>>>> +        "active":       A trip point to enable active cooling
>>>>>>> +        "passive":      A trip point to enable passive cooling
>>>>>>
>>>>>> The two above seem to be implying action, as opposed to the genera=
l
>>>>>> comment about trip points.
>>>>>
>>>>> They do not imply action, they specify type of trip.
>>>>
>>>> For me "A trip point to enable active cooling" means that when this =
trip
>>>> point is crossed, active cooling must be enabled. What is it if not
>>>> implying action?
>>>
>>> But within a board there could be more than one active cooling action=
s
>>> that could be done, it is not a 1 to 1 relation. Same thing applies t=
o
>>> passive cooling. The binding does not imply a specific action. Just t=
he
>>> trip type.
>>
>> I'd prefer the "active" and "passive" states to be renamed an their
>> descriptions rephrased. In general, the idea of having just four trip
>> point types seems like bound to a single specific hardware platform.
>>
>> That's a wild guess, but maybe having an unsigned integer to represent=

>> trip point "attention level" would be a better idea?
>=20
> The set of names can be extended in future, and we can choose to have a=
n
> attention-level property in future, and map the existing types to them.=

> If we don't have something fundamantally better, I think this should be=

> OK for now.
>=20
>>
>>>
>>>>
>>>>>
>>>>>>
>>>>>>> +        "hot":          A trip point to notify emergency
>>>>>>> +        "critical":     Hardware not reliable.
>>>>>>> +  Type: string
>>>>>>> +
>>>>>> [snip]
>>>>>>> +* Examples
>>>>>>> +
>>>>>>> +Below are several examples on how to use thermal data descriptor=
s
>>>>>>> +using device tree bindings:
>>>>>>> +
>>>>>>> +(a) - CPU thermal zone
>>>>>>> +
>>>>>>> +The CPU thermal zone example below describes how to setup one th=
ermal zone
>>>>>>> +using one single sensor as temperature source and many cooling d=
evices and
>>>>>>> +power dissipation control sources.
>>>>>>> +
>>>>>>> +#include <dt-bindings/thermal/thermal.h>
>>>>>>> +
>>>>>>> +cpus {
>>>>>>> +        /*
>>>>>>> +         * Here is an example of describing a cooling device for=
 a DVFS
>>>>>>> +         * capable CPU. The CPU node describes its four OPPs.
>>>>>>> +         * The cooling states possible are 0..3, and they are
>>>>>>> +         * used as OPP indexes. The minimum cooling state is 0, =
which means
>>>>>>> +         * all four OPPs can be available to the system. The max=
imum
>>>>>>> +         * cooling state is 3, which means only the lowest OPPs =
(198MHz@0.85V)
>>>>>>> +         * can be available in the system.
>>>>>>> +         */
>>>>>>> +        cpu0: cpu@0 {
>>>>>>> +                ...
>>>>>>> +                operating-points =3D <
>>>>>>> +                        /* kHz    uV */
>>>>>>> +                        970000  1200000
>>>>>>> +                        792000  1100000
>>>>>>> +                        396000  950000
>>>>>>> +                        198000  850000
>>>>>>> +                >;
>>>>>>> +                cooling-min-state =3D <0>;
>>>>>>> +                cooling-max-state =3D <3>;
>>>>>>> +                #cooling-cells =3D <2>; /* min followed by max *=
/
>>>>>>
>>>>>> I believe you don't need the min- and max-state properties here th=
en. Your
>>>>>> thermal core can simply query the cpufreq driver (which would be a=
 cooling
>>>>>> device here) about the range of states it supports
>>>>>
>>>>> This binding is not supposed to be aware of cpufreq, which is Linux=

>>>>> specific implementation.
>>>>
>>>> I didn't say anything about making the binding aware of cpufreq, but=

>>>> instead about getting rid of redundancy of data, that can be provide=
d
>>>> by respective drivers anyway.
>>>
>>> There are cases in which cooling devices don't need to use all states=

>>> for cooling, because either lower states does not provide cooling
>>> effectiveness or higher states must be avoided at all. So, allowing
>>> drivers to report this thermal info is possible, but questionable
>>> design, as you would be spreading the thermal info. Besides, for the
>>> example I gave, the driver would need to know board specifics, as the=

>>> range of states would vary anyway across board.
>>
>> One thing is the allowed range of cooling states supported by the
>> cooling device and another is the range of states that are usable on
>> given board. The former is a property of the cooling device that
>> in most cases is implied by its compatible string, so to eliminate the=

>> bad data redundancy, you should not make the user respecify that. The
>> latter you have as a part of your cooling device specifier tuple.
>>
>> As an example of this, see PWM, GPIO or IRQ bindings. You don't have
>> {pwm-channel,pwm-duty,interrupt,gpio}-{min,max} properties, because th=
is
>> is not needed by respective PWM, GPIO or IRQ drivers, as they already
>> know these parameters.
>=20
> This is arguable. The {min,max} levels associated with a cooling state
> is essentially a recommendation of a sane set of values you might want
> to use the cooling device with.
>=20
> It could work using only the cooling device's information, but it might=

> not be all that useful. The range might not represent a linear scale,
> and there might be secondary effects to consider (e.g. noise) that woul=
d
> affect the decision and would likely need to be considered by the
> particular drivers.
>=20
> The key question is where do we make the trade off? How much platform
> knowledge do we want each driver to have to handle, and how much are we=

> happy to place in DT?
>=20
> It is possible to use the information from particular devices and ignor=
e
> the {min,max} cooling state properties in future if that turns out to b=
e
> better. I think that would be reasonable for now.

I agree that we surely can rip off unused properties if they turn out to
be not helping at all. On the min/max specific case, I do have board
that investigation (by experimentation on real board and simulation)
showed that, for instance, allowing maximum power delta can cause burst
on temperature, and those bursts are hard to detect on higher levels of
temperature domain. Well, it turns out that this is essentially how
temperature behaves.  Obviously, behavior on different boards is also
different, or at least produce different bursts. It would require
drivers to have board knowledge in order to properly report this.

As it has been already discussed during the development of this work,
one can also develop a PID controller to minimize the board dependency.
However, the board dependency can only be minimized, not avoided, as not
all board have needed sensors, say power, current sensor, or not enough
temperature sensors, and power estimation based only on cpu load is
known to not be strongly correlated to overall board power dissipation.

The proposal of using min max on trip point is not coming from nowhere.
>=20
> Thanks,
> Mark.
>=20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--E4bmB7knd5kf53k5lgwmsSkDrBigLufi0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlKTbhAACgkQCXcVR3XQvP02TgD/c9hjPqWFRZu1xMChZbOADx95
FGVmgT5d8RhqC4GC3hoA/1jfSFjZVM8gFSglk3uYgr6ps/h0rbQiDwzbvABkzue4
=3z0J
-----END PGP SIGNATURE-----

--E4bmB7knd5kf53k5lgwmsSkDrBigLufi0--
