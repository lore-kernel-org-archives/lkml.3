Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500Ab3HGUT4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 16:19:56 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:45670 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756928Ab3HGUTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 16:19:54 -0400
Message-ID: <5202AB95.9020605@ti.com>
Date: Wed, 7 Aug 2013 16:18:29 -0400
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
References: <51ED40E3.5020703@ti.com> <51EF3186.9060001@wwwdotorg.org>  <1374664745.25700.118.camel@hornet> <51EFED19.5090900@ti.com>  <1374768928.3213.31.camel@hornet> <51F15E42.1060409@ti.com>  <1374773611.3213.44.camel@hornet> <51F2D443.6040909@ti.com> <1375787649.12043.34.camel@hornet>
In-Reply-To: <1375787649.12043.34.camel@hornet>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="ClVB4s9278W43UEO0FgXackgW3GbsX4gB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ClVB4s9278W43UEO0FgXackgW3GbsX4gB
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Pawel, all,

On 06-08-2013 07:14, Pawel Moll wrote:
> Apologies about the delay, I was "otherwise engaged" for a week...
>=20

I do also excuse for my delay, as I was also "engaged" for a week or so.

> I hope you haven't lost all motivation to work on this subject, as it's=

> really worth the while!

Not really! quite the opposite. Although I was looking at some other
stuff, I got this series also tested on different boards and wrote down
a couple of improvements I will be working in the coming days. Indeed,
it is worth moving forward with this work.

>=20
> On Fri, 2013-07-26 at 20:55 +0100, Eduardo Valentin wrote:
>> On 25-07-2013 13:33, Pawel Moll wrote:
>>> On Thu, 2013-07-25 at 18:20 +0100, Eduardo Valentin wrote:
>>>>>> 	thermal_zone {
>>>>>> 		type =3D "CPU";
>>>>>
>>>>> So what does this exactly mean? What is so special about CPU? What =
other
>>>>> types you've got there? (Am I just lazy not looking at the numerous=

>>>>> links you provided? ;-)
>>>>
>>>> Hehehe. OK. Type is supposed to describe what your zone is represent=
ing.
>>>
>>> As in "a name"? So, for example "The board", "PSU"? What I meant to a=
sk
>>> was: does the string carry any meaning?
>=20
> You haven't commended on this...

The string is supposed to carry meaning, yes. Couple of common used:
CPU, GPU, PCB, LCD

