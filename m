Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232AbaJIQrr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 12:47:47 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:8311 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbaJIQrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 12:47:37 -0400
X-AuditID: cbfee61a-f79c06d000004e71-2f-5436bc271fc0
Date: Thu, 09 Oct 2014 18:47:30 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Eduardo Valentin <edubezval@gmail.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] thermal: core: fix: Check return code of the
 ->get_max_state() callback
Message-id: <20141009184730.253232cb@amdc2363>
In-reply-to: <1412824517.13621.6.camel@rzhang1-toshiba>
References: <1411547232-21493-1-git-send-email-l.majewski@samsung.com>
 <1411547232-21493-4-git-send-email-l.majewski@samsung.com>
 <20141002222441.GA11510@developer> <20141003124054.404ac26c@amdc2363>
 <1412824517.13621.6.camel@rzhang1-toshiba>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t9jQV31PWYhBhNXi1psnLGe1WL+lWus
	Fm8ecVtc3jWHzeJz7xFGiycP+9gc2Dx2zrrL7rF4z0smj3XT3jJ79G1ZxejxeZNcAGsUl01K
	ak5mWWqRvl0CV8b9b1+ZCj5IVOxd/IitgfGNUBcjJ4eEgInE7hO7WSBsMYkL99azdTFycQgJ
	TGeUOHXxIJTzi1Fi4t3dzCBVLAKqEvfezgWz2QT0JD7ffcoEYosIKEssOreVEaSBWeAno8Si
	FQfBxgoLJEm8mf8dzOYFalh25DE7iM0pYC7x7cYuVogNPxglrny9zwiS4BeQlGj/94MZ4iY7
	iXOfNrBDNAtK/Jh8D2wQs4CWxOZtTawQtrzE5jVvmScwCs5CUjYLSdksJGULGJlXMYqmFiQX
	FCel5xrqFSfmFpfmpesl5+duYgSH/TOpHYwrGywOMQpwMCrx8D74ZxoixJpYVlyZe4hRgoNZ
	SYR3+0yzECHelMTKqtSi/Pii0pzU4kOM0hwsSuK8B1qtA4UE0hNLUrNTUwtSi2CyTBycUg2M
	ig9ssgQiK878ff3M7NVl1mAP15fOCRe6Ba7w7RINN/kSFZa+pE3l6OvGmY8exP1OeqcckHOG
	Nb5ki2ZsetqbLadyL3RnHUg4Ff1r7sOC9u83JZ+3ft+6bZvr/UCX/ceUMsUSP9pLbWm5fGtp
	0rQ32ZM3/7iy/F/Qlt6HO4WC+XN+sM9JZPp8SYmlOCPRUIu5qDgRAD/aIG13AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Zhang,

> On Fri, 2014-10-03 at 12:40 +0200, Lukasz Majewski wrote:
> > Hi Eduardo, Rui,
> > 
> > > On Wed, Sep 24, 2014 at 10:27:12AM +0200, Lukasz Majewski wrote:
> > > > Without this check it was possible to execute cooling device
> > > > binding code even when wrong max cooling state was read.
> > > > 
> > > > Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> > > 
> > > Acked-by: Eduardo Valentin <edubezval@gmail.com>
> > > 
> > > Rui, are you taking these patches? Do you prefer me to collect
> > > them?
> > 
> > I'd like to ask you NOT to apply those patches.
> > 
> > In short: It will cause regression on all non Exynos boards.
> > 
> > Explanation:
> > 
> > Up till now the cpu_cooling device was bind even when the
> > get_max_state() returned -EINVAL and everything worked after late
> > cpufreq policy initialization.
> > 
> > However, during this time window the thermal driver is not properly
> > configured.
> > 
> > Applying PATCH2/3 and PATCH3/3 would cause bind error without any
> > further occasion for re-bind. As a result THERAL will not be present
> > on the target system.
> > 
> > It works on the Exynos boards, since at the report_trigger()
> > function, when first trip point is reached, it is checked if
> > cpu_cooling device is bind. If it is not (due to "fixes" at
> > PATCH2/3 and PATCH3/3) it is rebind then.
> > 
> > Due to above, I think that it would be best to leave things as they
> > are now and prepare proper fix as suggested by Eduardo.
> > 
> Agreed. Can anyone please propose such a patch?

I can propose myself as a volunteer for this. Unfortunately, I won't be
able to provide any code earlier than in two weeks time. 

> 
> thanks,
> rui
> > > 
> > > Cheers
> > > 
> > > Eduardo
> > > 
> > > > ---
> > > >  drivers/thermal/thermal_core.c | 6 ++++--
> > > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/drivers/thermal/thermal_core.c
> > > > b/drivers/thermal/thermal_core.c index 747618a..8a4dc35 100644
> > > > --- a/drivers/thermal/thermal_core.c
> > > > +++ b/drivers/thermal/thermal_core.c
> > > > @@ -928,7 +928,7 @@ int thermal_zone_bind_cooling_device(struct
> > > > thermal_zone_device *tz, struct thermal_zone_device *pos1;
> > > >  	struct thermal_cooling_device *pos2;
> > > >  	unsigned long max_state = 0;
> > > > -	int result;
> > > > +	int result, ret;
> > > >  
> > > >  	if (trip >= tz->trips || (trip < 0 && trip !=
> > > > THERMAL_TRIPS_NONE)) return -EINVAL;
> > > > @@ -945,7 +945,9 @@ int thermal_zone_bind_cooling_device(struct
> > > > thermal_zone_device *tz, if (tz != pos1 || cdev != pos2)
> > > >  		return -EINVAL;
> > > >  
> > > > -	cdev->ops->get_max_state(cdev, &max_state);
> > > > +	ret = cdev->ops->get_max_state(cdev, &max_state);
> > > > +	if (ret)
> > > > +		return ret;
> > > >  
> > > >  	/* lower default 0, upper default max_state */
> > > >  	lower = lower == THERMAL_NO_LIMIT ? 0 : lower;
> > > > -- 
> > > > 2.0.0.rc2
> > > > 
> > 
> > 
> > 
> 



-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
