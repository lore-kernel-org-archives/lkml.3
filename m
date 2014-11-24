Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466AbaKXKjJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 05:39:09 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:19855 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742AbaKXKjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 05:39:04 -0500
X-AuditID: cbfee61a-f79c06d000004e71-b8-54730ac67ee8
Date: Mon, 24 Nov 2014 11:38:54 +0100
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
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH v2] thermal:core:fix: Check return code of the
 ->get_max_state() callback
Message-id: <20141124113854.36975fb2@amdc2363>
In-reply-to: <20141121180826.GA3331@developer>
References: <1415898165-27406-1-git-send-email-l.majewski@samsung.com>
 <1416305790-27746-1-git-send-email-l.majewski@samsung.com>
 <20141121180826.GA3331@developer>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKIsWRmVeSWpSXmKPExsVy+t9jAd1jXMUhBqePSFhsnLGe1WL+lWus
	FqdPLWC1OPfqEYvF2+Zii1eHdzFavHnEbXF51xw2i8+9RxgtOr/MYrN4cHUam8WTh31sFq8O
	trFY/Nw1j8Xi2IkZrBYbv3o4CHg82XSR0WPnrLvsHov3vGTyuHNtD5vHumlvmT0OTD7H6tHb
	/I7N49uZiSwefVtWMXo8/bGX2ePzJjmPjXNDA3iiuGxSUnMyy1KL9O0SuDLuPN3DXjBBs2Lp
	99XsDYyHFboYOTkkBEwkJt+/wwRhi0lcuLeerYuRi0NIYBGjxIF58xkhnF+MElcenGIDqWIR
	UJV427aMEcRmE9CT+Hz3KVi3iICWxIlL25lAGpgFelglpm2axwySEBaIl7i4oZUVxOYFapiy
	8QhQnIODE8h+ubwEYsFyRokvZ76CLeAXkJRo//eDGeIkO4lznzawQ/QKSvyYfI8FxGYGWrZ5
	WxMrhC0vsXnNW+YJjIKzkJTNQlI2C0nZAkbmVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjB
	kflMagfjygaLQ4wCHIxKPLwfNhaFCLEmlhVX5h5ilOBgVhLh3cdYHCLEm5JYWZValB9fVJqT
	WnyIUZqDRUmc98bN3BAhgfTEktTs1NSC1CKYLBMHp1QDY1QT594HmuE/XDcWSC4K0IqsN/9S
	GxMo9KFIlKdsTdbDcvcbYmKZLvc8ew3OrtVvUXhq2Pvu0o3vX7cH/jZYx2QqvuueqcyZm5NK
	72dbrax/oPQ1W/Kqnrdk0AzFqHT1cNOIZOumGP72zQXcV5uWT1oxrbeMS/jS3beVbEdenKub
	UX3Y+dkXJZbijERDLeai4kQA5oYV0MgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduardo,

> 
> Lukasz,
> 
> On Tue, Nov 18, 2014 at 11:16:30AM +0100, Lukasz Majewski wrote:
> > The return code from ->get_max_state() callback was not checked
> > during binding cooling device to thermal zone device.
> > 
> > Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> > ---
> > Changes for v2:
> > - It turned out that patches from 1 to 6 from v1 are not needed,
> > since they either already solve the problem (like imx_thermal.c) or
> > not use cpufreq as a thermal cooling device.
> > - The patch 7 from v1 is also not needed since this patch on error
> > exits this function without using max_state variable.
> > - In thermal driver probe the cpufreq_cooling_register() method
> > presence is crucial to evaluate if the thermal driver needs any
> > actions with -EPROBE_DEFER.
> 
> Have you tried this patch with of-thermal based systems?

Yes. I did try it with Exynos (after the rework). And there weren't
any regressions.

To be precise - do you refer to of_cpufreq_cooling_register() [1] or
cpufreq_cooling_register() [2]?

For the latter [2] - drivers like imx_thermal.c are fully prepared for
-EDEFER_PROBE.

For the former [1] - only cpufreq-dt.c uses it (and Exynos SoC after
the rework).

