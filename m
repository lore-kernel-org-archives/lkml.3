Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932449AbaKUPnr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 10:43:47 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:58924 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085AbaKUPno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 10:43:44 -0500
Date: Thu, 20 Nov 2014 22:47:10 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincenzo Frascino <vincenzo.frascino@st.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Nobuhiro Iwamatsu <iwamatsu@nigauri.org>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] thermal:cpu cooling:fix: Provide thermal core fixes
 with deferred probe for several drivers
Message-ID: <20141121024704.GA19028@developer>
References: <1411547232-21493-1-git-send-email-l.majewski@samsung.com>
 <1415898165-27406-1-git-send-email-l.majewski@samsung.com>
 <20141120185420.GA26794@developer>
 <20141121093348.456545c3@amdc2363>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline
In-Reply-To: <20141121093348.456545c3@amdc2363>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Lukasz,

On Fri, Nov 21, 2014 at 09:33:48AM +0100, Lukasz Majewski wrote:
> Hi Eduardo,
>=20
> > Lukasz,
> >=20
> > Thanks for the keeping this up. And apologize for late answer.
>=20
> I've already posted v2 of this patch set (which consists of only one
> patch :-) ).
>=20
> Thanks to Thierry Reding's hint, I've realized that I don't need to add
> code from patches 1-6 from v1.
>=20
> Please instead review following patch:
> "thermal:core:fix: Check return code of the ->get_max_state() callback"
> https://patchwork.kernel.org/patch/5326991/

I see. If I got correctly, with the above patch, we still need to have
the check for cpufreq driver in the thermal driver right?
quoting:
"In thermal driver probe the cpufreq_cooling_register() method presence
  is crucial to evaluate if the thermal driver needs any actions with=20
    -EPROBE_DEFER."

