Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188AbaAGO7y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 09:59:54 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:46123 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016AbaAGO7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 09:59:45 -0500
Message-ID: <52CC15F0.6020209@ti.com>
Date: Tue, 7 Jan 2014 10:57:52 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Zhang, Rui" <rui.zhang@intel.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>,
        Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Frodo Looijaard <frodol@dds.nl>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] hwmon/sensors: fix SENSORS_LM75 dependencies
References: <20140106204020.b47e53cc3ead8f90164ef5b7@canb.auug.org.au> <52CB0948.6030702@infradead.org> <20140106203209.GA21630@roeck-us.net> <52CB53DC.4030901@infradead.org> <52CB65DA.2010103@roeck-us.net> <20140107130401.23bffcd2@endymion.delvare> <52CBF1CF.2000603@ti.com> <744357E9AAD1214791ACBA4B0B909263011BC64C@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <744357E9AAD1214791ACBA4B0B909263011BC64C@SHSMSX101.ccr.corp.intel.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="doAJTgBg6bQHj6PO0clfRR9hiqgU7xwxC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--doAJTgBg6bQHj6PO0clfRR9hiqgU7xwxC
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 07-01-2014 10:05, Zhang, Rui wrote:
>=20
>=20
>> -----Original Message-----
>> From: Eduardo Valentin [mailto:eduardo.valentin@ti.com]
>> Sent: Tuesday, January 07, 2014 8:24 PM
>> To: Jean Delvare
>> Cc: Guenter Roeck; Randy Dunlap; Stephen Rothwell; linux-
>> next@vger.kernel.org; linux-kernel@vger.kernel.org; Frodo Looijaard;
>> lm-sensors@lm-sensors.org; Zhang, Rui; Eduardo Valentin; linux-
>> pm@vger.kernel.org
>> Subject: Re: [PATCH] hwmon/sensors: fix SENSORS_LM75 dependencies
>> Importance: High
>>
>> On 07-01-2014 08:04, Jean Delvare wrote:
>>> Hi Guenter, Randy,
>>>
>>> On Mon, 06 Jan 2014 18:26:34 -0800, Guenter Roeck wrote:
>>>> On 01/06/2014 05:09 PM, Randy Dunlap wrote:
>>>>> From: Randy Dunlap <rdunlap@infradead.org>
>>>>>
>>>>> Fix SENSORS_LM75 dependencies to eliminate build errors:
>>>>>
>>>>> drivers/built-in.o: In function `lm75_remove':
>>>>> lm75.c:(.text+0x12bd8c): undefined reference to
>> `thermal_zone_of_sensor_unregister'
>>>>> drivers/built-in.o: In function `lm75_probe':
>>>>> lm75.c:(.text+0x12c123): undefined reference to
>> `thermal_zone_of_sensor_register'
>>>>>
>>>>> Add depends on THERMAL_OF since that is what provides the
>>>>> register/unregister functions above.
>>>>>
>>>>> Add depends on THERMAL since THERMAL is a tristate (while
>> THERMAL_OF
>>>>> is a bool) and SENSORS_LM75 (tristate) needs to be limited to
>>>>> modular builds when THERMAL=3Dm.
>>>>>
>>>>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>>>>> ---
>>>>>   drivers/hwmon/Kconfig |    2 ++
>>>>>   1 file changed, 2 insertions(+)
>>>>>
>>>>> --- linux-next-20140106.orig/drivers/hwmon/Kconfig
>>>>> +++ linux-next-20140106/drivers/hwmon/Kconfig
>>>>> @@ -650,6 +650,8 @@ config SENSORS_LM73
>>>>>   config SENSORS_LM75
>>>>>   	tristate "National Semiconductor LM75 and compatibles"
>>>>>   	depends on I2C
>>>>> +	depends on THERMAL
>>>>> +	depends on THERMAL_OF
>>>>>   	help
>>>>>   	  If you say yes here you get support for one common type
>> of
>>>>>   	  temperature sensor chip, with models including:
>>>>>
>>>>>
>>>> NACK. The driver does not and must not depend on THERMAL.
>>>
>>> Correct.
>>>
>>>> This needs to be addressed
>>>> in the thermal code, for example with dummy declarations if
>> THERMAL=3Dm
>>>> but SENSORS_LM75=3Dy. The functions are already declared as dummies =
if
>> THERMAL_OF=3Dn.
>>>
>>> This won't fly I'm afraid, the number of hwmon drivers affected will
>>> grow in the future and you certainly don't want to have to change the=

>>> generic thermal code every time a new driver is added/converted.
>>
>> Agreed
>>
>>>
>>> I've looked at the problem this morning and I will admit I do not
>> even
>>> understand what the problem is. In Randy's config,
>> CONFIG_THERMAL_OF=3Dy
>>> so both thermal_zone_of_sensor_unregister and
>>> thermal_zone_of_sensor_register are built-in. SENSORS_LM75=3Dy so the=

