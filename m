Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510AbaDHJeA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 05:34:00 -0400
Received: from service87.mimecast.com ([91.220.42.44]:33737 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbaDHJd5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 05:33:57 -0400
Date: Tue, 8 Apr 2014 10:33:43 +0100
From: Javi Merino <javi.merino@arm.com>
To: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Cc: Tomasz Figa <t.figa@samsung.com>,
        Leela Krishna Amudala <leelakrishna.a@gmail.com>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "eduardo.valentin@ti.com" <eduardo.valentin@ti.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "amit.daniel@samsung.com" <amit.daniel@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "cpgs ." <cpgs@samsung.com>
Subject: Re: [PATCH v11 0/4] thermal: samsung: Clean up and add support for
 Exynos5420
Message-ID: <20140408093343.GA7947@e102654-lin.cambridge.arm.com>
References: <1384238132-24515-1-git-send-email-ch.naveen@samsung.com>
 <1386657640-21481-1-git-send-email-ch.naveen@samsung.com>
 <CAL1wa8fj+pYN7EOkh0nggkwss2U9pJhGEoaA7TG+7oy0LK3zFQ@mail.gmail.com>
 <5329BE8C.8000508@samsung.com>
 <CAHfPSqA6gW+-yTj0vp0b3xbWRVFczkx03nO=GCe9ccgXsRtOag@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAHfPSqA6gW+-yTj0vp0b3xbWRVFczkx03nO=GCe9ccgXsRtOag@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 08 Apr 2014 09:34:00.0542 (UTC) FILETIME=[AC2E27E0:01CF530D]
X-MC-Unique: 114040810334801701
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 02:45:54AM +0000, Naveen Krishna Ch wrote:
> Hello Tomasz,
> 
> On 20 March 2014 00:58, Tomasz Figa <t.figa@samsung.com> wrote:
> > Hi Leela,
> >
> >
> > On 19.03.2014 12:19, Leela Krishna Amudala wrote:
> >>
> >> Hi All,
> >>
> >> I didn't see this series in mainline, Any comments for this ?
> >
> >
> > Naveen had posted v12 of this series and I believe all the patches got my
> > Reviewed-by.
> >
> > Best regards,
> > Tomasz
> Thanks for your reply.
> These patches are posted to the mailing list quite some time now.
> Anything i can do to speed up the process.

These patches create 5 thermal zones, one for each sensor.  Due to the
way the exynos code in drivers/thermal/samsung/exynos_thermal_common.c
registers thermal zones, each one gets a cpufreq_cooling_device.
Therefore you end up with 5 thermal zone each of which is controlling
the cpu frequency.

Wouldn't it be better to collate these 5 sensors to create one thermal
zone for the whole SoC?  Maybe a simplistic algorithm like reporting
the maximum temperature of all the sensors as the thermal zone
temperature is good enough.

Cheers,
Javi

