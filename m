Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721Ab3IRVI5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 17:08:57 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:33216 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776Ab3IRVI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 17:08:56 -0400
Message-ID: <523A15FA.3020905@ti.com>
Date: Wed, 18 Sep 2013 17:07:06 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>, <swarren@wwwdotorg.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ian.campbell@citrix.com>, <rob.herring@calxeda.com>,
        <linux@roeck-us.net>, <rui.zhang@intel.com>, <wni@nvidia.com>,
        <grant.likely@linaro.org>, <durgadoss.r@intel.com>,
        <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>
Subject: Re: [PATCHv4 02/16] drivers: thermal: introduce device tree parser
References: <1379530923-29268-1-git-send-email-eduardo.valentin@ti.com>  <1379536310-30000-1-git-send-email-eduardo.valentin@ti.com>  <1379537090.1787.67.camel@joe-AO722> <523A129C.3060606@ti.com> <1379538054.1787.71.camel@joe-AO722>
In-Reply-To: <1379538054.1787.71.camel@joe-AO722>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="ogWmvRmlNaBqQ02FNdr287QusvviGwfuJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ogWmvRmlNaBqQ02FNdr287QusvviGwfuJ
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 18-09-2013 17:00, Joe Perches wrote:
> On Wed, 2013-09-18 at 16:52 -0400, Eduardo Valentin wrote:
>> On 18-09-2013 16:44, Joe Perches wrote:
>>> On Wed, 2013-09-18 at 16:31 -0400, Eduardo Valentin wrote:
>>>
>>>> +/**
>>>> + * of_parse_thermal_zones - parse device tree thermal data
>>>> + *
>>>> + * Initialization function that can be called by machine initializa=
tion
>>>> + * code to parse thermal data and populate the thermal framework
>>>> + * with hardware thermal zones info. This function only parses ther=
mal zones.
>>>> + * Cooling devices and sensor devices nodes are supposed to be pars=
ed
>>>> + * by their respective drivers.
>>>> + *
>>>> + * Return: 0 on success, proper error code otherwise
>>>> + *
>>>> + */
>>>> +int __init of_parse_thermal_zones(void)
>>>> +{
>>>> +	struct device_node *np, *child;
>>>> +	struct __thermal_zone *tz;
>>>> +	struct thermal_zone_device_ops *ops;
>>>> +
>>>> +	np =3D of_find_node_by_name(NULL, "thermal-zones");
>>>> +	if (!np) {
>>>> +		pr_err("unable to find thermal zones\n");
>>>> +		return 0;
>>>
>>> return 0? This is success?
>>
>> This case is success because there should be systems without thermal D=
T
>> entries.
>=20
> Then the pr_err should be pr_notice/info or not there at all.

Yeah, done in v5.

>=20
> []
>=20
>>>> +		/* No hwmon because there might be hwmon drivers registering */
>>>> +		tzp->no_hwmon =3D true;
>>>> +
>>>> +		zone =3D thermal_zone_device_register(child->name, tz->ntrips,
>>>> +						    0, tz,
>>>> +						    ops, tzp,
>>>> +						    tz->passive_delay,
>>>> +						    tz->polling_delay);
>>>> +		if (IS_ERR(zone))
>>>> +			pr_err("Failed to build %s zone %ld\n", child->name,
>>>> +			       PTR_ERR(zone));
>=20
> Should there should be a return -ERR here?
>=20

well, no, there might be other correct thermal zones in DT that needs
parsing.

>> hmmm.. I am sending after reworking the return code of this function.
>=20
> thanks.
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--ogWmvRmlNaBqQ02FNdr287QusvviGwfuJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlI6FfoACgkQCXcVR3XQvP30ygD7BCplfN3VJze+EnM4gM78aO37
yMq6PF3sKQrAuyGPELcBAMqbmnldF17vFJ5dWwnNc+AqAWdTWu2H+ckYtB0Aj4Ry
=lvUL
-----END PGP SIGNATURE-----

--ogWmvRmlNaBqQ02FNdr287QusvviGwfuJ--