>>> calls to these functions are built-in too. I just can't see how this
>>> can be a problem at link time. Can anyone enlighten me?
>>>
>>
>>
>> I believe the problem is more in the fact that THERMAL_OF is a bool,
>> but the way it is in thermal Kconfig, it will link to the thermal
>> module, in case CONFIG_THERMAL=3Dm. Thus I am proposing the following,=

>> which limits the user to have THERMAL_OF only as builtin and whenever
>> is selected, it will select THERMAL too. That is:
>>
>>
>> From b643aa260ed4f3514d1ca51b1ecbe4be7652a8d0 Mon Sep 17 00:00:00 2001=

>> From: Eduardo Valentin <eduardo.valentin@ti.com>
>> Date: Tue, 7 Jan 2014 08:04:02 -0400
>> Subject: [PATCH 1/1] thermal: fix compilation issue on
>> CONFIG_THERMAL_OF  dependencies
>>
>> Users of API provided by THERMAL_OF config may suffer when
>> CONFIG_THERMAL=3Dy, causing linking issues, such as:
>>
>> drivers/built-in.o: In function `lm75_remove':
>> lm75.c:(.text+0x12bd8c): undefined reference to
>> `thermal_zone_of_sensor_unregister'
>> drivers/built-in.o: In function `lm75_probe':
>> lm75.c:(.text+0x12c123): undefined reference to
>> `thermal_zone_of_sensor_register'
>>
>> Therefore, this patch limits the compilation build to always have
>> THERMAL=3Dy, whenever THERMAL_OF=3Dy. In this way, whenever the API us=
er is
>> built, if THERMAL_OF=3Dy, the build shall have the full thermal suppor=
t,
>> otherwise, the thermal API will provide stubs.
>>
>> Cc: Zhang Rui <rui.zhang@intel.com>
>> Cc: linux-pm@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
>> ---
>>  drivers/thermal/Kconfig | 29 ++++++++++++++++-------------
>>  1 file changed, 16 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig index
>> 58f98bd..dc315e9 100644
>> --- a/drivers/thermal/Kconfig
>> +++ b/drivers/thermal/Kconfig
>> @@ -29,19 +29,6 @@ config THERMAL_HWMON
>>  	  Say 'Y' here if you want all thermal sensors to
>>  	  have hwmon sysfs interface too.
>>
>> -config THERMAL_OF
>> -	bool
>> -	prompt "APIs to parse thermal data out of device tree"
>> -	depends on OF
>> -	default y
>> -	help
>> -	  This options provides helpers to add the support to
>> -	  read and parse thermal data definitions out of the
>> -	  device tree blob.
>> -
>> -	  Say 'Y' here if you need to build thermal infrastructure
>> -	  based on device tree.
>> -
>>  choice
>>  	prompt "Default Thermal governor"
>>  	default THERMAL_DEFAULT_GOV_STEP_WISE
>> @@ -235,3 +222,19 @@ source "drivers/thermal/samsung/Kconfig"
>>  endmenu
>>
>>  endif
>> +
>> +menuconfig THERMAL_OF
>> +	bool
>> +	prompt "APIs to parse thermal data out of device tree"
>> +	depends on OF
>> +	select THERMAL
>> +	default y
>> +	help
>> +	  This options enables DT thermal API which adds support to
>> +	  read and parse thermal data definitions out of the
>> +	  device tree blob. This option is mostly used by embedded
>> +	  thermal drivers.
>> +
>> +	  Say 'Y' here if you need to build thermal infrastructure
>> +	  based on device tree.
>> +
>> --
>> 1.8.2.1.342.gfa7285d
>>
>> Randy, can you please confirm if this fix the issue for you?
>>
> The patch looks good to me, will apply it after it has been verified to=
 fix the problem.
> BTW, I've been thinking of make CONFIG_THERMAL a bool since long time a=
go, the only thing that blocks me is that Thermal subsystem needs to regi=
ster a hwmon device for each thermal zone and CONFIG_HWMON is a tristate.=

>=20

I agree with the move of having CONFIG_THERMAL as bool. Unless you have
use cases where users are dynamically loading and unloading thermal per
user demand, which I doubt.

> Thanks,
> rui
>> --
>> You have got to be excited about what you are doing. (L. Lamport)
>>
>> Eduardo Valentin
>=20
>=20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--doAJTgBg6bQHj6PO0clfRR9hiqgU7xwxC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlLMFfAACgkQCXcVR3XQvP1KigD/WBvOYp8WAQ64ctXZqqrexz1W
BMbwNuyO5IqnUagYV80BAMpl7aUSf9owiFzFbLdNSWHjHdv278pqTn92MW/ohwpd
=kVnl
-----END PGP SIGNATURE-----

--doAJTgBg6bQHj6PO0clfRR9hiqgU7xwxC--