If yes, that means the proposal still leaves to drivers to deal with
the sequencing. For the patch above, I believe it is fine. However, a
better sequencing is still needed :-(.=20

For the case of of-thermal based drivers, it should be dealt between
cpu_cooling and cpufreq, as I proposed, bellow. I really agree that
drivers should not care about this, and thus we should not spread the
check among drivers, specially if there is nothing regarding cpufreq in
the driver's code. I might send the proposal of having the check between
cpu_cooling and cpufreq as a formal patch, in a separated thread.

I will have a look in your v2. Briefly looking, looks reasonable.


Once again, thanks.

Cheers,

Eduardo Valentin

>=20
>=20
> >=20
> > On Thu, Nov 13, 2014 at 06:02:37PM +0100, Lukasz Majewski wrote:
> > > Presented fixes are a response for problem described below:
> > > http://thread.gmane.org/gmane.linux.kernel/1793821/match=3Dthermal+co=
re+fix+initialize+max_state+variable+0
> > >=20
> > > In short - it turned out that two trivial fixes (included in this
> > > patch set) require support for deferred probe in thermal drivers.
> > >=20
> > > This situation shows up when CPU frequency reduction is used as a
> > > thermal cooling device for a thermal zone.
> > > It happens that during initialization, the call to thermal probe
> > > will be executed before cpufreq probe (it can be observed
> > > at ./drivers/Makefile). In such a situation thermal will not be
> > > properly configured until cpufreq policy is setup.
> > >=20
> > > In the current code (without included fixes) there is a time window
> > > in which thermal can try to use not configured cpufreq and possibly
> > > crash the system.
> > >=20
> > >=20
> > > Proposed solution was based on the code already available in the
> > > imx_thermal.c file.
> > >=20
> > > /db8500_thermal.c:                      -> NOT NEEDED
> > > /intel_powerclamp.c:                    -> NOT NEEDED - INTEL (x86)
> > > /intel_powerclamp.c:                    -> NOT NEEDED - INTEL (x86)
> > > /ti-soc-thermal/ti-bandgap.c:           -> FIXED
> > > [omap2plus_defconfig] /dove_thermal.c:                        ->
> > > NOT NEEDED - CPU_COOLING NOT AVAILABLE [dove_defconfig]
> > > /spear_thermal.c:                       -> FIXED
> > > [spear3xx_defconfig] /samsung/exynos_tmu.c:                  -> NOT
> > > NEEDED (nasty hack - will be reworked in later
> > > patches) /imx_thermal.c:                         -> OK (deferred
> > > probe already in place) /int340x_thermal/int3402_thermal.c:     ->
> > > NOT NEEDED - ACPI x86 - Intel
> > > specific /int340x_thermal/int3400_thermal.c:     -> NOT NEEDED -
> > > ACPI x86 - Intel specific /tegra_soctherm.c:
> > > -> FIXED  [tegra_defconfig] /kirkwood_thermal.c:
> > > -> FIXED
> > > [multi_v5_defconfig] /armada_thermal.c:                      ->
> > > FIXED  [multi_v7_defconfig] /rcar_thermal.c:
> > > -> FIXED
> > > [shmobile_defconfig] /db8500_cpufreq_cooling.c:              -> OK
> > > (deferred probe already in place)
> > > [multi_v7_defconfig] /st/st_thermal_syscfg.c:                -> NOT
> > > NEEDED (Those two are enabled by e.g.
> > > ARMADA) /st/st_thermal_memmap.c:
> > >=20
> > >=20
> >=20
> >=20
> > Instead of doing the same check on all drivers in the need for cpu
> > cooling looks like a promiscuous solution. What if we do this check in
> > cpu cooling itself and we propagate the error in callers code?=20
> >=20
> > From what I see, only exynos does not propagate the error. And we
> > would need a tweak in the cpufreq-dt code. Something like the
> > following (not tested):
> >=20
> > diff --git a/drivers/cpufreq/cpufreq-dt.c
> > b/drivers/cpufreq/cpufreq-dt.c index f657c57..f139247 100644
> > --- a/drivers/cpufreq/cpufreq-dt.c
> > +++ b/drivers/cpufreq/cpufreq-dt.c
> > @@ -181,7 +181,6 @@ static int cpufreq_init(struct cpufreq_policy
> > *policy) {
> >  	struct cpufreq_dt_platform_data *pd;
> >  	struct cpufreq_frequency_table *freq_table;
> > -	struct thermal_cooling_device *cdev;
> >  	struct device_node *np;
> >  	struct private_data *priv;
> >  	struct device *cpu_dev;
> > @@ -264,20 +263,6 @@ static int cpufreq_init(struct cpufreq_policy
> > *policy) goto out_free_priv;
> >  	}
> > =20
> > -	/*
> > -	 * For now, just loading the cooling device;
> > -	 * thermal DT code takes care of matching them.
> > -	 */
> > -	if (of_find_property(np, "#cooling-cells", NULL)) {
> > -		cdev =3D of_cpufreq_cooling_register(np,
> > cpu_present_mask);
> > -		if (IS_ERR(cdev))
> > -			dev_err(cpu_dev,
> > -				"running cpufreq without cooling
> > device: %ld\n",
> > -				PTR_ERR(cdev));
> > -		else
> > -			priv->cdev =3D cdev;
> > -	}
> > -
> >  	priv->cpu_dev =3D cpu_dev;
> >  	priv->cpu_reg =3D cpu_reg;
> >  	policy->driver_data =3D priv;
> > @@ -287,7 +272,7 @@ static int cpufreq_init(struct cpufreq_policy
> > *policy) if (ret) {
> >  		dev_err(cpu_dev, "%s: invalid frequency table:
> > %d\n", __func__, ret);
> > -		goto out_cooling_unregister;
> > +		goto free_table;
> >  	}
> > =20
> >  	policy->cpuinfo.transition_latency =3D transition_latency;
> > @@ -300,8 +285,7 @@ static int cpufreq_init(struct cpufreq_policy
> > *policy)=20
> >  	return 0;
> > =20
> > -out_cooling_unregister:
> > -	cpufreq_cooling_unregister(priv->cdev);
> > +free_table:
> >  	dev_pm_opp_free_cpufreq_table(cpu_dev, &freq_table);
> >  out_free_priv:
> >  	kfree(priv);
> > @@ -342,11 +326,14 @@ static struct cpufreq_driver dt_cpufreq_driver
> > =3D {=20
> >  static int dt_cpufreq_probe(struct platform_device *pdev)
> >  {
> > +	struct device_node *np;
> >  	struct device *cpu_dev;
> >  	struct regulator *cpu_reg;
> >  	struct clk *cpu_clk;
> >  	int ret;
> > =20
> > +	/* at this point we checked the pointer already right? */
> > +	np =3D of_node_get(pdev->dev.of_node);
> >  	/*
> >  	 * All per-cluster (CPUs sharing clock/voltages)
> > initialization is done
> >  	 * from ->init(). In probe(), we just need to make sure that
> > clk and @@ -368,6 +355,28 @@ static int dt_cpufreq_probe(struct
> > platform_device *pdev) if (ret)
> >  		dev_err(cpu_dev, "failed register driver: %d\n",
> > ret);=20
> > +	/*
> > +	 * For now, just loading the cooling device;
> > +	 * thermal DT code takes care of matching them.
> > +	 */
> > +	if (of_find_property(np, "#cooling-cells", NULL)) {
> > +		struct cpufreq_policy policy;
> > +		struct private_data *priv;
> > +		struct thermal_cooling_device *cdev;
> > +
> > +		/* TODO: can cpu0 be always used ? */
> > +		cpufreq_get_policy(&policy, 0);
> > +		priv =3D policy.driver_data;
> > +		cdev =3D of_cpufreq_cooling_register(np,
> > cpu_present_mask);
> > +		if (IS_ERR(cdev))
> > +			dev_err(cpu_dev,
> > +				"running cpufreq without cooling
> > device: %ld\n",
> > +				PTR_ERR(cdev));
> > +		else
> > +			priv->cdev =3D cdev;
> > +	}
> > +	of_node_put(np);
> > +
> >  	return ret;
> >  }
> > =20
> > diff --git a/drivers/thermal/cpu_cooling.c
> > b/drivers/thermal/cpu_cooling.c index 1ab0018..342eb9e 100644
> > --- a/drivers/thermal/cpu_cooling.c
> > +++ b/drivers/thermal/cpu_cooling.c
> > @@ -440,6 +440,11 @@ __cpufreq_cooling_register(struct device_node
> > *np, int ret =3D 0, i;
> >  	struct cpufreq_policy policy;
> > =20
> > +	if (!cpufreq_get_current_driver()) {
> > +		dev_warn(&pdev->dev, "no cpufreq driver,
> > deferring.");
> > +		return -EPROBE_DEFER;
> > +	}
> > +
> >  	/* Verify that all the clip cpus have same freq_min,
> > freq_max limit */ for_each_cpu(i, clip_cpus) {
> >  		/* continue if cpufreq policy not found and not
> > return error */ diff --git
> > a/drivers/thermal/samsung/exynos_thermal_common.c
> > b/drivers/thermal/samsung/exynos_thermal_common.c index
> > 3f5ad25..f84975e 100644 ---
> > a/drivers/thermal/samsung/exynos_thermal_common.c +++
> > b/drivers/thermal/samsung/exynos_thermal_common.c @@ -373,7 +373,7 @@
> > int exynos_register_thermal(struct thermal_sensor_conf *sensor_conf)
> > if (IS_ERR(th_zone->cool_dev[th_zone->cool_dev_size]))
> > { dev_err(sensor_conf->dev, "Failed to register cpufreq cooling
> > device\n");
> > -			ret =3D -EINVAL;
> > +			ret =3D
> > PTR_ERR(th_zone->cool_dev[th_zone->cool_dev_size]); goto
> > err_unregister; }
> >  		th_zone->cool_dev_size++;
> >=20
> >=20
> > The above way, we avoid having same test in every driver that needs
> > it. Besides, it makes sense the cpu_cooling code takes care of this
> > check, as it is the very first part that has direct dependency with
> > cpufreq.
> >=20
> > > I only possess Exynos boards and Beagle Bone Black, so I'd be
> > > grateful for testing proposed solution on other boards. The posted
> > > code is compile tested.
> > >=20
> > > This code applies on Eduardo's ti-soc-thermal-next tree:
> > > SHA1: 208a97042d66d9bfbcfab0d4a00c9fe317bb73d3
> > >=20
> > > Lukasz Majewski (8):
> > >   thermal:cpu cooling:armada: Provide deferred probing for armada
> > > driver thermal:cpu cooling:kirkwood: Provide deferred probing for
> > > kirkwood driver
> > >   thermal:cpu cooling:rcar: Provide deferred probing for rcar driver
> > >   thermal:cpu cooling:spear: Provide deferred probing for spear
> > > driver thermal:cpu cooling:tegra: Provide deferred probing for
> > > tegra driver thermal:cpu cooling:ti: Provide deferred probing for
> > > ti drivers thermal:core:fix: Initialize the max_state variable to 0
> > >   thermal:core:fix: Check return code of the ->get_max_state()
> > > callback
> > >=20
> > >  drivers/thermal/armada_thermal.c            | 7 +++++++
> > >  drivers/thermal/kirkwood_thermal.c          | 7 +++++++
> > >  drivers/thermal/rcar_thermal.c              | 7 +++++++
> > >  drivers/thermal/spear_thermal.c             | 7 +++++++
> > >  drivers/thermal/tegra_soctherm.c            | 7 +++++++
> > >  drivers/thermal/thermal_core.c              | 8 +++++---
> > >  drivers/thermal/ti-soc-thermal/ti-bandgap.c | 7 +++++++
> > >  7 files changed, 47 insertions(+), 3 deletions(-)
> > >=20
> > > --=20
> > > 2.0.0.rc2
> > >=20
>=20
>=20
>=20
> --=20
> Best regards,
>=20
> Lukasz Majewski
>=20
> Samsung R&D Institute Poland (SRPOL) | Linux Platform Group

--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUbqeZAAoJEMLUO4d9pOJWTn0H/j7gISOg9dSJ5QzFzbvkS3BN
BObgkGAwERGjTCzPus7iyK+oZiCioQC7LMEXqoI7aJ+oUWD3vp94lInd1i1YDGj7
xpDzmgCIS8nE+NYB4FiSEznZhI2fPEuLBNGvnVRNFiFzDs6HxgoylHFtGaUQldpi
tFV7uXrvDqAvunegQNguP+Q7EahKhUQAZoXwC15F+xT+7UneqgK99Mtg3Mfs3k//
CeIsehdKI//6VYQmoS6C0StTa6iPr6J+QCqH/VtHrw/SN7R3Qm/LKm/eKmSj8Zjg
WvSGfTwOvpZLwcr10IyGLRYSQXh7NVWwIUfZIpsSkDt9H3W9uZ2yyoiAG8V8Gvo=
=Qv82
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--
