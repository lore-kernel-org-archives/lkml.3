Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254AbaIJOPI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:15:08 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:61133 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbaIJOKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:10:32 -0400
Date: Wed, 10 Sep 2014 10:10:22 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Wei Ni <wni@nvidia.com>
Cc: Jean Delvare <jdelvare@suse.de>, Guenter Roeck <linux@roeck-us.net>,
        Stephen Warren <swarren@wwwdotorg.org>, lm-sensors@lm-sensors.org,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 3/4] thermal: add more description for thermal-zones
Message-ID: <20140910141019.GA8747@developer>
References: <53FD484F.7030504@nvidia.com>
 <20140827133217.GB15875@developer>
 <53FE8AC9.2070907@nvidia.com>
 <20140828132135.GA17074@developer>
 <53FFED7B.6010508@nvidia.com>
 <CAC-25o-9OQ-wfpCJmgDGB0kqDHwUc15XX7Ay7Pes6UmpJakUkQ@mail.gmail.com>
 <540449BC.2050807@nvidia.com>
 <54098538.1000505@nvidia.com>
 <20140830194318.GA3025@developer>
 <5410084A.9020302@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5410084A.9020302@nvidia.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello Wei,

On Wed, Sep 10, 2014 at 04:14:02PM +0800, Wei Ni wrote:

<big cut>

> > 
> > Have you tried the patch set from Javi? the power allocator schem 
> > includes a PID controller governor. Might be worth having a common
> > solution. I think it is easier if I merge his changes into a branch and
> > you have try on it. His patch series have already gone through several
> > reviews. But you are free to comment too.
> 
> Oh, it's great, could you show me link of the patch set, so that I can
> try it.

Sure. Version 5 was posted several weeks ago in here:
https://lkml.org/lkml/2014/7/10/366

Also, I have merged it into a branch in my personal tree here:
https://git.kernel.org/cgit/linux/kernel/git/evalenti/linux.git/log/?h=thermal_work/thermal_core/power_allocator


> 
> > 
> >>>
> >>> Indeed, our thermal management includes skin-temp, soc-thermal,
> >>> cpu-throttle driver and pid governor. This pach set is prepared for the
> >>> skin-temp driver.
> >>> As you know the tegra soc-therm is in upstreaming, and we will post
> >>> other drivers step by step.
> >>
> >> Will you take this patch, if so i will post skin-temp driver later.
> >> Looking forward your comments :)
> >>
> > 
> > I am afraid moving the maps and trips properties to optional abuses the
> > purpose of the thermal DT. The primary goal is to describe hardware, and
> > in this specific case, the hardware proper thermal operating conditions.
> > 
> > DT has to be as agnostic to OS implementation as possible.
> > 
> > For the above reason, I do not think this patch is a good idea.
> 
> Yes, I understand what you are worrying about, but it seems it's
> difficult to handle this specific case in current framework or even
> develop a new framework. How about to still set trips and maps as
> required properties, but just add description something like "If missing
> it, the thermal zone only has basic function such as reading temperature"

I believe the right way of compsing a skin temperature zone is already
documented in the thermal.txt DT descriptor. You must add several
sensors into a zone. And not add several thermal zones that are used
only for monitoring.

The DT part description needs to focus on the hardware description. If
you see something is missing in the Linux kernel implementation, let me
know, and we can improve it.

Cheers,

> 
> Thanks.
> Wei.
> 
> > 
> > 
> > Cheers,
> > 
> >> Thanks.
> >> Wei.
> >>
> >>>
> >>> Thanks.
> >>> Wei.
> >>>
> >>>>
> >>>>> Thanks.
> >>>>> Wei.
> >>>>>
> >>>>>>
> >>>>>>
> >>>>>>>
> >>>>>>>              trips {
> >>>>>>>              };
> >>>>>>>              cooling-maps {
> >>>>>>>              };
> >>>>>>>      };
> >>>>>>> };
> >>>>>>>
> >>>>>>> Wei.
> >>>>>>>>
> >>>>>>>>>
> >>>>>>>>> Wei.
> >>>>>>>>>
> >>>>>>>>>>
> >>>>>>>>>> The purpose of a thermal zone is to describe thermal behavior of a
> >>>>>>>>>> hardware. As it is mentioned in the thermal.txt file.
> >>>>>>>>>>
> >>>>>>>>>>
> >>>>>>>>>>>
> >>>>>>>>>>> Thanks.
> >>>>>>>>>>> Wei.
> >>>>>>>>>>>
> >>>>>>>>>>>>
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> -Optional property:
> >>>>>>>>>>>>>  - coefficients:               An array of integers (one signed cell) containing
> >>>>>>>>>>>>>    Type: array         coefficients to compose a linear relation between
> >>>>>>>>>>>>>    Elem size: one cell the sensors listed in the thermal-sensors property.
> >>>>>>>>>>>>> --
> >>>>>>>>>>>>> 1.8.1.5
> >>>>>>>>>>>>>
> >>>>>>>>>>>
> >>>>>>>>>> --
> >>>>>>>>>> To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
> >>>>>>>>>> the body of a message to majordomo@vger.kernel.org
> >>>>>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>>>>>>>>>
> >>>>>>>>>
> >>>>>>>
> >>>>>
> >>>>
> >>>>
> >>>>
> >>>
> >>> --
> >>> To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
> >>> the body of a message to majordomo@vger.kernel.org
> >>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>>
> >>
> 
