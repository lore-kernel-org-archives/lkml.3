Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850Ab3IYORK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 10:17:10 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:49320 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755432Ab3IYORI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 10:17:08 -0400
Message-ID: <5242F011.4090607@ti.com>
Date: Wed, 25 Sep 2013 10:15:45 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Hongbo Zhang <hongbo.zhang@freescale.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>, <swarren@wwwdotorg.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ian.campbell@citrix.com>, <rob.herring@calxeda.com>,
        <linux@roeck-us.net>, <rui.zhang@intel.com>, <wni@nvidia.com>,
        <joe@perches.com>, <grant.likely@linaro.org>, <durgadoss.r@intel.com>,
        <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>
Subject: Re: [PATCHv6 02/16] drivers: thermal: introduce device tree parser
References: <1379537849-28425-1-git-send-email-eduardo.valentin@ti.com> <1379540136-28378-1-git-send-email-eduardo.valentin@ti.com> <52428D13.7080007@freescale.com>
In-Reply-To: <52428D13.7080007@freescale.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="9NVv4OF6QSeDBwn6Ia3DfDqDCb3MeNUTg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--9NVv4OF6QSeDBwn6Ia3DfDqDCb3MeNUTg
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 25-09-2013 03:13, Hongbo Zhang wrote:
> On 09/19/2013 05:35 AM, Eduardo Valentin wrote:
>>   [...]
>> +
>> +/***   sensor API   ***/
>> +
>=20
> You are introducing new concept here, the original framework and driver=
s
> cannot use this, right? any further plan to update original framework
> for this new feature?
>=20

Well, not new as such. Just a specific way to register sensors to
thermal framework. What is really new is the fact that we really need to
have sensors decoupled from thermal zone devices, and today we have
these concepts pretty merged together.

To answer your question, for now I am more concerned with the bindings
definition. Once that is at least agreed, then we can follow up with the
migration of existing drivers. For now, there are two examples in this
series, first one is using one existing thermal driver, which is the TI
SoC thermal driver, and the second one is the hwmon drivers, which are
existing sensor drivers, but are not thermal drivers.

The plan forward, once this series is accepted is to migrate existing
drivers, yes, so that they can use device tree uniformly. Of course,
this needs help from driver authors.

My proposal will be to follow up this series with a two fold migration.
First step to change the existing thermal drivers to have both, the
current support and the device tree support. And second step, for those
who wish to, we could remove the old code containing thermal data and
have only dt support. Of course, this requires drivers authors input.



>> +static struct thermal_zone_device *
>> +thermal_zone_of_add_sensor(struct device_node *zone,
>> +               struct device_node *sensor, void *data,
>> +               int (*get_temp)(void *, long *),
>> +               int (*get_trend)(void *, long *))
>> +{
>> +    struct thermal_zone_device *tzd;
>> +    struct __thermal_zone *tz;
>> +
>> +    tzd =3D thermal_zone_get_zone_by_name(zone->name);
>> +    if (IS_ERR(tzd))
>> +        return ERR_PTR(-EPROBE_DEFER);
>> +
>> [...]
>> +
>> +/*
>> + * Here are the thermal trip types. This must
>> + * match with enum thermal_trip_type at
>> + * include/linux/thermal.h
>> + */
>> +#define THERMAL_TRIP_ACTIVE        0
>> +#define THERMAL_TRIP_PASSIVE        1
>> +#define THERMAL_TRIP_HOT        2
>> +#define THERMAL_TRIP_CRITICAL        3
>> +
>=20
> These macros seem duplicated with enum thermal_trip_type in thermal.h,
> do you have further plan to merge them?
> Or by using string "active",  "passive" etc in the dts, then you can
> reuse the original enum definition.

I am changing this so that in DT we have string constants, and we keep a
map from string to enum, just like we have for phy-mode, as suggested by
Mark.

You can have a taste of it here:
https://git.kernel.org/cgit/linux/kernel/git/evalenti/linux.git/commit/?h=
=3Dthermal_work/thermal_core/dt_parser_rfc_v4&id=3D73f16c27fc763495188fba=
7d6e17b9c986efc6ac

I will be reposting this version once we are done with this thread
discussion and I am finished with my current test.

If you have the time, I would appreciate if you could try the series on
your board, as I am don't have access to your hardware. It would be
really nice to see how this work is behaving in other environments then
the one I have.

Thanks for your interest in this work.

>=20
>> +/* On cooling devices upper and lower limits */
>> +#define THERMAL_NO_LIMIT        (-1UL)
>> +
>> +#endif
>> [...]
>=20
>=20
>=20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--9NVv4OF6QSeDBwn6Ia3DfDqDCb3MeNUTg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlJC8BMACgkQCXcVR3XQvP3oKgEAj64gKzVrZc4SETh0SokWHZlg
On0jslhZhOCdmuuMG/ABAKfDYzjXutR3IyEPoRU62kXHVbUV9/HsDBBt2yKmUJF0
=H9Dx
-----END PGP SIGNATURE-----

--9NVv4OF6QSeDBwn6Ia3DfDqDCb3MeNUTg--
