Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab3H0NHQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 09:07:16 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:37511 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab3H0NHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 09:07:13 -0400
Message-ID: <521CA42C.9040106@ti.com>
Date: Tue, 27 Aug 2013 09:05:48 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "wni@nvidia.com" <wni@nvidia.com>,
        "durgadoss.r@intel.com" <durgadoss.r@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [RFC PATCH 01/14] cpufreq: cpufreq-cpu0: add dt node parsing
 for 'cooling-zones'
References: <1377299755-5134-1-git-send-email-eduardo.valentin@ti.com> <1377299755-5134-2-git-send-email-eduardo.valentin@ti.com> <20130827092931.GB19893@e106331-lin.cambridge.arm.com>
In-Reply-To: <20130827092931.GB19893@e106331-lin.cambridge.arm.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="dEF9eMqXhooVnkhejDaH0qBEGe22GqquO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--dEF9eMqXhooVnkhejDaH0qBEGe22GqquO
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hey Mark,

On 27-08-2013 05:29, Mark Rutland wrote:
> On Sat, Aug 24, 2013 at 12:15:42AM +0100, Eduardo Valentin wrote:
>> This patch changes the cpufreq-cpu0 driver to consider if
>> a cpu needs cooling (with cpufreq). In case the cooling is needed,
>> it can be flagged at the cpu0 device tree node, with the list
>> of zones property 'cooling-zones'.
>>
>> In case this list of zones is present, the driver will
>> load a cpufreq cooling device in the system. The cpufreq-cpu0
>> driver is not interested in determining how the system should
>> be using the cooling device. The driver is responsible
>> only of loading the cooling device.
>>
>> Describing how the cooling device will be used can be
>> accomplished by setting up a thermal zone that references
>> and is composed by the cpufreq cooling device.
>>
>> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
>> Cc: Viresh Kumar <viresh.kumar@linaro.org>
>> Cc: Grant Likely <grant.likely@linaro.org>
>> Cc: Rob Herring <rob.herring@calxeda.com>
>> Cc: cpufreq@vger.kernel.org
>> Cc: linux-pm@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Cc: devicetree-discuss@lists.ozlabs.org
>> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
>> ---
>>  Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt |  4 ++++
>>  drivers/cpufreq/cpufreq-cpu0.c                             | 12 +++++=
+++++++
>>  2 files changed, 16 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.tx=
t b/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt
>> index 051f764..add50f7 100644
>> --- a/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt
>> +++ b/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt
>> @@ -15,6 +15,9 @@ Optional properties:
>>  - clock-latency: Specify the possible maximum transition latency for =
clock,
>>    in unit of nanoseconds.
>>  - voltage-tolerance: Specify the CPU voltage tolerance in percentage.=

>> +- cooling-zones: A list of thermal zones phandles. The generic cpu
>> +  cooling (freq clipping) is loaded by the generic cpufreq-cpu0 drive=
r
>> +  in case the device tree node has this list.
>=20
> Bindings should not describe the behaviour of any kernel (and for that
> reason I'm not very keen on the current cpufreq-cpu0 binding document).=

>=20

Right.

> Bindings should simply describe the hardware. This addition could
> instead be:
>=20
>  - cooling-zones: a list of thermal zone phandles.
>=20

OK. This works for me.

> However, as the thermal zone binding doesn't seem to have appeared by
> this patch, it should get moved later anyway...

Yeah, I will reorder them.

>=20
> Thanks,
> Mark.
>=20
>> =20
>>  Examples:
>> =20
>> @@ -33,6 +36,7 @@ cpus {
>>  			198000  850000
>>  		>;
>>  		clock-latency =3D <61036>; /* two CLK32 periods */
>> +		cooling-zones =3D <&cpu_thermal>;
>>  	};
>> =20
>>  	cpu@1 {
>> diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-=
cpu0.c
>> index ad1fde2..ede6487 100644
>> --- a/drivers/cpufreq/cpufreq-cpu0.c
>> +++ b/drivers/cpufreq/cpufreq-cpu0.c
>> @@ -20,6 +20,9 @@
>>  #include <linux/platform_device.h>
>>  #include <linux/regulator/consumer.h>
>>  #include <linux/slab.h>
>> +#include <linux/thermal.h>
>> +#include <linux/cpu_cooling.h>
>> +#include <linux/cpumask.h>
>> =20
>>  static unsigned int transition_latency;
>>  static unsigned int voltage_tolerance; /* in percentage */
>> @@ -28,6 +31,7 @@ static struct device *cpu_dev;
>>  static struct clk *cpu_clk;
>>  static struct regulator *cpu_reg;
>>  static struct cpufreq_frequency_table *freq_table;
>> +static struct thermal_cooling_device *cdev;
>> =20
>>  static int cpu0_verify_speed(struct cpufreq_policy *policy)
>>  {
>> @@ -268,6 +272,13 @@ static int cpu0_cpufreq_probe(struct platform_dev=
ice *pdev)
>>  		goto out_free_table;
>>  	}
>> =20
>> +	/*
>> +	 * For now, just loading the cooling device;
>> +	 * thermal DT code takes care of matching them.
>> +	 */
>> +	if (of_find_property(np, "cooling-zones", NULL))
>> +		cdev =3D cpufreq_cooling_register(cpu_present_mask);
>> +
>>  	of_node_put(np);
>>  	of_node_put(parent);
>>  	return 0;
>> @@ -283,6 +294,7 @@ out_put_parent:
>> =20
>>  static int cpu0_cpufreq_remove(struct platform_device *pdev)
>>  {
>> +	cpufreq_cooling_unregister(cdev);
>>  	cpufreq_unregister_driver(&cpu0_cpufreq_driver);
>>  	opp_free_cpufreq_table(cpu_dev, &freq_table);
>> =20
>> --=20
>> 1.8.2.1.342.gfa7285d
>>
>>
>=20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--dEF9eMqXhooVnkhejDaH0qBEGe22GqquO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlIcpC8ACgkQCXcVR3XQvP2UWwD/Uc/7/BMsPH+BLxQhO029UPkY
COUU5OzGeUCHWYTBq1oA/jri/5Iz8kwhmlDmWV5foCvNs3nwIPUB1GypnW39oHqs
=7l2Y
-----END PGP SIGNATURE-----

--dEF9eMqXhooVnkhejDaH0qBEGe22GqquO--
