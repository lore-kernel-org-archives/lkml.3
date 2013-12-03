Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab3LCMhP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 07:37:15 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:37732 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752098Ab3LCMhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 07:37:11 -0500
Message-ID: <529DD05E.1050402@ti.com>
Date: Tue, 3 Dec 2013 08:36:46 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Lukasz Majewski <l.majewski@samsung.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Zhang Rui <rui.zhang@intel.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, <durgadoss.r@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Subject: Re: [PATCH v10 7/7] thermal:exynos:boost: Automatic enable/disable
 of BOOST feature (at Exynos4412)
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com> <1383672411-26324-1-git-send-email-l.majewski@samsung.com> <1383672411-26324-8-git-send-email-l.majewski@samsung.com> <529C9ED2.2060106@ti.com> <20131203083159.35895456@amdc2363>
In-Reply-To: <20131203083159.35895456@amdc2363>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="uUlLs03Gj8Fg2nUDTspMPmf5CU0vv6LgW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--uUlLs03Gj8Fg2nUDTspMPmf5CU0vv6LgW
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 03-12-2013 03:31, Lukasz Majewski wrote:
> Hi Eduardo,
>=20
>> On 05-11-2013 13:26, Lukasz Majewski wrote:
>>> This patch provides auto disable/enable operation for boost. It
>>> uses already present thermal infrastructure to provide boost
>>> hysteresis. A special set of TMU data has been defined for
>>> Exynos4412, which is only considered when BOOST is enabled.
>>
>> Can you please add more description why you need a different set of
>> thermal data when boost is enabled?=20
>=20
> It turned out that the Thermal subsystem (after rework done for v3.12)
> is capable of providing hysteresis for BOOST.
>=20

So, the difference is only the hysteresis?

> For version of the patch up to v8 I had to modify the thermal core to
> provide such functionality. Changes in core weren't accepted by Zhang
> Rui.

Ok... But still I didn't get what you needed to modify and why.. Sorry I
jumped in the middle of ongoing discussion.

>=20
> Then I've looked again to the code and it turned out that proper
> setting of Exynos4x12 data (like trigger levels and freq_clip_max) can
> solve the problem in a much better way by using Exynos thermal
> interrupts.
> Another advantage is that those changes are done per device.
>=20
>> This is also important in case you
>> (Exynos thermal folks) would like to migrate this driver to have
>> thermal data support in DT.
>=20
> Some work on this driver is ongoing (mainly done by Bartek
> Zolnierkiewicz). This BOOST change doesn't break anything and only
> extend the current thermal code. Thereof it will not break anything.

Well, good that it does not break anything, right?

But, My point, Lukasz, is that I am failing to understand, based on your
patch and description why we need a different data definition, one for
boost, other for without boost. Can you help me to get your intention
with this patch properly?

Side question is what happens in runtime if user echo 0 > boost? Should
we switch the data within the driver? Would we be penalizing performance
with strict hysteresis while we could be allowing longer periods of high
frequency usage? See what I am missing? Maybe we actually need something
else a part from defining one data structure for boost other for
non-boost systems.

