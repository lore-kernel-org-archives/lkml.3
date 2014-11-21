Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932486AbaKUQ2Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 11:28:16 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:32181 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932347AbaKUQ2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 11:28:13 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-01-546f681b570b
Date: Fri, 21 Nov 2014 17:28:02 +0100
From: Lukasz Majewski <l.majewski@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
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
Message-id: <20141121172802.2e7e1352@amdc2363>
In-reply-to: <20141121024704.GA19028@developer>
References: <1411547232-21493-1-git-send-email-l.majewski@samsung.com>
 <1415898165-27406-1-git-send-email-l.majewski@samsung.com>
 <20141120185420.GA26794@developer> <20141121093348.456545c3@amdc2363>
 <20141121024704.GA19028@developer>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNIsWRmVeSWpSXmKPExsVy+t9jAV3pjPwQg8ZH3BYbZ6xntZh/5Rqr
	xelTC1gtzr16xGLxtrnY4tXhXYwWb4AKLu+aw2bxufcIo0Xnl1lsFg+uTmOzePKwj83i1cE2
	Foufu+axWBw7MYPVgd/jyaaLjB47Z91l91i85yWTx7ppb5k9Dkw+x+rR2/yOzePbmYksHn1b
	VjF6PP2xl9nj8yY5j41zQwO4o7hsUlJzMstSi/TtErgy5m0/xl7wNani6u8VrA2M07y7GDk4
	JARMJDb2c3UxcgKZYhIX7q1n62Lk4hASWMQocfH/JyYI5xejxPVHExlBqlgEVCXundrMDGKz
	CehJfL77lAnEFhHQkjhxaTtYA7PAExaJPfNmsYJsEBYok1i/Iwmkhheo/mxfFyuIzSmgL7G2
	aRkrxIIPjBK7d+8DG8ovICnR/u8HM8RJdhLnPm1gh2gWlPgx+R4LiM0MtGzztiZWCFteYvOa
	t8wTGAVnISmbhaRsFpKyBYzMqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCo/CZ9A7GVQ0W
	hxgFOBiVeHg/TM8LEWJNLCuuzD3EKMHBrCTCWy6cHyLEm5JYWZValB9fVJqTWnyIUZqDRUmc
	98bN3BAhgfTEktTs1NSC1CKYLBMHp1QDI09UvnHMtaQF3D/mbRe8xDvJs4J73zfBeTaCpSmz
	/jWv3bXrTvit1mXfFxd7hzBxTuP07ErKDWrkmv25dbekQzfz1++fmF4bXIk9fc1CTrHjfVdZ
	3g6mFTv3cnpJd9zd2vFmI9/CjxP/sby41DZRR/nJUeHPIhEvc/oOFrNkRp0O/5vct4rNTIml
	OCPRUIu5qDgRAJl2BUa+AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduardo,

> Lukasz,
> 
> On Fri, Nov 21, 2014 at 09:33:48AM +0100, Lukasz Majewski wrote:
> > Hi Eduardo,
> > 
> > > Lukasz,
> > > 
> > > Thanks for the keeping this up. And apologize for late answer.
> > 
> > I've already posted v2 of this patch set (which consists of only one
> > patch :-) ).
> > 
> > Thanks to Thierry Reding's hint, I've realized that I don't need to
> > add code from patches 1-6 from v1.
> > 
> > Please instead review following patch:
> > "thermal:core:fix: Check return code of the ->get_max_state()
> > callback" https://patchwork.kernel.org/patch/5326991/
> 
> I see. If I got correctly, with the above patch, we still need to have
> the check for cpufreq driver in the thermal driver right?
> quoting:
> "In thermal driver probe the cpufreq_cooling_register() method
> presence is crucial to evaluate if the thermal driver needs any
> actions with -EPROBE_DEFER."

Yes we need those checks in thermal drivers. However, proper checks are
already in place - please look into imx_thermal.c case.

