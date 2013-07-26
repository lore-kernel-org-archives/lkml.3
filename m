Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759581Ab3GZT5D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 15:57:03 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:52824 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab3GZT5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 15:57:00 -0400
Message-ID: <51F2D443.6040909@ti.com>
Date: Fri, 26 Jul 2013 15:55:47 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Pawel Moll <pawel.moll@arm.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
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
Subject: Re: RFC: device thermal limits represented in device tree nodes
References: <51ED40E3.5020703@ti.com> <51EF3186.9060001@wwwdotorg.org>  <1374664745.25700.118.camel@hornet> <51EFED19.5090900@ti.com>  <1374768928.3213.31.camel@hornet> <51F15E42.1060409@ti.com> <1374773611.3213.44.camel@hornet>
In-Reply-To: <1374773611.3213.44.camel@hornet>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="phU7QJohmu1JhvNiN5A0TN0dnfm2Ogs4J"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--phU7QJohmu1JhvNiN5A0TN0dnfm2Ogs4J
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 25-07-2013 13:33, Pawel Moll wrote:
> On Thu, 2013-07-25 at 18:20 +0100, Eduardo Valentin wrote:
>>>> 	thermal_zone {
>>>> 		type =3D "CPU";
>>>
>>> So what does this exactly mean? What is so special about CPU? What ot=
her
>>> types you've got there? (Am I just lazy not looking at the numerous
>>> links you provided? ;-)
>>
>> Hehehe. OK. Type is supposed to describe what your zone is representin=
g.
>=20
> As in "a name"? So, for example "The board", "PSU"? What I meant to ask=

> was: does the string carry any meaning?
>=20
>>>> 		monitoring_device =3D <&sensor@xxxx
>>>> 				    &sensor@yyyy>;
>>>>
>>>> 		mask =3D <0x03>; /* trips writability */
>>>> 		passive_delay =3D <250>; /* milliseconds */
>>>> 		polling_delay =3D <1000>; /* milliseconds */
>>>> 		policy =3D "step_wise";
>>>
>>> The word "policy" doesn't sound to me like a "hardware feature",
>>> wouldn't you agree?
>>
>> Agreed. As I mentioned in other email, we can leave this to OS decide
>> what to use, by default, for instance.
>=20
> Cool, I believe it is the right thing to do.
>=20
>>>
>>>> 		trips {
>>>> 			alert@100000{
>>>> 				temperature =3D <100000>; /* milliCelsius
>>>> 				hysteresis =3D <2000>; /* milliCelsius */
>>>> 				type =3D <THERMAL_TRIP_PASSIVE>;
>>>> 			};
>>>> 			crit@125000{
>>>> 				temperature =3D <125000>; /* milliCelsius
>>>> 				hysteresis =3D <2000>; /* milliCelsius */
>>>> 				type =3D <THERMAL_TRIP_CRITICAL>;
>>>> 			};
>>>> 		};
>>>> 		bind_params {
>>>> 			action@0{
>>>> 				cooling_device =3D "thermal-cpufreq";
>>>
>>> Why is it a string? It seems very Linux-y... (cpufreq) Is there any
>>> particular reason not to have phandles to the fans that have any impa=
ct
>>> on the zone?=20
>>
>> Because fans are not the only way to cool your system, specially those=

>> systems that don't feature fans. Managing the speed of your CPU is one=

>> example of lowering temperature without fans. Managing the load on you=
r
>> system is another way. These are obviously, virtual concepts. And
>> because we have physical ways and logical ways to cool the zone, then =
I
>> didnt put a phandle to a device there.
>=20
> "virtual concepts"... This is where my problem lies... It's not hardwar=
e
> so it doesn't seem to belong in the tree at the first sight. Shouldn't


Yeah, in fact, this is exactly the point that creates most of the
disagreement. You may check Guenter's arguments against this proposal
(in my original RFC email, there is a link to it).

Well, if one don't want to see this as a 'virtual concept' it could say
the cooling device is the cpu itself:
		cooling_device =3D <&cpu0>;



> it focus on "physical data" instead? As in: point at devices that have
> some impact on the conditions? For example, you can say "please, do the=

> right thing to cool your environment down" to both CPU and fan, can't
> you? The "cooling driver" for the CPU would know that it has to slow
> down, while a driver for the fan would know that it has to speed up ;-)=

>=20
> What I'm trying to say is that in my opinion the tree should simply lin=
k
> the object, the sensor and the actuator. Nothing more, nothing less.

OK. I think it would be a little unfair to have only links, without
describing what this link is supposed to be or how it is supposed to be
used. In previous discussions, I have mentioned two similar examples
already existing in DT. Here are they: regulator bindings, one does not
describe only which device connects to which regulator, but also needs
to describe, voltage limits, current limits, offsets, and other
properties. And an existing 'virtual concept' would be predefined CPU
OPPs, that feed the opp layer. Those are configurations of the hardware
that define a 'virtual' concept of operating point.

So, saying we need to describe only physical connections or touchable
things would be a little unfair, IMO. Besides, thermal is still physical
:-).

>=20
> Thanks for your time!

Thanks for the input!

>=20
> Pawel
>=20
>=20
>=20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--phU7QJohmu1JhvNiN5A0TN0dnfm2Ogs4J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlHy1EYACgkQCXcVR3XQvP0BJAEAoLGkJ+CjY64raPd3tsmUf5up
LJlr/JkqJMW2zS4sPOIA/2DJKpIKzy5zB0HAg2kzUGZEw/mXFJRplvONa2tKa8Ak
=v+sa
-----END PGP SIGNATURE-----

--phU7QJohmu1JhvNiN5A0TN0dnfm2Ogs4J--
