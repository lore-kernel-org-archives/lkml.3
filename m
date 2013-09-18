Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab3IRTqK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 15:46:10 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:33114 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753044Ab3IRTqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 15:46:06 -0400
Message-ID: <523A0290.8050502@ti.com>
Date: Wed, 18 Sep 2013 15:44:16 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>, <swarren@wwwdotorg.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ian.campbell@citrix.com>, <rob.herring@calxeda.com>,
        <linux@roeck-us.net>, <rui.zhang@intel.com>, <wni@nvidia.com>,
        <grant.likely@linaro.org>, <durgadoss.r@intel.com>,
        <linux-pm@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv3 02/16] drivers: thermal: introduce device tree parser
References: <5239F6D8.1020907@ti.com>  <1379530923-29268-1-git-send-email-eduardo.valentin@ti.com> <1379531483.1787.55.camel@joe-AO722>
In-Reply-To: <1379531483.1787.55.camel@joe-AO722>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="QGeIEom5s0FanB2kpUmipVPmpnifuMlT7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--QGeIEom5s0FanB2kpUmipVPmpnifuMlT7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello Joe,

Thanks for reviewing this code. Couple of replies.

 18-09-2013 15:11, Joe Perches wrote:
> On Wed, 2013-09-18 at 15:02 -0400, Eduardo Valentin wrote:
>> This patch introduces a device tree bindings for
>> describing the hardware thermal behavior and limits.
>> Also a parser to read and interpret the data and feed
>> it in the thermal framework is presented.
>=20
> trivial notes:


No issues.

>=20
>> diff --git a/drivers/thermal/of-thermal.c b/drivers/thermal/of-thermal=
=2Ec
> []
>> +static int of_thermal_get_trend(struct thermal_zone_device *tz, int t=
rip,
>> +				enum thermal_trend *trend)
>> +{
>> +	struct __thermal_zone *data =3D tz->devdata;
>> +	long dev_trend;
>> +	int r;
>> +
>> +	if (!data->get_trend)
>> +		return -EINVAL;
>> +
>> +	r =3D data->get_trend(data->sensor_data, &dev_trend);
>> +	if (r)
>> +		return r;
>> +
>> +	if (dev_trend > 0)
>> +		*trend =3D THERMAL_TREND_RAISING;
>> +	else if (dev_trend < 0)
>> +		*trend =3D THERMAL_TREND_DROPPING;
>> +	else
>> +		*trend =3D THERMAL_TREND_STABLE;
>> +
>> +	return 0;
>> +}
>=20
> If readings are within some non zero noise level,
> perhaps stable should be returned.

Yes, there should be some sort of threshold for temperature trend. But I
am not sure this is the right place to implement this. This type of
feature is in my TODO list, but I am planing to get it done within the
core code of the thermal framework.


>=20
>> +static struct __thermal_zone *
>> +thermal_of_build_thermal_zone(struct device_node *np)
>> +{
>> +	struct device_node *child, *gchild;
>> +	struct __thermal_zone *tz;
>> +	int ret, i;
>> +	u32 prop;
>> +
>> +	if (!np) {
>> +		pr_err("no thermal zone np\n");
>> +		return ERR_PTR(-EINVAL);
>> +	}
>> +
>> +	tz =3D kzalloc(sizeof(*tz), GFP_KERNEL);
>> +	if (!tz) {
>> +		pr_err("not enough memory for thermal of zone\n");
>=20
> Unnecessary OOM message.
> All allocs without GFP_NOWARN get a dump_stack()
>=20
>> +int __init of_parse_thermal_zones(void)
>> +{
> []
>> +		ops =3D kzalloc(sizeof(*ops), GFP_KERNEL);
>> +		if (!ops) {
>> +			pr_err("no memory available for thermal ops\n");
>> +			return 0;
>> +		}
>> +		memcpy(ops, &of_thermal_ops, sizeof(*ops));
>> +
>> +		tzp =3D kzalloc(sizeof(*tzp), GFP_KERNEL);
>> +		if (!ops) {
>> +			pr_err("no memory available for thermal zone params\n");
>> +			return 0;
>> +		}
>=20
> a couple more OOMs.
>=20

Hmmm.. I am pretty sure you have a good point. But to me seams to be
still a common practice to have drivers outputing error messages when
allocation fails. A simple git grep -A 4 kzalloc for instance, shows
that there are still quite a considerable amount of occurrences of such
practice.


>=20
>=20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--QGeIEom5s0FanB2kpUmipVPmpnifuMlT7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlI6ApcACgkQCXcVR3XQvP1eowEA0vcsoda058lNFG/8FLwbLmpG
dxXBo+44TgC6WYwG5NwBAI1H45DKqqrEqC/xK3SfErszcWt64wSJZ+eIJHiRK4cN
=n92E
-----END PGP SIGNATURE-----

--QGeIEom5s0FanB2kpUmipVPmpnifuMlT7--