>=20
>>
>>
>>>
>>> Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
>>> Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
>>>
>>> ---
>>> Changes for v10:
>>>     - Remove boost related code from thermal_core.c
>>>     - Use already present thermal infrastructure to provide thermal
>>> hysteresis
>>>     - Introduce special set of TMU data for BOOST
>>>
>>> Changes for v9:
>>>     - None
>>>
>>> Changes for v8:
>>>     - Move cpufreq_boost_* stub functions definition (needed when
>>> cpufreq is not compiled in) to cpufreq.h at cpufreq core support
>>> commit
>>>
>>> Changes for v7:
>>>     - None
>>>
>>> Changes for v6:
>>>     - Disable boost only when supported and enabled
>>>     - Protect boost related thermal_zone_device struct fields with
>>> mutex
>>>     - Evaluate temperature trend during boost enable decision
>>>     - Create separate methods to handle boost enable/disable
>>>       (thermal_boost_{enable|disable}) operations
>>>     - Boost is disabled at any trip point passage (not only the non
>>> critical one)
>>>     - Add stub definitions for cpufreq boost functions used when
>>>       CONFIG_CPU_FREQ is NOT defined.
>>>
>>> Changes for v5:
>>>     - Move boost disable code from cpu_cooling.c to thermal_core.c
>>>       (to handle_non_critical_trips)
>>>     - Extent struct thermal_zone_device by adding overheated bool
>>> flag
>>>     - Implement auto enable of boost after device cools down
>>>     - Introduce boost_polling flag, which indicates if thermal uses
>>> it's predefined pool delay or has woken up thermal workqueue only
>>> to wait until device cools down.
>>>
>>> Changes for v4:
>>>     - New patch
>>
>>
>> Might be interesting to see the changelog for this patch only.
>=20
> The above list presents the development state of this particular patch
> (thermal).=20
> Up to v8 I had modified the thermal core. For v10 I've decided to use
> proper Exynos data setting.
>=20
> If in any doubt, please ask.=20
>=20
> This last thermal patch of the series hinders this code to be applied
> to cpufreq subsystem (Viresh had acked it some time ago and I hope that=

> he hasn't changed his mind :-) ).
>=20
>=20
>>
>>>
>>>  drivers/thermal/samsung/exynos_tmu_data.c |   47
>>> +++++++++++++++++++++++++++++ 1 file changed, 47 insertions(+)
>>>
>>> diff --git a/drivers/thermal/samsung/exynos_tmu_data.c
>>> b/drivers/thermal/samsung/exynos_tmu_data.c index 073c292..9346926
>>> 100644 --- a/drivers/thermal/samsung/exynos_tmu_data.c
>>> +++ b/drivers/thermal/samsung/exynos_tmu_data.c
>>> @@ -167,13 +167,60 @@ static const struct exynos_tmu_registers
>>> exynos4412_tmu_registers =3D { .features =3D (TMU_SUPPORT_EMULATION |=

>>> TMU_SUPPORT_TRIM_RELOAD | \ TMU_SUPPORT_FALLING_TRIP |
>>> TMU_SUPPORT_READY_STATUS | \ TMU_SUPPORT_EMUL_TIME)
>>> +
>>> +#define EXYNOS4412_TMU_DATA_BOOST \
>>> +	.threshold_falling =3D 10, \
>>> +	.trigger_levels[0] =3D 70, \
>>> +	.trigger_levels[1] =3D 85, \
>>> +	.trigger_levels[2] =3D 103, \
>>> +	.trigger_levels[3] =3D 110, \
>>> +	.trigger_enable[0] =3D true, \
>>> +	.trigger_enable[1] =3D true, \
>>> +	.trigger_enable[2] =3D true, \
>>> +	.trigger_enable[3] =3D true, \
>>> +	.trigger_type[0] =3D THROTTLE_ACTIVE, \
>>> +	.trigger_type[1] =3D THROTTLE_ACTIVE, \
>>> +	.trigger_type[2] =3D THROTTLE_ACTIVE, \
>>> +	.trigger_type[3] =3D SW_TRIP, \
>>> +	.max_trigger_level =3D 4, \
>>> +	.gain =3D 8, \
>>> +	.reference_voltage =3D 16, \
>>> +	.noise_cancel_mode =3D 4, \
>>> +	.cal_type =3D TYPE_ONE_POINT_TRIMMING, \
>>> +	.efuse_value =3D 55, \
>>> +	.min_efuse_value =3D 40, \
>>> +	.max_efuse_value =3D 100, \
>>> +	.first_point_trim =3D 25, \
>>> +	.second_point_trim =3D 85, \
>>> +	.default_temp_offset =3D 50, \
>>> +	.freq_tab[0] =3D { \
>>> +		.freq_clip_max =3D 1400 * 1000, \
>>> +		.temp_level =3D 70, \
>>> +	}, \
>>> +	.freq_tab[1] =3D { \
>>> +		.freq_clip_max =3D 800 * 1000, \
>>> +		.temp_level =3D 85, \
>>> +	}, \
>>> +	.freq_tab[2] =3D { \
>>> +		.freq_clip_max =3D 200 * 1000, \
>>> +		.temp_level =3D 103, \
>>> +	}, \
>>> +	.freq_tab_count =3D 3, \
>>> +	.registers =3D &exynos4412_tmu_registers, \
>>> +	.features =3D (TMU_SUPPORT_EMULATION |
>>> TMU_SUPPORT_TRIM_RELOAD | \
>>> +			TMU_SUPPORT_FALLING_TRIP |
>>> TMU_SUPPORT_READY_STATUS | \
>>> +			TMU_SUPPORT_EMUL_TIME)
>>>  #endif
>>> =20
>>>  #if defined(CONFIG_SOC_EXYNOS4412)
>>>  struct exynos_tmu_init_data const exynos4412_default_tmu_data =3D {
>>>  	.tmu_data =3D {
>>>  		{
>>> +#ifdef CONFIG_CPU_FREQ_BOOST_SW
>>> +			EXYNOS4412_TMU_DATA_BOOST,
>>> +#else
>>>  			EXYNOS4412_TMU_DATA,
>>> +#endif
>>>  			.type =3D SOC_ARCH_EXYNOS4412,
>>>  			.test_mux =3D EXYNOS4412_MUX_ADDR_VALUE,
>>>  		},
>>>
>>
>>
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--uUlLs03Gj8Fg2nUDTspMPmf5CU0vv6LgW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlKd0GQACgkQCXcVR3XQvP1PPQEAr1+DMdAtw3QlWeX7MksKva3T
uMMYoEcVq96kRDjhIGQBAKX4pYTqg/CEZJ7oKkxBPKqXQOCI7mjG22Xs81b/jwop
=O8X7
-----END PGP SIGNATURE-----

--uUlLs03Gj8Fg2nUDTspMPmf5CU0vv6LgW--
