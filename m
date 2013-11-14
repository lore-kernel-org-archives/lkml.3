Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559Ab3KNNSz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 08:18:55 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:44987 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753068Ab3KNNSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 08:18:46 -0500
Message-ID: <5284CD61.3000302@ti.com>
Date: Thu, 14 Nov 2013 09:17:21 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Eduardo Valentin <eduardo.valentin@ti.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
CC: <swarren@wwwdotorg.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ian.campbell@citrix.com>, <rob.herring@calxeda.com>,
        <linux@roeck-us.net>, <rui.zhang@intel.com>, <wni@nvidia.com>,
        <grant.likely@linaro.org>, <durgadoss.r@intel.com>,
        <linux-pm@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>, <cpufreq@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCHv5 05/20] cpufreq: cpufreq-cpu0: add dt node parsing for
 cooling device properties
References: <1384285582-16933-1-git-send-email-eduardo.valentin@ti.com> <1384285582-16933-6-git-send-email-eduardo.valentin@ti.com>
In-Reply-To: <1384285582-16933-6-git-send-email-eduardo.valentin@ti.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="5b8N1TKPpElctraVGCk8rBFL5nSOMVFJo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--5b8N1TKPpElctraVGCk8rBFL5nSOMVFJo
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12-11-2013 15:46, Eduardo Valentin wrote:
> This patch changes the cpufreq-cpu0 driver to consider if
> a cpu needs cooling (with cpufreq). In case the cooling is needed,
> the cpu0 device tree node needs to be properly configured
> with cooling device properties.
>=20
> In case these properties are present,, the driver will
> load a cpufreq cooling device in the system. The cpufreq-cpu0
> driver is not interested in determining how the system should
> be using the cooling device. The driver is responsible
> only of loading the cooling device.
>=20
> Describing how the cooling device will be used can be
> accomplished by setting up a thermal zone that references
> and is composed by the cpufreq cooling device.
>=20
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>

Rafael, Can I still assume you are OK with this patch and add your
acked-by [1]?
http://www.spinics.net/lists/lm-sensors/msg39136.html

It has changed a few bits from V1 to here. The idea is still same though.=


> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: cpufreq@vger.kernel.org
> Cc: linux-pm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: devicetree-discuss@lists.ozlabs.org
> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
> ---
>  .../devicetree/bindings/cpufreq/cpufreq-cpu0.txt         |  7 +++++++
>  drivers/cpufreq/Kconfig                                  |  2 +-
>  drivers/cpufreq/cpufreq-cpu0.c                           | 16 ++++++++=
++++++++
>  3 files changed, 24 insertions(+), 1 deletion(-)
>=20
> diff --git a/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt=
 b/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt
> index 051f764..f055515 100644
> --- a/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt
> +++ b/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt
> @@ -15,6 +15,10 @@ Optional properties:
>  - clock-latency: Specify the possible maximum transition latency for c=
lock,
>    in unit of nanoseconds.
>  - voltage-tolerance: Specify the CPU voltage tolerance in percentage.
> +- #cooling-cells:
> +- cooling-min-level:
> +- cooling-max-level:
> +     Please refer to Documentation/devicetree/bindings/thermal/thermal=
=2Etxt.
> =20
>  Examples:
> =20
> @@ -33,6 +37,9 @@ cpus {
>  			198000  850000
>  		>;
>  		clock-latency =3D <61036>; /* two CLK32 periods */
> +		#cooling-cells =3D <2>;
> +		cooling-min-level =3D <0>;
> +		cooling-max-level =3D <2>;
>  	};
> =20
>  	cpu@1 {
> diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
> index 534fcb8..fc1e9a5 100644
> --- a/drivers/cpufreq/Kconfig
> +++ b/drivers/cpufreq/Kconfig
> @@ -186,7 +186,7 @@ config CPU_FREQ_GOV_CONSERVATIVE
> =20
>  config GENERIC_CPUFREQ_CPU0
>  	tristate "Generic CPU0 cpufreq driver"
> -	depends on HAVE_CLK && REGULATOR && PM_OPP && OF
> +	depends on HAVE_CLK && REGULATOR && PM_OPP && OF && THERMAL && CPU_TH=
ERMAL
>  	select CPU_FREQ_TABLE
>  	help
>  	  This adds a generic cpufreq driver for CPU0 frequency management.
> diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-c=
pu0.c
> index c522a95..568aaf3 100644
> --- a/drivers/cpufreq/cpufreq-cpu0.c
> +++ b/drivers/cpufreq/cpufreq-cpu0.c
> @@ -13,7 +13,9 @@
> =20
>  #include <linux/clk.h>
>  #include <linux/cpu.h>
> +#include <linux/cpu_cooling.h>
>  #include <linux/cpufreq.h>
> +#include <linux/cpumask.h>
>  #include <linux/err.h>
>  #include <linux/module.h>
>  #include <linux/of.h>
> @@ -21,6 +23,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/regulator/consumer.h>
>  #include <linux/slab.h>
> +#include <linux/thermal.h>
> =20
>  static unsigned int transition_latency;
>  static unsigned int voltage_tolerance; /* in percentage */
> @@ -29,6 +32,7 @@ static struct device *cpu_dev;
>  static struct clk *cpu_clk;
>  static struct regulator *cpu_reg;
>  static struct cpufreq_frequency_table *freq_table;
> +static struct thermal_cooling_device *cdev;
> =20
>  static int cpu0_verify_speed(struct cpufreq_policy *policy)
>  {
> @@ -260,6 +264,17 @@ static int cpu0_cpufreq_probe(struct platform_devi=
ce *pdev)
>  		goto out_free_table;
>  	}
> =20
> +	/*
> +	 * For now, just loading the cooling device;
> +	 * thermal DT code takes care of matching them.
> +	 */
> +	if (of_find_property(np, "#cooling-cells", NULL)) {
> +		cdev =3D of_cpufreq_cooling_register(np, cpu_present_mask);
> +		if (IS_ERR(cdev))
> +			pr_err("running cpufreq without cooling device: %ld\n",
> +			       PTR_ERR(cdev));
> +	}
> +
>  	of_node_put(np);
>  	return 0;
> =20
> @@ -272,6 +287,7 @@ out_put_node:
> =20
>  static int cpu0_cpufreq_remove(struct platform_device *pdev)
>  {
> +	cpufreq_cooling_unregister(cdev);
>  	cpufreq_unregister_driver(&cpu0_cpufreq_driver);
>  	opp_free_cpufreq_table(cpu_dev, &freq_table);
> =20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--5b8N1TKPpElctraVGCk8rBFL5nSOMVFJo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlKEzWIACgkQCXcVR3XQvP2LfwD/ZWtVvDNgk3ULqR8dyDmUBU5r
ITYDt5+hxVkRX0KX15kA+gKKmrs9en3Evh4z3D6cfhX+gqPFuy0UqjboXss2hW+3
=o+YS
-----END PGP SIGNATURE-----

--5b8N1TKPpElctraVGCk8rBFL5nSOMVFJo--
