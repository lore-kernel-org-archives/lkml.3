Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799Ab3GYRV2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 13:21:28 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:34481 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756678Ab3GYRVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 13:21:23 -0400
Message-ID: <51F15E42.1060409@ti.com>
Date: Thu, 25 Jul 2013 13:20:02 -0400
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
References: <51ED40E3.5020703@ti.com> <51EF3186.9060001@wwwdotorg.org>  <1374664745.25700.118.camel@hornet> <51EFED19.5090900@ti.com> <1374768928.3213.31.camel@hornet>
In-Reply-To: <1374768928.3213.31.camel@hornet>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="mC8axs4jv44dG8dWcxbi73EvunvgOrS82"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--mC8axs4jv44dG8dWcxbi73EvunvgOrS82
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 25-07-2013 12:15, Pawel Moll wrote:
> On Wed, 2013-07-24 at 16:04 +0100, Eduardo Valentin wrote:
>>> 1. As you have pointed out, the thermal limits are related to the
>>> *device being monitored*, not the sensor itself.
>>>
>> Yeah, thinking of it now, this original proposal, it lacks a stronger
>> relationship mapping between monitored and monitoring devices. But it
>> does have it..
>>
>>> 2. Therefore the tree should express relation between those two; a
>>> sensor mode should be connected (via phandle most likely) to the devi=
ce
>>
>> .. this is done, more or less, by means of the 'type' property (see
>> original RFC binding).
>=20
> I'm not sure what do you mean (regarding "type"), but I think I got wha=
t
> I wanted with the "monitoring_device" phandles (shouldn't it be
> "_device*s*" then? ;-).

yes. it is supposed to be devices.

>=20
>> For example:
>> cpu0: cpu@0 {
>> 	/* ... cpu needed bindings  */
>>
>> 	thermal_zone {
>> 		type =3D "CPU";
>=20
> So what does this exactly mean? What is so special about CPU? What othe=
r
> types you've got there? (Am I just lazy not looking at the numerous
> links you provided? ;-)

Hehehe. OK. Type is supposed to describe what your zone is representing.

>=20
>> 		monitoring_device =3D <&sensor@xxxx
>> 				    &sensor@yyyy>;
>>
>> 		mask =3D <0x03>; /* trips writability */
>> 		passive_delay =3D <250>; /* milliseconds */
>> 		polling_delay =3D <1000>; /* milliseconds */
>> 		policy =3D "step_wise";
>=20
> The word "policy" doesn't sound to me like a "hardware feature",
> wouldn't you agree?

Agreed. As I mentioned in other email, we can leave this to OS decide
what to use, by default, for instance.

>=20
>> 		trips {
>> 			alert@100000{
>> 				temperature =3D <100000>; /* milliCelsius
>> 				hysteresis =3D <2000>; /* milliCelsius */
>> 				type =3D <THERMAL_TRIP_PASSIVE>;
>> 			};
>> 			crit@125000{
>> 				temperature =3D <125000>; /* milliCelsius
>> 				hysteresis =3D <2000>; /* milliCelsius */
>> 				type =3D <THERMAL_TRIP_CRITICAL>;
>> 			};
>> 		};
>> 		bind_params {
>> 			action@0{
>>				cooling_device =3D "thermal-cpufreq";
>=20
> Why is it a string? It seems very Linux-y... (cpufreq) Is there any
> particular reason not to have phandles to the fans that have any impact=

> on the zone?
>=20

Because fans are not the only way to cool your system, specially those
systems that don't feature fans. Managing the speed of your CPU is one
example of lowering temperature without fans. Managing the load on your
system is another way. These are obviously, virtual concepts. And
because we have physical ways and logical ways to cool the zone, then I
didnt put a phandle to a device there.


>> 				weight =3D <100>; /* percentage */
>=20
> Does this mean: how "successful" will be the particular fan?
>=20
>> Another way, as I mentioned in the original RFC, an option would be to=

>> have the thermal_zone node not embedded in any device node. But them, =
we
>> would need to firmly link it to other device nodes, to describe what i=
s
>> monitored and what is used for monitoring.=20
>=20
> You mean the zone nodes would live at the top level of the tree? To my
> mind the root represents the device (the board, whatever you call it),
> which, I guess, may be what you want, if the zone "covers" the whole
> device? (as in: one fan and one sensor somewhere in the box and the onl=
y
> thing you may do is to check the ambient temperature and start the fan
> if it's to high)

Yes, for cases that we want to map zones at board level, they could be
not embedded to a specific device node.

>=20
>> With the above I believe we could have dts(i) files describing only
>> thermal, for instance.
>=20
> You can include a dtsi inside the device node, no problem with that:
>=20
> /dts-v1/;
>        =20
> / {    =20
>         smb {                  =20
>                 compatible =3D "simple-bus";
>=20
>                 /include/ "vexpress-v2m-rs1.dtsi"
>         };     =20
> };    =20

OK. got your point. What I was trying to highlight is that we could have
zones not inside device nodes, then we could write them in a thermal
dtsi. And in that case, you probably dont want to include the complete
file inside a device node.

>=20
> Pawel
>=20
>=20
>=20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--mC8axs4jv44dG8dWcxbi73EvunvgOrS82
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlHxXkIACgkQCXcVR3XQvP0HIAEAnZz4pbdTo7/TBBwbdMJdzxqN
eBAh76A1DJ/29rztPM8BAJkxoPcRzJIpe5v35NagL7m91UhBDf12Uy10oHCArq89
=RBKw
-----END PGP SIGNATURE-----

--mC8axs4jv44dG8dWcxbi73EvunvgOrS82--
