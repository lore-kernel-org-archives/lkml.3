Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117Ab3GOLyr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 07:54:47 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40507 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755710Ab3GOLyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 07:54:45 -0400
Message-ID: <51E3E2FA.7000708@ti.com>
Date: Mon, 15 Jul 2013 07:54:34 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Wei Ni <wni@nvidia.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "durgadoss.r@intel.com" <durgadoss.r@intel.com>,
        "amit.daniel@samsung.com" <amit.daniel@samsung.com>,
        "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 2/4] thermal: introduce device tree parser
References: <1373378414-28086-1-git-send-email-eduardo.valentin@ti.com> <1373378414-28086-3-git-send-email-eduardo.valentin@ti.com> <51DD03C8.1090207@nvidia.com>
In-Reply-To: <51DD03C8.1090207@nvidia.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2HUAKKXBGLTTIOKXNSSSN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2HUAKKXBGLTTIOKXNSSSN
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 10-07-2013 02:48, Wei Ni wrote:
> On 07/09/2013 10:00 PM, Eduardo Valentin wrote:
>> In order to be able to build thermal policies
>> based on generic sensors, like I2C device, that
>> can be places in different points on different boards,
>> there is a need to have a way to feed board dependent
>> data into the thermal framework.
>>
>> This patch introduces a thermal data parser for device
>> tree. The parsed data is used to build thermal zones
>> and thermal binding parameters. The output data
>> can then be used to deploy thermal policies.
>>
>> This patch adds also documentation regarding this
>> API and how to define define tree nodes to use
>> this infrastructure.
>=20
> It looks good, with this infrastructure, we can add generic sensor
> driver into the thermal fw easily.
>=20
>=20
>> +
>> +Below is an example:
>> +thermal_zone {
>> +            type =3D "CPU";
>> +            mask =3D <0x03>; /* trips writability */
>> +            passive_delay =3D <250>; /* milliseconds */
>> +            polling_delay =3D <1000>; /* milliseconds */
>> +            governor =3D "step_wise";
>> +            trips {
>> +                    alert@100000{
>> +                            temperature =3D <100000>; /* milliCelsius=
 */
>> +                            hysteresis =3D <0>; /* milliCelsius */
>> +                            type =3D <1>;
>=20
> how about to use the trip type name directly, such as named as
> "passive-trip;", I think it's more readable. for example:
> trip0 {
> ....
> passive-trip;
> }
> trip1 {
> ....
> active-trip;
> }
>=20
>> +                    };
>> +                    crit@125000{
>> +                            temperature =3D <125000>; /* milliCelsius=
 */
>> +                            hysteresis =3D <0>; /* milliCelsius */
>> +                            type =3D <3>;
>> +                    };
>> +            };
>> +            bind_params {
>> +                    action@0{
>> +                            cooling_device =3D "thermal-cpufreq";
>> +                            weight =3D <100>; /* percentage */
>> +                            mask =3D <0x01>;
>> +                    };
>> +            };
>> +};
>=20
> as we know, thermal_zone_bind_cooling_device() will set the upper/lower=

> in the thermal_instance. In the default .bind function, it just set to
> THERMAL_NO_LIMIT, but for some platform, it need to set these
> upper/lower values for different cooling device and trips, how to pass
> these values in DT? how about to set:
> action@0 {
> ...
> mask =3D <0x03>; //or you can remove this property;

Well, this has been added accordingly to current API needs.

> trip0 =3D <&alert 1 2>; //1 is lower value, 2 is upper value;
> trip1 =3D <&crit 3 4>;

I suppose the first item in you 3-tuple is the trip point.

> }

Yeah, I also noticed that I was missing the upper and lower limits. But
unfortunately this is a limitation on the thermal FW API too!

If one passes a bind params, the structure which represents platform
info, then it won't be able to pass the upper and lower limits. But by
passing a .bind callback, then you have the opportunity to match it
using these two values.

I believe we would need to change the data structures and the API to
support upper and lower limits via platform representation. We could
simply use the .bind callback of the dt thermal zone, but I believe that
would abusing the API, assuming that .match is for platform binding.
Durga, what do you think?


>=20
>=20
> Thanks.
> Wei.
>=20
>=20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


------enig2HUAKKXBGLTTIOKXNSSSN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlHj4voACgkQCXcVR3XQvP0B7AD/WCol7mT0HhfX9DRhkRiAYNV/
2S687IGg+/Ea3blIcyQBAJFUQEvV4ijF+1MNAV3PCsHood0u/qR2Lea4uWOgM3mC
=qmKS
-----END PGP SIGNATURE-----

------enig2HUAKKXBGLTTIOKXNSSSN--
