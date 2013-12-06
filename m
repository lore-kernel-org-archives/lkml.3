Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161649Ab3LFODW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 09:03:22 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:46171 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758387Ab3LFODP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 09:03:15 -0500
X-AuditID: cbfee61a-b7f796d000004313-59-52a1d921e1ea
Date: Fri, 06 Dec 2013 15:03:04 +0100
From: Lukasz Majewski <l.majewski@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Zhang Rui <rui.zhang@intel.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, durgadoss.r@intel.com,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Subject: Re: [PATCH v10 7/7] thermal:exynos:boost: Automatic enable/disable of
 BOOST feature (at Exynos4412)
Message-id: <20131206150304.00ad8233@amdc2363>
In-reply-to: <52A07EC3.5060002@ti.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1383672411-26324-1-git-send-email-l.majewski@samsung.com>
 <1383672411-26324-8-git-send-email-l.majewski@samsung.com>
 <529C9ED2.2060106@ti.com> <20131203083159.35895456@amdc2363>
 <529DD05E.1050402@ti.com> <20131203164214.3d4730f1@amdc2363>
 <529F37EA.9040503@ti.com> <20131205120349.50029a30@amdc2363>
 <52A07EC3.5060002@ti.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42I5/e+xgK7izYVBBjs3Klg0XA2x2DhjPavF
	06Yf7BZ9P68wW6zZ/5PJovPsE2aLN4+4LS7vmsNm8bn3CKPF7cYVbBZnTl9itXjysI/NYuNX
	Dwdej8V7XjJ53Lm2h81j3bS3zB5brrazePRtWcXocfzGdiaPz5vkAtijuGxSUnMyy1KL9O0S
	uDLOHbjPXLCloOLF7pnMDYxHIroYOTgkBEwkul/KdzFyApliEhfurWfrYuTiEBJYxChx9lI/
	C4Tzi1HiW+dPdpAqFgFViScLPrGA2GwCehKf7z5lArFFgOwbL54wgTQwC7SzSBw/8hksISyQ
	J3H6eAtYAy9Q0al3r5hBbE4BNYmHD9czQWyYwSwxaUs/2AZ+AUmJ9n8/mCFuspM492kDO0Sz
	oMSPyffABjELaEls3tbECmHLS2xe85Z5AqPgLCRls5CUzUJStoCReRWjaGpBckFxUnquoV5x
	Ym5xaV66XnJ+7iZGcCw9k9rBuLLB4hCjAAejEg8vx6oFQUKsiWXFlbmHGCU4mJVEeJfsWxgk
	xJuSWFmVWpQfX1Sak1p8iFGag0VJnPdAq3WgkEB6YklqdmpqQWoRTJaJg1OqgXFdj8M73qVR
	57d/v+uvqrhxhr5G+cFbadtEikUYOR8xb/5znuP8K6/TR7jcf4fMP61l+HYSq6aMVm3/l+At
	1j8LtneHFFY/ztzZqMmmHjv9Dkv81oK+9Ih/x+5frqlSzFgS7dX0/fXaqi/aXF1rzP/cn1Mm
	1/al2Oowf6b8BulXwb82zZ+vEq3EUpyRaKjFXFScCACYpORFoQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduardo,

