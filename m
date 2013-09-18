Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855Ab3IRVYO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 17:24:14 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54474 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873Ab3IRVYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 17:24:12 -0400
Message-ID: <523A19B3.2090908@ti.com>
Date: Wed, 18 Sep 2013 17:22:59 -0400
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
Subject: Re: [PATCHv5 02/16] drivers: thermal: introduce device tree parser
References: <1379536310-30000-1-git-send-email-eduardo.valentin@ti.com>  <1379537849-28425-1-git-send-email-eduardo.valentin@ti.com> <1379538289.1787.74.camel@joe-AO722>
In-Reply-To: <1379538289.1787.74.camel@joe-AO722>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="XBAuE5fkxraiFrOC5No2QESdE4rBUv5Ps"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--XBAuE5fkxraiFrOC5No2QESdE4rBUv5Ps
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 18-09-2013 17:04, Joe Perches wrote:
> On Wed, 2013-09-18 at 16:57 -0400, Eduardo Valentin wrote:
>> This patch introduces a device tree bindings for
>> describing the hardware thermal behavior and limits.
>> Also a parser to read and interpret the data and feed
>> it in the thermal framework is presented.
> []
>> +int __init of_parse_thermal_zones(void)
>> +{
>> +	struct device_node *np, *child;
>> +	struct __thermal_zone *tz;
>> +	struct thermal_zone_device_ops *ops;
> []
>> +		if (!ops)
>> +			return -ENOMEM;
>> +
>> +		tzp =3D kzalloc(sizeof(*tzp), GFP_KERNEL);
>> +		if (!tzp)
>> +			return -ENOMEM;
>=20
> leaking memory when ops && !tpz

Yeah, and if !ops too. I am reposting with proper kfreeing. I will be
rolling back the added thermal zones when there is an OOM situation too.

>=20
>> +
>> +		/* No hwmon because there might be hwmon drivers registering */
>> +		tzp->no_hwmon =3D true;
>> +
>> +		zone =3D thermal_zone_device_register(child->name, tz->ntrips,
>> +						    0, tz,
>> +						    ops, tzp,
>> +						    tz->passive_delay,
>> +						    tz->polling_delay);
>> +		if (IS_ERR(zone))
>> +			pr_err("Failed to build %s zone %ld\n", child->name,
>> +			       PTR_ERR(zone));
>> +	}
>=20
> Still leaking memory if !zone no?

yeah. Will free them too.
>=20
>> +
>> +	return 0;
>> +}
>=20
>=20
>=20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--XBAuE5fkxraiFrOC5No2QESdE4rBUv5Ps
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlI6GbUACgkQCXcVR3XQvP0GcwD5AfvwrYK4gg16ARYKmvl7+A9x
oExB2NUfihhvHRv7bqIBAJ3EGxjziLQXqLH9qUulzr3gE0hpNgNEmNrsMjthbpX1
=xIJE
-----END PGP SIGNATURE-----

--XBAuE5fkxraiFrOC5No2QESdE4rBUv5Ps--
