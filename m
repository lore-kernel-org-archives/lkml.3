Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab3H0S2P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 14:28:15 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57832 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab3H0S2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 14:28:11 -0400
Message-ID: <521CEF61.6040504@ti.com>
Date: Tue, 27 Aug 2013 14:26:41 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Eduardo Valentin <eduardo.valentin@ti.com>, <linux-pm@vger.kernel.org>,
        <rui.zhang@intel.com>, <linux-kernel@vger.kernel.org>,
        Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>, <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Len Brown <lenb@kernel.org>,
        <linux-acpi@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Peter Feuerer <peter@piie.net>, <platform-driver-x86@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 3/5] drivers: thermal: make usage of CONFIG_THERMAL_HWMON
 optional
References: <1377295396-17289-1-git-send-email-eduardo.valentin@ti.com> <1377295396-17289-4-git-send-email-eduardo.valentin@ti.com> <4832825.8PCMQe7StP@vostro.rjw.lan>
In-Reply-To: <4832825.8PCMQe7StP@vostro.rjw.lan>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="oEg1V3xwa0HBCgmlOvfSbtwu2kncWWjXG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--oEg1V3xwa0HBCgmlOvfSbtwu2kncWWjXG
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 23-08-2013 19:08, Rafael J. Wysocki wrote:
> On Friday, August 23, 2013 06:03:14 PM Eduardo Valentin wrote:
>> When registering a new thermal_device, the thermal framework
>> will always add a hwmon sysfs interface.
>>
>> This patch adds a flag to make this behavior optional. Now
>> when registering a new thermal device, the caller needs
>> to say if the hwmon interface is required.
>>
>> In order to keep same behavior as of today, all current
>> calls will by default create the hwmon interface.
>=20
> Well, instead of modifying all of the callers this way, why don't
> you add new versions taking the additional argument as, for example,
>=20
> thermal_zone_device_register_full()
>=20
> and redefine the old ones as static inline wrappers, for example
>=20
> static inline struct thermal_zone_device *thermal_zone_device_register(=
args)
> {
> 	return thermal_zone_device_register_full(args, true);
> }
>=20
> ?

Yeah, that is another way to go and I thought of doing it like that. I
just could not come out with a good API naming:

thermal_zone_device_register_full(all args)

thermal_zone_device_register(args) /* on hwmon =3D=3D true */
thermal_zone_device_register_no_hwmon(args) /* on hwmon =3D=3D false */

Would this sound reasonable naming?


>=20
> That'd reduce the size of this patch a bit I suppose (and the number of=

> subsystems involved at the same time).

I see your point.

>=20
> Thanks,
> Rafael
>=20
>=20
>> Cc: Anton Vorontsov <anton@enomsg.org>
>> Cc: David Woodhouse <dwmw2@infradead.org>
>> Cc: devicetree@vger.kernel.org
>> Cc: Grant Likely <grant.likely@linaro.org>
>> Cc: Kukjin Kim <kgene.kim@samsung.com>
>> Cc: Len Brown <lenb@kernel.org>
>> Cc: linux-acpi@vger.kernel.org
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-kernel@vger.kernel.org
>> Cc: linux-pm@vger.kernel.org
>> Cc: linux-samsung-soc@vger.kernel.org
>> Cc: Matthew Garrett <matthew.garrett@nebula.com>
>> Cc: Peter Feuerer <peter@piie.net>
>> Cc: platform-driver-x86@vger.kernel.org
>> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
>> Cc: Rob Herring <rob.herring@calxeda.com>
>> Cc: Zhang Rui <rui.zhang@intel.com>
>> Suggested-by: Wei Ni <wni@nvidia.com>
>> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
>> ---
>>  Documentation/thermal/sysfs-api.txt                |  4 +++-
>>  drivers/acpi/thermal.c                             |  6 ++++--
>>  drivers/platform/x86/acerhdf.c                     |  3 ++-
>>  drivers/platform/x86/intel_mid_thermal.c           |  2 +-
>>  drivers/power/power_supply_core.c                  |  2 +-
>>  drivers/thermal/armada_thermal.c                   |  2 +-
>>  drivers/thermal/db8500_thermal.c                   |  2 +-
>>  drivers/thermal/dove_thermal.c                     |  2 +-
>>  drivers/thermal/exynos_thermal.c                   |  2 +-
>>  drivers/thermal/kirkwood_thermal.c                 |  2 +-
>>  drivers/thermal/rcar_thermal.c                     |  2 +-
>>  drivers/thermal/spear_thermal.c                    |  2 +-
>>  drivers/thermal/thermal_core.c                     | 13 +++++++++----=