> 
> If yes, that means the proposal still leaves to drivers to deal with
> the sequencing. For the patch above, I believe it is fine. However, a
> better sequencing is still needed :-(. 

There is always a trade off. What I've shown in v2 is that I'm pretty
confident that my fix won't introduce any regression for present code.

> 
> For the case of of-thermal based drivers, it should be dealt between
> cpu_cooling and cpufreq, as I proposed, bellow. I really agree that
> drivers should not care about this, and thus we should not spread the
> check among drivers,

Unfortunately several checks are already in place (imx_thermal.c,
db8500_cpufreq.c, ti-soc*.c, in some way the old Exynos thermal driver).

> specially if there is nothing regarding cpufreq
> in the driver's code. 

There is a call to cpufreq_cooling_register(), which sometimes happens
in the late part of probe function. In such a case it would be quite
challenging to release already allocated resources (e.g. ti, old
Exynos driver).

> I might send the proposal of having the check
> between cpu_cooling and cpufreq as a formal patch, in a separated
> thread.

It would be beneficial to hear Viresh's opinion.

> 
> I will have a look in your v2. Briefly looking, looks reasonable.

In short: The goal of this patch is to show that regressions should not
happen and that it can be safely applied for v3.19.

> 
> 
> Once again, thanks.
> 
> Cheers,
> 
> Eduardo Valentin
> 
> > 
> > 
> > > 
> > > On Thu, Nov 13, 2014 at 06:02:37PM +0100, Lukasz Majewski wrote:
> > > > Presented fixes are a response for problem described below:
> > > > http://thread.gmane.org/gmane.linux.kernel/1793821/match=thermal+core+fix+initialize+max_state+variable+0
> > > > 
> > > > In short - it turned out that two trivial fixes (included in
> > > > this patch set) require support for deferred probe in thermal
> > > > drivers.
> > > > 
> > > > This situation shows up when CPU frequency reduction is used as
> > > > a thermal cooling device for a thermal zone.
> > > > It happens that during initialization, the call to thermal probe
> > > > will be executed before cpufreq probe (it can be observed
> > > > at ./drivers/Makefile). In such a situation thermal will not be
> > > > properly configured until cpufreq policy is setup.
> > > > 
> > > > In the current code (without included fixes) there is a time
> > > > window in which thermal can try to use not configured cpufreq
> > > > and possibly crash the system.
> > > > 
> > > > 
> > > > Proposed solution was based on the code already available in the
> > > > imx_thermal.c file.
> > > > 
> > > > /db8500_thermal.c:                      -> NOT NEEDED
> > > > /intel_powerclamp.c:                    -> NOT NEEDED - INTEL
> > > > (x86) /intel_powerclamp.c:                    -> NOT NEEDED -
> > > > INTEL (x86) /ti-soc-thermal/ti-bandgap.c:           -> FIXED
> > > > [omap2plus_defconfig] /dove_thermal.c:                        ->
> > > > NOT NEEDED - CPU_COOLING NOT AVAILABLE [dove_defconfig]
> > > > /spear_thermal.c:                       -> FIXED
> > > > [spear3xx_defconfig] /samsung/exynos_tmu.c:                  ->
> > > > NOT NEEDED (nasty hack - will be reworked in later
> > > > patches) /imx_thermal.c:                         -> OK (deferred
> > > > probe already in place) /int340x_thermal/int3402_thermal.c:
> > > > -> NOT NEEDED - ACPI x86 - Intel
> > > > specific /int340x_thermal/int3400_thermal.c:     -> NOT NEEDED -
> > > > ACPI x86 - Intel specific /tegra_soctherm.c:
> > > > -> FIXED  [tegra_defconfig] /kirkwood_thermal.c:
> > > > -> FIXED
> > > > [multi_v5_defconfig] /armada_thermal.c:                      ->
> > > > FIXED  [multi_v7_defconfig] /rcar_thermal.c:
> > > > -> FIXED
> > > > [shmobile_defconfig] /db8500_cpufreq_cooling.c:              ->
> > > > OK (deferred probe already in place)
> > > > [multi_v7_defconfig] /st/st_thermal_syscfg.c:                ->
> > > > NOT NEEDED (Those two are enabled by e.g.
> > > > ARMADA) /st/st_thermal_memmap.c:
> > > > 
> > > > 
> > > 
> > > 
> > > Instead of doing the same check on all drivers in the need for cpu
> > > cooling looks like a promiscuous solution. What if we do this
> > > check in cpu cooling itself and we propagate the error in callers
> > > code? 
> > > 
> > > From what I see, only exynos does not propagate the error. And we
> > > would need a tweak in the cpufreq-dt code. Something like the
> > > following (not tested):
> > > 
> > > diff --git a/drivers/cpufreq/cpufreq-dt.c
> > > b/drivers/cpufreq/cpufreq-dt.c index f657c57..f139247 100644
> > > --- a/drivers/cpufreq/cpufreq-dt.c
> > > +++ b/drivers/cpufreq/cpufreq-dt.c
> > > @@ -181,7 +181,6 @@ static int cpufreq_init(struct cpufreq_policy
> > > *policy) {
> > >  	struct cpufreq_dt_platform_data *pd;
> > >  	struct cpufreq_frequency_table *freq_table;
> > > -	struct thermal_cooling_device *cdev;
> > >  	struct device_node *np;
> > >  	struct private_data *priv;
> > >  	struct device *cpu_dev;
> > > @@ -264,20 +263,6 @@ static int cpufreq_init(struct cpufreq_policy
> > > *policy) goto out_free_priv;
> > >  	}
> > >  
> > > -	/*
> > > -	 * For now, just loading the cooling device;
> > > -	 * thermal DT code takes care of matching them.
> > > -	 */
> > > -	if (of_find_property(np, "#cooling-cells", NULL)) {
> > > -		cdev = of_cpufreq_cooling_register(np,
> > > cpu_present_mask);
> > > -		if (IS_ERR(cdev))
> > > -			dev_err(cpu_dev,
> > > -				"running cpufreq without cooling
> > > device: %ld\n",
> > > -				PTR_ERR(cdev));
> > > -		else
> > > -			priv->cdev = cdev;
> > > -	}
> > > -
> > >  	priv->cpu_dev = cpu_dev;
> > >  	priv->cpu_reg = cpu_reg;
> > >  	policy->driver_data = priv;
> > > @@ -287,7 +272,7 @@ static int cpufreq_init(struct cpufreq_policy
> > > *policy) if (ret) {
> > >  		dev_err(cpu_dev, "%s: invalid frequency table:
> > > %d\n", __func__, ret);
> > > -		goto out_cooling_unregister;
> > > +		goto free_table;
> > >  	}
> > >  
> > >  	policy->cpuinfo.transition_latency = transition_latency;
> > > @@ -300,8 +285,7 @@ static int cpufreq_init(struct cpufreq_policy
> > > *policy) 
> > >  	return 0;
> > >  
> > > -out_cooling_unregister:
> > > -	cpufreq_cooling_unregister(priv->cdev);
> > > +free_table:
> > >  	dev_pm_opp_free_cpufreq_table(cpu_dev, &freq_table);
> > >  out_free_priv:
> > >  	kfree(priv);
> > > @@ -342,11 +326,14 @@ static struct cpufreq_driver
> > > dt_cpufreq_driver = { 
> > >  static int dt_cpufreq_probe(struct platform_device *pdev)
> > >  {
> > > +	struct device_node *np;
> > >  	struct device *cpu_dev;
> > >  	struct regulator *cpu_reg;
> > >  	struct clk *cpu_clk;
> > >  	int ret;
> > >  
> > > +	/* at this point we checked the pointer already right? */
> > > +	np = of_node_get(pdev->dev.of_node);
> > >  	/*
> > >  	 * All per-cluster (CPUs sharing clock/voltages)
> > > initialization is done
> > >  	 * from ->init(). In probe(), we just need to make sure
> > > that clk and @@ -368,6 +355,28 @@ static int
> > > dt_cpufreq_probe(struct platform_device *pdev) if (ret)
> > >  		dev_err(cpu_dev, "failed register driver: %d\n",
> > > ret); 
> > > +	/*
> > > +	 * For now, just loading the cooling device;
> > > +	 * thermal DT code takes care of matching them.
> > > +	 */
> > > +	if (of_find_property(np, "#cooling-cells", NULL)) {
> > > +		struct cpufreq_policy policy;
> > > +		struct private_data *priv;
> > > +		struct thermal_cooling_device *cdev;
> > > +
> > > +		/* TODO: can cpu0 be always used ? */
> > > +		cpufreq_get_policy(&policy, 0);
> > > +		priv = policy.driver_data;
> > > +		cdev = of_cpufreq_cooling_register(np,
> > > cpu_present_mask);
> > > +		if (IS_ERR(cdev))
> > > +			dev_err(cpu_dev,
> > > +				"running cpufreq without cooling
> > > device: %ld\n",
> > > +				PTR_ERR(cdev));
> > > +		else
> > > +			priv->cdev = cdev;
> > > +	}
> > > +	of_node_put(np);
> > > +
> > >  	return ret;
> > >  }
> > >  
> > > diff --git a/drivers/thermal/cpu_cooling.c
> > > b/drivers/thermal/cpu_cooling.c index 1ab0018..342eb9e 100644
> > > --- a/drivers/thermal/cpu_cooling.c
> > > +++ b/drivers/thermal/cpu_cooling.c
> > > @@ -440,6 +440,11 @@ __cpufreq_cooling_register(struct device_node
> > > *np, int ret = 0, i;
> > >  	struct cpufreq_policy policy;
> > >  
> > > +	if (!cpufreq_get_current_driver()) {
> > > +		dev_warn(&pdev->dev, "no cpufreq driver,
> > > deferring.");
> > > +		return -EPROBE_DEFER;
> > > +	}
> > > +
> > >  	/* Verify that all the clip cpus have same freq_min,
> > > freq_max limit */ for_each_cpu(i, clip_cpus) {
> > >  		/* continue if cpufreq policy not found and not
> > > return error */ diff --git
> > > a/drivers/thermal/samsung/exynos_thermal_common.c
> > > b/drivers/thermal/samsung/exynos_thermal_common.c index
> > > 3f5ad25..f84975e 100644 ---
> > > a/drivers/thermal/samsung/exynos_thermal_common.c +++
> > > b/drivers/thermal/samsung/exynos_thermal_common.c @@ -373,7
> > > +373,7 @@ int exynos_register_thermal(struct thermal_sensor_conf
> > > *sensor_conf) if
> > > (IS_ERR(th_zone->cool_dev[th_zone->cool_dev_size]))
> > > { dev_err(sensor_conf->dev, "Failed to register cpufreq cooling
> > > device\n");
> > > -			ret = -EINVAL;
> > > +			ret =
> > > PTR_ERR(th_zone->cool_dev[th_zone->cool_dev_size]); goto
> > > err_unregister; }
> > >  		th_zone->cool_dev_size++;
> > > 
> > > 
> > > The above way, we avoid having same test in every driver that
> > > needs it. Besides, it makes sense the cpu_cooling code takes care
> > > of this check, as it is the very first part that has direct
> > > dependency with cpufreq.
> > > 
> > > > I only possess Exynos boards and Beagle Bone Black, so I'd be
> > > > grateful for testing proposed solution on other boards. The
> > > > posted code is compile tested.
> > > > 
> > > > This code applies on Eduardo's ti-soc-thermal-next tree:
> > > > SHA1: 208a97042d66d9bfbcfab0d4a00c9fe317bb73d3
> > > > 
> > > > Lukasz Majewski (8):
> > > >   thermal:cpu cooling:armada: Provide deferred probing for
> > > > armada driver thermal:cpu cooling:kirkwood: Provide deferred
> > > > probing for kirkwood driver
> > > >   thermal:cpu cooling:rcar: Provide deferred probing for rcar
> > > > driver thermal:cpu cooling:spear: Provide deferred probing for
> > > > spear driver thermal:cpu cooling:tegra: Provide deferred
> > > > probing for tegra driver thermal:cpu cooling:ti: Provide
> > > > deferred probing for ti drivers thermal:core:fix: Initialize
> > > > the max_state variable to 0 thermal:core:fix: Check return code
> > > > of the ->get_max_state() callback
> > > > 
> > > >  drivers/thermal/armada_thermal.c            | 7 +++++++
> > > >  drivers/thermal/kirkwood_thermal.c          | 7 +++++++
> > > >  drivers/thermal/rcar_thermal.c              | 7 +++++++
> > > >  drivers/thermal/spear_thermal.c             | 7 +++++++
> > > >  drivers/thermal/tegra_soctherm.c            | 7 +++++++
> > > >  drivers/thermal/thermal_core.c              | 8 +++++---
> > > >  drivers/thermal/ti-soc-thermal/ti-bandgap.c | 7 +++++++
> > > >  7 files changed, 47 insertions(+), 3 deletions(-)
> > > > 
> > > > -- 
> > > > 2.0.0.rc2
> > > > 
> > 
> > 
> > 
> > -- 
> > Best regards,
> > 
> > Lukasz Majewski
> > 
> > Samsung R&D Institute Poland (SRPOL) | Linux Platform Group



-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
