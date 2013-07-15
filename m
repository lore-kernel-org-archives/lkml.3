Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757865Ab3GOOal (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 10:30:41 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36921 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757702Ab3GOOaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 10:30:39 -0400
Message-ID: <51E40783.3070402@ti.com>
Date: Mon, 15 Jul 2013 10:30:27 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Wei Ni <wni@nvidia.com>, Eduardo Valentin <eduardo.valentin@ti.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "durgadoss.r@intel.com" <durgadoss.r@intel.com>,
        "amit.daniel@samsung.com" <amit.daniel@samsung.com>,
        "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 2/4] thermal: introduce device tree parser
References: <1373378414-28086-1-git-send-email-eduardo.valentin@ti.com> <1373378414-28086-3-git-send-email-eduardo.valentin@ti.com> <51DD03C8.1090207@nvidia.com> <51DD7ABC.2010009@wwwdotorg.org>
In-Reply-To: <51DD7ABC.2010009@wwwdotorg.org>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2WNXJXJORCJDOLQITRWAS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2WNXJXJORCJDOLQITRWAS
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 10-07-2013 11:16, Stephen Warren wrote:
> On 07/10/2013 12:48 AM, Wei Ni wrote:
>> On 07/09/2013 10:00 PM, Eduardo Valentin wrote:
>>> In order to be able to build thermal policies
>>> based on generic sensors, like I2C device, that
>>> can be places in different points on different boards,
>>> there is a need to have a way to feed board dependent
>>> data into the thermal framework.
>>>
>>> This patch introduces a thermal data parser for device
>>> tree. The parsed data is used to build thermal zones
>>> and thermal binding parameters. The output data
>>> can then be used to deploy thermal policies.
>>>
>>> This patch adds also documentation regarding this
>>> API and how to define define tree nodes to use
>>> this infrastructure.
>>
>> It looks good, with this infrastructure, we can add generic sensor
>> driver into the thermal fw easily.
>>
>>
>>> +
>>> +Below is an example:
>>> +thermal_zone {
>>> +            type =3D "CPU";
>>> +            mask =3D <0x03>; /* trips writability */
>>> +            passive_delay =3D <250>; /* milliseconds */
>>> +            polling_delay =3D <1000>; /* milliseconds */
>>> +            governor =3D "step_wise";
>>> +            trips {
>>> +                    alert@100000{
>>> +                            temperature =3D <100000>; /* milliCelsiu=
s */
>>> +                            hysteresis =3D <0>; /* milliCelsius */
>>> +                            type =3D <1>;
>>
>> how about to use the trip type name directly, such as named as
>> "passive-trip;", I think it's more readable. for example:
>> trip0 {
>> ....
>> passive-trip;
>> }
>> trip1 {
>> ....
>> active-trip;
>> }
>=20
> You can always use the C pre-processor in DT now to define named consta=
nts:
>=20
> include/dt-bindings/..../....h
>=20
> 	#define THERMAL_PASSIVE_TRIP 0
> 	#define THERMAL_ACTIVE_TRIP 1
>=20
> *.dts:
>=20
> 	type =3D <THERMAL_PASSIVE_TRIP>;
>=20
> Having a single 'property =3D value;' rather than n different Boolean
> property names seems better, irrespective of whether value is an intege=
r
> or string; parsing and error-checking will be simpler.

agreed here. I will amend with the above suggestions. makes the dt file
much more readable. thanks Stephen and Wei.

>=20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


------enig2WNXJXJORCJDOLQITRWAS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlHkB4MACgkQCXcVR3XQvP0+dwD/UKpccxBila2ObAZ9S7PhtsyE
WSVctmckrKtGv9zVW7gA/2J1Kb622gW8E6npS4K8rgo+W6Ujyjut2tbWGu/3cUNB
=bcmb
-----END PGP SIGNATURE-----

------enig2WNXJXJORCJDOLQITRWAS--