>>  drivers/thermal/ti-soc-thermal/ti-thermal-common.c |  2 +-
>>  drivers/thermal/x86_pkg_temp_thermal.c             |  2 +-
>>  include/linux/thermal.h                            |  2 +-
>>  16 files changed, 30 insertions(+), 20 deletions(-)
>>
>> diff --git a/Documentation/thermal/sysfs-api.txt b/Documentation/therm=
al/sysfs-api.txt
>> index a71bd5b..4b4a052 100644
>> --- a/Documentation/thermal/sysfs-api.txt
>> +++ b/Documentation/thermal/sysfs-api.txt
>> @@ -64,7 +64,9 @@ temperature) and throttle appropriate devices.
>>  	performing passive cooling.
>>      polling_delay: number of milliseconds to wait between polls when =
checking
>>  	whether trip points have been crossed (0 for interrupt driven system=
s).
>> -
>> +    add_hwmon: a boolean to indicate if the thermal to hwmon sysfs in=
terface
>> +	is required. When add_hwmon =3D=3D true, a hwmon sysfs interface
>> +	will be created. When add_hwmon =3D=3D false, nothing will be done
>> =20
>>  1.1.2 void thermal_zone_device_unregister(struct thermal_zone_device =
*tz)
>> =20
>> diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
>> index a33821c..4d542b4 100644
>> --- a/drivers/acpi/thermal.c
>> +++ b/drivers/acpi/thermal.c
>> @@ -916,12 +916,14 @@ static int acpi_thermal_register_thermal_zone(st=
ruct acpi_thermal *tz)
>>  			thermal_zone_device_register("acpitz", trips, 0, tz,
>>  						&acpi_thermal_zone_ops, NULL,
>>  						     tz->trips.passive.tsp*100,
>> -						     tz->polling_frequency*100);
>> +						     tz->polling_frequency*100,
>> +						     true);
>>  	else
>>  		tz->thermal_zone =3D
>>  			thermal_zone_device_register("acpitz", trips, 0, tz,
>>  						&acpi_thermal_zone_ops, NULL,
>> -						0, tz->polling_frequency*100);
>> +						0, tz->polling_frequency*100,
>> +						true);
>>  	if (IS_ERR(tz->thermal_zone))
>>  		return -ENODEV;
>> =20
>> diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/ace=
rhdf.c
>> index f94467c..004d9ba0 100644
>> --- a/drivers/platform/x86/acerhdf.c
>> +++ b/drivers/platform/x86/acerhdf.c
>> @@ -663,7 +663,8 @@ static int acerhdf_register_thermal(void)
>> =20
>>  	thz_dev =3D thermal_zone_device_register("acerhdf", 1, 0, NULL,
>>  					      &acerhdf_dev_ops, NULL, 0,
>> -					      (kernelmode) ? interval*1000 : 0);
>> +					      (kernelmode) ? interval*1000 : 0,
>> +					      true);
>>  	if (IS_ERR(thz_dev))
>>  		return -EINVAL;
>> =20
>> diff --git a/drivers/platform/x86/intel_mid_thermal.c b/drivers/platfo=
rm/x86/intel_mid_thermal.c
>> index 81c491e..efea0bf 100644
>> --- a/drivers/platform/x86/intel_mid_thermal.c
>> +++ b/drivers/platform/x86/intel_mid_thermal.c
>> @@ -502,7 +502,7 @@ static int mid_thermal_probe(struct platform_devic=
e *pdev)
>>  			goto err;
>>  		}
>>  		pinfo->tzd[i] =3D thermal_zone_device_register(name[i],
>> -				0, 0, td_info, &tzd_ops, NULL, 0, 0);
>> +				0, 0, td_info, &tzd_ops, NULL, 0, 0, true);
>>  		if (IS_ERR(pinfo->tzd[i])) {
>>  			kfree(td_info);
>>  			ret =3D PTR_ERR(pinfo->tzd[i]);
>> diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_s=
upply_core.c
>> index 3b2d5df..5f39914 100644
>> --- a/drivers/power/power_supply_core.c
>> +++ b/drivers/power/power_supply_core.c
>> @@ -359,7 +359,7 @@ static int psy_register_thermal(struct power_suppl=
y *psy)
>>  	for (i =3D 0; i < psy->num_properties; i++) {
>>  		if (psy->properties[i] =3D=3D POWER_SUPPLY_PROP_TEMP) {
>>  			psy->tzd =3D thermal_zone_device_register(psy->name, 0, 0,
>> -					psy, &psy_tzd_ops, NULL, 0, 0);
>> +					psy, &psy_tzd_ops, NULL, 0, 0, true);
>>  			if (IS_ERR(psy->tzd))
>>  				return PTR_ERR(psy->tzd);
>>  			break;
>> diff --git a/drivers/thermal/armada_thermal.c b/drivers/thermal/armada=
_thermal.c
>> index 5e53212..bc54c80 100644
>> --- a/drivers/thermal/armada_thermal.c
>> +++ b/drivers/thermal/armada_thermal.c
>> @@ -182,7 +182,7 @@ static int armada_thermal_probe(struct platform_de=
vice *pdev)
>>  	priv->ops->init_sensor(priv);
>> =20
>>  	thermal =3D thermal_zone_device_register("armada_thermal", 0, 0,
>> -					       priv, &ops, NULL, 0, 0);
>> +					       priv, &ops, NULL, 0, 0, true);
>>  	if (IS_ERR(thermal)) {
>>  		dev_err(&pdev->dev,
>>  			"Failed to register thermal zone device\n");
>> diff --git a/drivers/thermal/db8500_thermal.c b/drivers/thermal/db8500=
_thermal.c
>> index 1e3b3bf..439a854 100644
>> --- a/drivers/thermal/db8500_thermal.c
>> +++ b/drivers/thermal/db8500_thermal.c
>> @@ -447,7 +447,7 @@ static int db8500_thermal_probe(struct platform_de=
vice *pdev)
>>  	}
>> =20
>>  	pzone->therm_dev =3D thermal_zone_device_register("db8500_thermal_zo=
ne",
>> -		ptrips->num_trips, 0, pzone, &thdev_ops, NULL, 0, 0);
>> +		ptrips->num_trips, 0, pzone, &thdev_ops, NULL, 0, 0, true);
>> =20
>>  	if (IS_ERR(pzone->therm_dev)) {
>>  		dev_err(&pdev->dev, "Register thermal zone device failed.\n");
>> diff --git a/drivers/thermal/dove_thermal.c b/drivers/thermal/dove_the=
rmal.c
>> index 828f5e3..61f2247 100644
>> --- a/drivers/thermal/dove_thermal.c
>> +++ b/drivers/thermal/dove_thermal.c
>> @@ -155,7 +155,7 @@ static int dove_thermal_probe(struct platform_devi=
ce *pdev)
>>  	}
>> =20
>>  	thermal =3D thermal_zone_device_register("dove_thermal", 0, 0,
>> -					       priv, &ops, NULL, 0, 0);
>> +					       priv, &ops, NULL, 0, 0, true);
>>  	if (IS_ERR(thermal)) {
>>  		dev_err(&pdev->dev,
>>  			"Failed to register thermal zone device\n");
>> diff --git a/drivers/thermal/exynos_thermal.c b/drivers/thermal/exynos=
_thermal.c
>> index 9af4b93..6ffadd3 100644
>> --- a/drivers/thermal/exynos_thermal.c
>> +++ b/drivers/thermal/exynos_thermal.c
>> @@ -469,7 +469,7 @@ static int exynos_register_thermal(struct thermal_=
sensor_conf *sensor_conf)
>>  	th_zone->therm_dev =3D thermal_zone_device_register(sensor_conf->nam=
e,
>>  			EXYNOS_ZONE_COUNT, 0, NULL, &exynos_dev_ops, NULL, 0,
>>  			sensor_conf->trip_data.trigger_falling ?
>> -			0 : IDLE_INTERVAL);
>> +			0 : IDLE_INTERVAL, true);
>> =20
>>  	if (IS_ERR(th_zone->therm_dev)) {
>>  		pr_err("Failed to register thermal zone device\n");
>> diff --git a/drivers/thermal/kirkwood_thermal.c b/drivers/thermal/kirk=
wood_thermal.c
>> index 3b034a0..fb8853e 100644
>> --- a/drivers/thermal/kirkwood_thermal.c
>> +++ b/drivers/thermal/kirkwood_thermal.c
>> @@ -85,7 +85,7 @@ static int kirkwood_thermal_probe(struct platform_de=
vice *pdev)
>>  		return PTR_ERR(priv->sensor);
>> =20
>>  	thermal =3D thermal_zone_device_register("kirkwood_thermal", 0, 0,
>> -					       priv, &ops, NULL, 0, 0);
>> +					       priv, &ops, NULL, 0, 0, true);
>>  	if (IS_ERR(thermal)) {
>>  		dev_err(&pdev->dev,
>>  			"Failed to register thermal zone device\n");
>> diff --git a/drivers/thermal/rcar_thermal.c b/drivers/thermal/rcar_the=
rmal.c
>> index 88f92e1..64ae530 100644
>> --- a/drivers/thermal/rcar_thermal.c
>> +++ b/drivers/thermal/rcar_thermal.c
>> @@ -439,7 +439,7 @@ static int rcar_thermal_probe(struct platform_devi=
ce *pdev)
>>  		priv->zone =3D thermal_zone_device_register("rcar_thermal",
>>  						1, 0, priv,
>>  						&rcar_thermal_zone_ops, NULL, 0,
>> -						idle);
>> +						idle, true);
>>  		if (IS_ERR(priv->zone)) {
>>  			dev_err(dev, "can't register thermal zone\n");
>>  			ret =3D PTR_ERR(priv->zone);
>> diff --git a/drivers/thermal/spear_thermal.c b/drivers/thermal/spear_t=
hermal.c
>> index ab79ea4..ec0c44d 100644
>> --- a/drivers/thermal/spear_thermal.c
>> +++ b/drivers/thermal/spear_thermal.c
>> @@ -140,7 +140,7 @@ static int spear_thermal_probe(struct platform_dev=
ice *pdev)
>>  	writel_relaxed(stdev->flags, stdev->thermal_base);
>> =20
>>  	spear_thermal =3D thermal_zone_device_register("spear_thermal", 0, 0=
,
>> -				stdev, &ops, NULL, 0, 0);
>> +				stdev, &ops, NULL, 0, 0, true);
>>  	if (IS_ERR(spear_thermal)) {
>>  		dev_err(&pdev->dev, "thermal zone device is NULL\n");
>>  		ret =3D PTR_ERR(spear_thermal);
>> diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_=
core.c
>> index 247528b..d949ab0 100644
>> --- a/drivers/thermal/thermal_core.c
>> +++ b/drivers/thermal/thermal_core.c
>> @@ -1344,6 +1344,9 @@ static void remove_trip_attrs(struct thermal_zon=
e_device *tz)
>>   * @polling_delay: number of milliseconds to wait between polls when =
checking
>>   *		   whether trip points have been crossed (0 for interrupt
>>   *		   driven systems)
>> + * @add_hwmon:	a boolean to indicate if the thermal to hwmon sysfs in=
terface
>> + *		is required. When add_hwmon =3D=3D true, a hwmon sysfs interface
>> + *		will be created. When add_hwmon =3D=3D false, nothing will be don=
e
>>   *
>>   * This interface function adds a new thermal zone device (sensor) to=

>>   * /sys/class/thermal folder as thermal_zone[0-*]. It tries to bind a=
ll the
>> @@ -1359,7 +1362,7 @@ struct thermal_zone_device *thermal_zone_device_=
register(const char *type,
>>  	int trips, int mask, void *devdata,
>>  	const struct thermal_zone_device_ops *ops,
>>  	const struct thermal_zone_params *tzp,
>> -	int passive_delay, int polling_delay)
>> +	int passive_delay, int polling_delay, bool add_hwmon)
>>  {
>>  	struct thermal_zone_device *tz;
>>  	enum thermal_trip_type trip_type;
>> @@ -1462,9 +1465,11 @@ struct thermal_zone_device *thermal_zone_device=
_register(const char *type,
>> =20
>>  	mutex_unlock(&thermal_governor_lock);
>> =20
>> -	result =3D thermal_add_hwmon_sysfs(tz);
>> -	if (result)
>> -		goto unregister;
>> +	if (add_hwmon) {
>> +		result =3D thermal_add_hwmon_sysfs(tz);
>> +		if (result)
>> +			goto unregister;
>> +	}
>> =20
>>  	mutex_lock(&thermal_list_lock);
>>  	list_add_tail(&tz->node, &thermal_tz_list);
>> diff --git a/drivers/thermal/ti-soc-thermal/ti-thermal-common.c b/driv=
ers/thermal/ti-soc-thermal/ti-thermal-common.c
>> index 4c5f55c37..5ab613a 100644
>> --- a/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
>> +++ b/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
>> @@ -306,7 +306,7 @@ int ti_thermal_expose_sensor(struct ti_bandgap *bg=
p, int id,
>>  	data->ti_thermal =3D thermal_zone_device_register(domain,
>>  				OMAP_TRIP_NUMBER, 0, data, &ti_thermal_ops,
>>  				NULL, FAST_TEMP_MONITORING_RATE,
>> -				FAST_TEMP_MONITORING_RATE);
>> +				FAST_TEMP_MONITORING_RATE, true);
>>  	if (IS_ERR(data->ti_thermal)) {
>>  		dev_err(bgp->dev, "thermal zone device is NULL\n");
>>  		return PTR_ERR(data->ti_thermal);
>> diff --git a/drivers/thermal/x86_pkg_temp_thermal.c b/drivers/thermal/=
x86_pkg_temp_thermal.c
>> index f36950e..74eb4c0 100644
>> --- a/drivers/thermal/x86_pkg_temp_thermal.c
>> +++ b/drivers/thermal/x86_pkg_temp_thermal.c
>> @@ -444,7 +444,7 @@ static int pkg_temp_thermal_device_add(unsigned in=
t cpu)
>>  			thres_count,
>>  			(thres_count =3D=3D MAX_NUMBER_OF_TRIPS) ?
>>  				0x03 : 0x01,
>> -			phy_dev_entry, &tzone_ops, NULL, 0, 0);
>> +			phy_dev_entry, &tzone_ops, NULL, 0, 0, true);
>>  	if (IS_ERR(phy_dev_entry->tzone)) {
>>  		err =3D PTR_ERR(phy_dev_entry->tzone);
>>  		goto err_ret_free;
>> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
>> index a386a1c..88148b9 100644
>> --- a/include/linux/thermal.h
>> +++ b/include/linux/thermal.h
>> @@ -226,7 +226,7 @@ struct thermal_genl_event {
>>  /* Function declarations */
>>  struct thermal_zone_device *thermal_zone_device_register(const char *=
, int, int,
>>  		void *, const struct thermal_zone_device_ops *,
>> -		const struct thermal_zone_params *, int, int);
>> +		const struct thermal_zone_params *, int, int, bool);
>>  void thermal_zone_device_unregister(struct thermal_zone_device *);
>> =20
>>  int thermal_zone_bind_cooling_device(struct thermal_zone_device *, in=
t,
>>


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--oEg1V3xwa0HBCgmlOvfSbtwu2kncWWjXG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlIc72EACgkQCXcVR3XQvP1XSAD+I4ZL+liI2OD/g5stpQeendRs
Oaais7sKv6kNWKzfvLIBAKF1ziyeOmW8Twcpz2+1wc9vlgf/FTk557jv1/EY4lVJ
=J+4A
-----END PGP SIGNATURE-----

--oEg1V3xwa0HBCgmlOvfSbtwu2kncWWjXG--