> Hey Lukasz,
> 
> On 05-12-2013 07:03, Lukasz Majewski wrote:
> > Hi Eduardo,
> > 
> >> Hey Lukasz!,
> >>
> >> On 03-12-2013 11:42, Lukasz Majewski wrote:
> >>> Hi Eduardo,
> >>>
> >>>> On 03-12-2013 03:31, Lukasz Majewski wrote:
> >>>>> Hi Eduardo,
> >>>>>
> >>>>>> On 05-11-2013 13:26, Lukasz Majewski wrote:
> >>>>>>> This patch provides auto disable/enable operation for boost.
> >>>>>>> It uses already present thermal infrastructure to provide
> >>>>>>> boost hysteresis. A special set of TMU data has been defined
> >>>>>>> for Exynos4412, which is only considered when BOOST is
> >>>>>>> enabled.
> >>>>>>
> >>>>>> Can you please add more description why you need a different
> >>>>>> set of thermal data when boost is enabled? 
> >>>>>
> >>>>> It turned out that the Thermal subsystem (after rework done for
> >>>>> v3.12) is capable of providing hysteresis for BOOST.
> >>>>>
> >>>>
> >>>> So, the difference is only the hysteresis?
> >>>>
> >>>>> For version of the patch up to v8 I had to modify the thermal
> >>>>> core to provide such functionality. Changes in core weren't
> >>>>> accepted by Zhang Rui.
> >>>>
> >>>> Ok... But still I didn't get what you needed to modify and why..
> >>>> Sorry I jumped in the middle of ongoing discussion.
> >>>>
> >>>>>
> >>>>> Then I've looked again to the code and it turned out that proper
> >>>>> setting of Exynos4x12 data (like trigger levels and
> >>>>> freq_clip_max) can solve the problem in a much better way by
> >>>>> using Exynos thermal interrupts.
> >>>>> Another advantage is that those changes are done per device.
> >>>>>
> >>>>>> This is also important in case you
> >>>>>> (Exynos thermal folks) would like to migrate this driver to
> >>>>>> have thermal data support in DT.
> >>>>>
> >>>>> Some work on this driver is ongoing (mainly done by Bartek
> >>>>> Zolnierkiewicz). This BOOST change doesn't break anything and
> >>>>> only extend the current thermal code. Thereof it will not break
> >>>>> anything.
> >>>>
> >>>> Well, good that it does not break anything, right?
> >>>>
> >>>> But, My point, Lukasz, is that I am failing to understand, based
> >>>> on your patch and description why we need a different data
> >>>> definition, one for boost, other for without boost. Can you help
> >>>> me to get your intention with this patch properly?
> >>>
> >>> I reduce the trigger_level[0] and set new .freq_table[0] entry.
> >>> It works as follow (for BOOST):
> >>>
> >>> 1. Non-boost freq is 1.4 GHz on Exynos4412. BOOST is 1.5GHz. The
> >>> BOOST itself is enabled by CONFIG_CPU_FREQ_BOOST_SW. 
> >>>
> >>> 2. Exynos TMU driver reaches the lower TMU level (70 deg). Then
> >>> the core thermal looks for proper frequency table (.freq_tab[0]).
> >>> If the .temp_level matches the trigger_levels[0], then the
> >>> frequency is reduced to .freq_clip_max = 1400 * 1000. 
> >>>
> >>> When the device cools down to 60 deg (trigger_levels[0] -
> >>> threshold_falling), then the max freq is restored to 1.5 GHz. This
> >>> is done automatically by thermal core.
> >>>
> >>> For BOOST disabled we only can run with 1.4 GHz freq. For this
> >>> reason the freq_tab[X] entries must be modified. Also the Exynos
> >>> part of thermal requires that trigger_levels[0] is the lowest
> >>> temperature trip, so I cannot add the "BOOST disable" temp level
> >>> in the end of TMU_DATA_BOOST.
> >>
> >> OK. The entire thing is to allow dynamic control on your speedbin
> >> frequencies, I see.
> > 
> > Yes, correct.
> > 
> >> What bugs me, is that this themal driver keeps
> >> another table of frequencies. 
> > 
> > Yes, it does. It is the part of thermal_cooling_conf data. 
> > 
> > It is a very practical solution, since we can specify the threshold
> > temperature and corresponding maximal frequency (up to 8 values). 
> > 
> > Those values are afterwards used at exynos_bind to bind zone to
> > cooling device.
> > 
> >> Ideally, it should not care about it,
> > 
> > The above procedure is a part of passive cooling implementation for
> > Exynos.
> > 
> >> but about the thermal behavior changes, meaning, say, how fast your
> >> temperature rises, when you jump from lowest opp to 1.4GHz or
> >> 1.5GHz, on host process or cold process samples.
> > 
> > Could you be more specific here? I assume that you are asking if
> > slope of the temperature rise has been measured?
> > 
> > I didn't measure this value, since it depends on the work
> > environment (number of processes running, ambient temperature,
> > current SoC temperature, etc.) and thereof is hard to reproduce.
> > 
> > However, the exynos_thermal_common.c defines .get_trend callback.
> > Unfortunately it only gives an information about the trend (rising,
> > falling). The exact slope value is not given.
> > 
> > Personally I think, that the slope measurement is not relevant for
> > the BOOST.
> > 
> >>
> >>>
> >>>>
> >>>> Side question is what happens in runtime if user echo 0 > boost?
> >>>
> >>> As we had agreed with Rafael and Viresh, we are here mimic the HW
> >>> CPUs behaviour (like Intel CPU).
> >>
> >> Which is fine and expected.
> >>
> >>> When user writes 'echo 0 > boost' then at cpufreq core we switch
> >>> to max freq to 1.4 GHz.
> >>
> >> OK.
> >>
> >>>
> >>> Thermal here is only for safety reasons.  
> >>>
> >>>> Should we switch the data within the driver? 
> >>>
> >>> No. When one decides to enable CONFIG_CPU_FREQ_BOOST_SW, then
> >>> corresponding Exynos data are persistent. 
> >>>
> >>>> Would we be penalizing
> >>>> performance with strict hysteresis while we could be allowing
> >>>> longer periods of high frequency usage? 
> >>>
> >>> But the hysteresis shows up only for emergency - when we go out
> >>> from allowed power envelope.
> >>>
> >>> The BOOST is a component of LAB governor, which takes into account
> >>> the number of running cores. The "normal" BOOST use case is a
> >>> situation when at most two cores are running and other are down.
> >>> In this situation we can use BOOST to finish work faster.
> >>>
> >>>> See what I am missing? Maybe we
> >>>> actually need something else a part from defining one data
> >>>> structure for boost other for non-boost systems.
> >>>
> >>> I'm open for suggestions.
> >>>
> >>> The current proposal aims to change TMU data only for target SoC -
> >>> Exynos4412 in this case. I deliberately don't touch the thermal
> >>> core code.
> >>
> >>
> >> In fact, I see.
> >>
> >> I am just wondering if it makes sense to simply use the data that
> >> represents BOOST always. 
> >> Wouldn't be same as in the situation where
> >> user echo 0 > boost?
> > 
> > I think I get your point here. You would like to reuse the NON BOOST
> > value when user types echo 0 > boost.
> > 
> > The problem is that we would need some kind of notification from
> > cpufreq subsystem to thermal that such change was done. 
> > This seems like an overkill, and in my opinion it is better to
> > use thermal without such notification.
> > To be more specific, the thermal already implements the required
> > functionality and we "only" need to came up with an idea how to
> > appropriately feed data. 
> 
> Well, the real problem is that this driver relies on data structures
> that duplicates cpufreq data and thermal core data. So, every time you
> have a new speedbin frequency, you have to update at least two - three
> places to make sure everything is correct.