> 
> The above proposal works if the thermal driver is dealing with loading
> cpu_cooling. But for of-thermal based drivers, the idea is to leave to
> cpufreq code to load it. 

I assume, that you mean case [1]?

> 
> As an example, I am taking the ti-soc-thermal, but we already have
> other of-thermal based drivers. Booting with this patch ti-soc-thermal
> (of-based boot) loads fine, but the cpu_cooling never gets bound to
> the thermal zone.

Could you share the exact SoC/board/_defconfig setup to reproduce this
behavior? I possess Beagle Bone Black, but it doesn't have thermal
support (perhaps because its lack of accuracy).

With my Exynos setup I didn't experience any problems with this patch.

> 
> The thing is that the bind may happen before cpufreq-dt code loads the
> cpufreq driver, and when cpu_cooling is checking what is the max freq,
> by using cpufreq table, it won't be able to do it, as there is no
> table.

As I look into the cpufreq-dt.c driver - in the cpufreq_init()
function, the call to of_cpufreq_cooling_register() is performed just
before cpufreq_table_validate_and_show().
It looks like a mistake in the cpufreq-dt.c code.

> 
> While, without the patch, it will use wrong in the binding, but after
> it gets bound, and cpufreq loads, the max will be used correctly.

Correct. Such _wrong_ behavior was the original motivation to prepare
this patch.

> 
> And in this case, the system still works besides this bug. 

Unfortunately there is also a "window" in which the driver is not
properly configured and can cause system crash, although it is unlikely.


> The
> reasoning is because the max state comes from DT (2) and lower and
> upper wont be equal to THERMAL_NO_LIMIT. Then, the following check
> will use the parameter, instead of max_state:
> 
>         cdev->ops->get_max_state(cdev, &max_state);
> 
> 	/* lower default 0, upper default max_state */
> 	lower = lower == THERMAL_NO_LIMIT ? 0 : lower;
> 	upper = upper == THERMAL_NO_LIMIT ?
> 				max_state : upper;
> 
> In summary, introducing this patch, although it fix a problem, will
> introduce regressions, in of-thermal based drivers.

To be more precise - it will affect systems, which use of-thermal.c and
cpufreq-dt.c in the same time, due to wrong ordering in the latter file.

Could you give me a hint about the exact affected system? I've grep'ed
for CPUFREQ_DT in the ./arch/arm/configs with no success.

> 
> I believe, to have this fix, you need to provide a way to have probing
> deferring also in cpu_cooling. That needs also the change in the
> cpufreq driver, as I mentioned in the other thread.

I will think about possible solution and refer to previous discussion. 

> 
> Cheers,
> 
> > ---
> >  drivers/thermal/thermal_core.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/thermal/thermal_core.c
> > b/drivers/thermal/thermal_core.c index 43b9070..8567929 100644
> > --- a/drivers/thermal/thermal_core.c
> > +++ b/drivers/thermal/thermal_core.c
> > @@ -928,7 +928,7 @@ int thermal_zone_bind_cooling_device(struct
> > thermal_zone_device *tz, struct thermal_zone_device *pos1;
> >  	struct thermal_cooling_device *pos2;
> >  	unsigned long max_state;
> > -	int result;
> > +	int result, ret;
> >  
> >  	if (trip >= tz->trips || (trip < 0 && trip !=
> > THERMAL_TRIPS_NONE)) return -EINVAL;
> > @@ -945,7 +945,9 @@ int thermal_zone_bind_cooling_device(struct
> > thermal_zone_device *tz, if (tz != pos1 || cdev != pos2)
> >  		return -EINVAL;
> >  
> > -	cdev->ops->get_max_state(cdev, &max_state);
> > +	ret = cdev->ops->get_max_state(cdev, &max_state);
> > +	if (ret)
> > +		return ret;
> >  
> >  	/* lower default 0, upper default max_state */
> >  	lower = lower == THERMAL_NO_LIMIT ? 0 : lower;
> > -- 
> > 2.0.0.rc2
> > 


-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