>=20
>>>>>> 		trips {
>>>>>> 			alert@100000{
>>>>>> 				temperature =3D <100000>; /* milliCelsius
>>>>>> 				hysteresis =3D <2000>; /* milliCelsius */
>>>>>> 				type =3D <THERMAL_TRIP_PASSIVE>;
>>>>>> 			};
>>>>>> 			crit@125000{
>>>>>> 				temperature =3D <125000>; /* milliCelsius
>>>>>> 				hysteresis =3D <2000>; /* milliCelsius */
>>>>>> 				type =3D <THERMAL_TRIP_CRITICAL>;
>>>>>> 			};
>>>>>> 		};
>>>>>> 		bind_params {
>>>>>> 			action@0{
>>>>>> 				cooling_device =3D "thermal-cpufreq";
>>>>>
>>>>> Why is it a string? It seems very Linux-y... (cpufreq) Is there any=

>>>>> particular reason not to have phandles to the fans that have any im=
pact
>>>>> on the zone?=20
>>>>
>>>> Because fans are not the only way to cool your system, specially tho=
se
>>>> systems that don't feature fans. Managing the speed of your CPU is o=
ne
>>>> example of lowering temperature without fans. Managing the load on y=
our
>>>> system is another way. These are obviously, virtual concepts. And
>>>> because we have physical ways and logical ways to cool the zone, the=
n I
>>>> didnt put a phandle to a device there.
>>>
>>> "virtual concepts"... This is where my problem lies... It's not hardw=
are
>>> so it doesn't seem to belong in the tree at the first sight. Shouldn'=
t
>>
>> Yeah, in fact, this is exactly the point that creates most of the
>> disagreement. You may check Guenter's arguments against this proposal
>> (in my original RFC email, there is a link to it).
>>
>> Well, if one don't want to see this as a 'virtual concept' it could sa=
y
>> the cooling device is the cpu itself:
>> 		cooling_device =3D <&cpu0>;
>=20
> Would this create any particular problem at the driver/framework side?

In this case, I believe CPUfreq driver must be thermal aware in this
case. And we need to cook a way to, whenever there is such link, the
cpufreq driver instantiates the cooling mechanism. But I need to think a
little bit more on this, will come back on this point soon.

>=20
>>> it focus on "physical data" instead? As in: point at devices that hav=
e
>>> some impact on the conditions? For example, you can say "please, do t=
he
>>> right thing to cool your environment down" to both CPU and fan, can't=

>>> you? The "cooling driver" for the CPU would know that it has to slow
>>> down, while a driver for the fan would know that it has to speed up ;=
-)
>>>
>>> What I'm trying to say is that in my opinion the tree should simply l=
ink
>>> the object, the sensor and the actuator. Nothing more, nothing less.
>>
>> OK. I think it would be a little unfair to have only links, without
>> describing what this link is supposed to be or how it is supposed to b=
e
>> used. In previous discussions, I have mentioned two similar examples
>> already existing in DT. Here are they: regulator bindings, one does no=
t
>> describe only which device connects to which regulator, but also needs=

>> to describe, voltage limits, current limits, offsets, and other
>> properties. And an existing 'virtual concept' would be predefined CPU
>> OPPs, that feed the opp layer. Those are configurations of the hardwar=
e
>> that define a 'virtual' concept of operating point.
>>
>> So, saying we need to describe only physical connections or touchable
>> things would be a little unfair, IMO. Besides, thermal is still physic=
al
>> :-).
>=20
> Believe me, I'm trying to be as fair as possible :-) and I see a lot of=

> value in describing the thermal properties of the platforms in the tree=
=2E
> It's just that we really want to focus on describing the hardware, not
> policies. And as you have already spent so much time on the matter, you=

> are in the best position to find the best set of *physical* properties
> that would allow to make the right decision in the code. Could you,
> please, try to make one step back and have another look at the problem?=

> What input data (as in: numbers :-) would you need to get what you want=
?
> Are those numbers characteristic to the specific device (they probably
> should live in the driver than) or to the board/platform (tree without =
a
> doubt).

Ok. My point was just that linking objects without telling when (in
temperature domain) to start using this link, may be incomplete, because
trip points are really HW dependent, because your power dissipation
profile changes from HW design to HW design. In other words, one can
say, "use device fan to cool the GPU", but depending on your GPU, you
may start using your fan when the sensor is 100C, 85C, 110C (just
picking numbers), it is really HW dependent. Besides, the same IP may be
used immersed in different ambient condition, which may cause variance
on its leakage level, and thus changes its thermal dissipation profile,
resulting in different trip points. Thus, mapping all this HW
characteristics inside specific drivers does not sound the right path to
me. That is why I believe pointing which trips to use is part of HW
description.

I must agree that, saying which governor  to use, then again, is pure
policy definition though.

I will go through our discussion, consider the points risen and repost
the series as soon as possible. I will not let this one fall into the
cracks, no worries.

Thanks for your inputs, BTW.

>=20
> Thanks!
>=20
> Pawel
>=20
>=20
>=20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--ClVB4s9278W43UEO0FgXackgW3GbsX4gB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlICq5kACgkQCXcVR3XQvP1vYAD/b9nbeIBWN37wBEq5LBCJLVr9
wunN52E76+5Vm+mXgYoA/3ubwv1vwoWrcsqeSnz0bpxXa9b6Apbvw6F85658cBzn
=xNWr
-----END PGP SIGNATURE-----

--ClVB4s9278W43UEO0FgXackgW3GbsX4gB--