Exynos thermal driver exposes such API. It was quite straightforward to
use it for BOOST.

> 
> My point is not exactly that I am suggesting to reuse the non-boost
> data. My point is that temperature constraints do not change if you
> are using boost or non-boost frequencies. Your temperature trip
> points will be the same, because your silicon still is gonna start to
> break if cross the line. And that is what I mean when I say, the
> thermal driver should be aware of temperature constraints, not
> frequencies. At most, the cooling device should be aware of
> frequencies, not thermal driver.

Ok, I get it.

> 
> About the current patch proposal, still, would it work if you only use
> BOOST data? Even on non-boost devices? Apparently yes, as you use
> BOOST data when boost is disabled. So, that was my point here, why
> not using only boost data, regardless of config?

Good point. I will try to look for one Exynos data set solution.

I need to double check some issues.

Stay tunned for patch :-).


> 
> > 
> >>
> >>>
> >>>>
> >>>>>
> >>>>>>
> >>>>>>
> >>>>>>>
> >>>>>>> Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> >>>>>>> Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
> >>>>>>>
> >>>>>>> ---
> >>>>>>> Changes for v10:
> >>>>>>>     - Remove boost related code from thermal_core.c
> >>>>>>>     - Use already present thermal infrastructure to provide
> >>>>>>> thermal hysteresis
> >>>>>>>     - Introduce special set of TMU data for BOOST
> >>>>>>>
> >>>>>>> Changes for v9:
> >>>>>>>     - None
> >>>>>>>
> >>>>>>> Changes for v8:
> >>>>>>>     - Move cpufreq_boost_* stub functions definition (needed
> >>>>>>> when cpufreq is not compiled in) to cpufreq.h at cpufreq core
> >>>>>>> support commit
> >>>>>>>
> >>>>>>> Changes for v7:
> >>>>>>>     - None
> >>>>>>>
> >>>>>>> Changes for v6:
> >>>>>>>     - Disable boost only when supported and enabled
> >>>>>>>     - Protect boost related thermal_zone_device struct fields
> >>>>>>> with mutex
> >>>>>>>     - Evaluate temperature trend during boost enable decision
> >>>>>>>     - Create separate methods to handle boost enable/disable
> >>>>>>>       (thermal_boost_{enable|disable}) operations
> >>>>>>>     - Boost is disabled at any trip point passage (not only
> >>>>>>> the non critical one)
> >>>>>>>     - Add stub definitions for cpufreq boost functions used
> >>>>>>> when CONFIG_CPU_FREQ is NOT defined.
> >>>>>>>
> >>>>>>> Changes for v5:
> >>>>>>>     - Move boost disable code from cpu_cooling.c to
> >>>>>>> thermal_core.c (to handle_non_critical_trips)
> >>>>>>>     - Extent struct thermal_zone_device by adding overheated
> >>>>>>> bool flag
> >>>>>>>     - Implement auto enable of boost after device cools down
> >>>>>>>     - Introduce boost_polling flag, which indicates if thermal
> >>>>>>> uses it's predefined pool delay or has woken up thermal
> >>>>>>> workqueue only to wait until device cools down.
> >>>>>>>
> >>>>>>> Changes for v4:
> >>>>>>>     - New patch
> >>>>>>
> >>>>>>
> >>>>>> Might be interesting to see the changelog for this patch only.
> >>>>>
> >>>>> The above list presents the development state of this particular
> >>>>> patch (thermal). 
> >>>>> Up to v8 I had modified the thermal core. For v10 I've decided
> >>>>> to use proper Exynos data setting.
> >>>>>
> >>>>> If in any doubt, please ask. 
> >>>>>
> >>>>> This last thermal patch of the series hinders this code to be
> >>>>> applied to cpufreq subsystem (Viresh had acked it some time ago
> >>>>> and I hope that he hasn't changed his mind :-) ).
> >>>>>
> >>>>>
> >>>>>>
> >>>>>>>
> >>>>>>>  drivers/thermal/samsung/exynos_tmu_data.c |   47
> >>>>>>> +++++++++++++++++++++++++++++ 1 file changed, 47 insertions(+)
> >>>>>>>
> >>>>>>> diff --git a/drivers/thermal/samsung/exynos_tmu_data.c
> >>>>>>> b/drivers/thermal/samsung/exynos_tmu_data.c index
> >>>>>>> 073c292..9346926 100644 ---
> >>>>>>> a/drivers/thermal/samsung/exynos_tmu_data.c +++
> >>>>>>> b/drivers/thermal/samsung/exynos_tmu_data.c @@ -167,13 +167,60
> >>>>>>> @@ static const struct exynos_tmu_registers
> >>>>>>> exynos4412_tmu_registers = { .features =
> >>>>>>> (TMU_SUPPORT_EMULATION | TMU_SUPPORT_TRIM_RELOAD | \
> >>>>>>> TMU_SUPPORT_FALLING_TRIP | TMU_SUPPORT_READY_STATUS | \
> >>>>>>> TMU_SUPPORT_EMUL_TIME) + +#define EXYNOS4412_TMU_DATA_BOOST \
> >>>>>>> +	.threshold_falling = 10, \
> >>>>>>> +	.trigger_levels[0] = 70, \
> >>>>>>> +	.trigger_levels[1] = 85, \
> >>>>>>> +	.trigger_levels[2] = 103, \
> >>>>>>> +	.trigger_levels[3] = 110, \
> >>>>>>> +	.trigger_enable[0] = true, \
> >>>>>>> +	.trigger_enable[1] = true, \
> >>>>>>> +	.trigger_enable[2] = true, \
> >>>>>>> +	.trigger_enable[3] = true, \
> >>>>>>> +	.trigger_type[0] = THROTTLE_ACTIVE, \
> >>>>>>> +	.trigger_type[1] = THROTTLE_ACTIVE, \
> >>>>>>> +	.trigger_type[2] = THROTTLE_ACTIVE, \
> >>>>>>> +	.trigger_type[3] = SW_TRIP, \
> >>>>>>> +	.max_trigger_level = 4, \
> >>>>>>> +	.gain = 8, \
> >>>>>>> +	.reference_voltage = 16, \
> >>>>>>> +	.noise_cancel_mode = 4, \
> >>>>>>> +	.cal_type = TYPE_ONE_POINT_TRIMMING, \
> >>>>>>> +	.efuse_value = 55, \
> >>>>>>> +	.min_efuse_value = 40, \
> >>>>>>> +	.max_efuse_value = 100, \
> >>>>>>> +	.first_point_trim = 25, \
> >>>>>>> +	.second_point_trim = 85, \
> >>>>>>> +	.default_temp_offset = 50, \
> >>>>>>> +	.freq_tab[0] = { \
> >>>>>>> +		.freq_clip_max = 1400 * 1000, \
> >>>>>>> +		.temp_level = 70, \
> >>>>>>> +	}, \
> >>>>>>> +	.freq_tab[1] = { \
> >>>>>>> +		.freq_clip_max = 800 * 1000, \
> >>>>>>> +		.temp_level = 85, \
> >>>>>>> +	}, \
> >>>>>>> +	.freq_tab[2] = { \
> >>>>>>> +		.freq_clip_max = 200 * 1000, \
> >>>>>>> +		.temp_level = 103, \
> >>>>>>> +	}, \
> >>>>>>> +	.freq_tab_count = 3, \
> >>>>>>> +	.registers = &exynos4412_tmu_registers, \
> >>>>>>> +	.features = (TMU_SUPPORT_EMULATION |
> >>>>>>> TMU_SUPPORT_TRIM_RELOAD | \
> >>>>>>> +			TMU_SUPPORT_FALLING_TRIP |
> >>>>>>> TMU_SUPPORT_READY_STATUS | \
> >>>>>>> +			TMU_SUPPORT_EMUL_TIME)
> >>>>>>>  #endif
> >>>>>>>  
> >>>>>>>  #if defined(CONFIG_SOC_EXYNOS4412)
> >>>>>>>  struct exynos_tmu_init_data const exynos4412_default_tmu_data
> >>>>>>> = { .tmu_data = {
> >>>>>>>  		{
> >>>>>>> +#ifdef CONFIG_CPU_FREQ_BOOST_SW
> >>>>>>> +			EXYNOS4412_TMU_DATA_BOOST,
> >>>>>>> +#else
> >>>>>>>  			EXYNOS4412_TMU_DATA,
> >>>>>>> +#endif
> >>>>>>>  			.type = SOC_ARCH_EXYNOS4412,
> >>>>>>>  			.test_mux =
> >>>>>>> EXYNOS4412_MUX_ADDR_VALUE, },
> >>>>>>>
> >>>>>>
> >>>>>>
> >>>>>
> >>>>
> >>>>
> >>>
> >>>
> >>>
> >>
> >>
> > 
> > 
> 
> 


-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
