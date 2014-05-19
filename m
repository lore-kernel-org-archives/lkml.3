Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585AbaESLFo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 07:05:44 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:54556 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbaESLFm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 07:05:42 -0400
X-AuditID: cbfee61a-b7fef6d00000200b-40-5379e58135a3
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Amit Kachhap <amit.kachhap@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Tomasz Figa <t.figa@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/10] thermal: exynos: various cleanups
Date: Mon, 19 May 2014 13:05:24 +0200
Message-id: <4899668.1WyrreGo3H@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <CADGdYn5S67Sd8ON5YHiUvqiw7ypXqV3n4VURheEJsStWinR85w@mail.gmail.com>
References: <1399288539-1793-1-git-send-email-b.zolnierkie@samsung.com>
 <1400144805.2273.34.camel@rzhang1-toshiba>
 <CADGdYn5S67Sd8ON5YHiUvqiw7ypXqV3n4VURheEJsStWinR85w@mail.gmail.com>
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDLMWRmVeSWpSXmKPExsVy+t9jQd3Gp5XBBtOXSFr8ejeT3WLN/p9M
	Fmeb3rBbXN41h83ic+8RRosZ5/cxWZw5fYnV4snDPjaL9TNeszhweuycdZfdY/Gel0weW662
	s3j0bVnF6HH8xnYmj8+b5ALYorhsUlJzMstSi/TtErgyfq7sZy64JVbRvOsdWwPjB8EuRk4O
	CQETicUP17BD2GISF+6tZ+ti5OIQEpjOKPFz5w4WkISQQAuTRPMzNhCbTcBKYmL7KkYQW0RA
	U2LTr6NMIA3MAiuYJD4cnAg2SVjARuJV6yWwIhYBVYlVzXvB4rxADS9afoINEhXwlNixfSWY
	zSkQLHFg9UpmiM27GSXetX5nhmgQlPgx+R7YFcwC2hJP3l1ghbDVJSbNW8Q8gVFgFpKyWUjK
	ZiEpW8DIvIpRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOA6eSe1gXNlgcYhRgINRiYd3Qnhl
	sBBrYllxZe4hRgkOZiUR3m03gEK8KYmVValF+fFFpTmpxYcYpTlYlMR5D7RaBwoJpCeWpGan
	phakFsFkmTg4pRoYXS28pTaUP+c92fnaRM//1u0pB14te9aguuE355+yFf9nX5GY+7Osdnsk
	518h87KlS898PSC0mXHzhj+OF/Ks1vhsTpzed/Z25H+Zp3vMr9l+f294YPrVUFuJ8E2Vkwvz
	dlhnH5qws2Y5g1aWvOzTA9OZHsbeeuZ9cuLufR8NVy9wNdzTFGv7Tk2JpTgj0VCLuag4EQBi
	uyi+fwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Monday, May 19, 2014 11:46:10 AM Amit Kachhap wrote:
> On 5/15/14, Zhang Rui <rui.zhang@intel.com> wrote:
> > On 一, 2014-05-05 at 13:15 +0200, Bartlomiej Zolnierkiewicz wrote:
> >> Hi,
> >>
> >> This patch series contains various cleanups for EXYNOS thermal
> >> driver.  Overall it decreases driver's LOC by 13%.  It is based
> >> on next-20140428 kernel.  It should not cause any functionality
> >> changes.
> >>
> > Amit,
> >
> > what do you think of this patch set?
> >
> > thanks,
> > rui
> 
> I agreed to many of the cleanups in the patch but tmu controller
> features should be retained as they will allow adding quick soc
> support and also avoid unnecessary churning of code in the future.

The general rule in the kernel code is not to keep the dead code as
it has a maintainance cost and makes further changes usually more
difficult, not easier.  There is no guarantee that the future SoCs
support will use the dead code (i.e. TYPE_TWO_POINT_TRIMMING support
has been introudced more than 2.5 years but no users of it has been
ever added) and in the meantime all other code changes has to take
the dead code into account.  I also have more Exynos thermal driver
changes in the work and it would be much easier to do them without
the need to support unused SoC features.  Please consider this in
your opinion.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

> Thanks,
> Amit
> 
> >> Best regards,
> >> --
> >> Bartlomiej Zolnierkiewicz
> >> Samsung R&D Institute Poland
> >> Samsung Electronics
> >>
> >>
> >> Bartlomiej Zolnierkiewicz (10):
> >>   thermal: exynos: remove unused struct exynos_tmu_registers entries
> >>   thermal: exynos: remove unused defines
> >>   thermal: exynos: remove dead code for HW_MODE calibration
> >>   thermal: exynos: remove dead code for TYPE_TWO_POINT_TRIMMING
> >>     calibration
> >>   thermal: exynos: remove redundant pdata checks from
> >>     exynos_tmu_initialize()
> >>   thermal: exynos: remove redundant threshold_code checks from
> >>     exynos_tmu_initialize()
> >>   thermal: exynos: simplify temp_to_code() and code_to_temp()
> >>   thermal: exynos: cache non_hw_trigger_levels in pdata
> >>   thermal: exynos: remove redundant pdata checks from
> >>     exynos_tmu_control()
> >>   thermal: exynos: remove identical values from exynos*_tmu_registers
> >>     structures
> >>
> >>  drivers/thermal/samsung/exynos_thermal_common.h |   1 -
> >>  drivers/thermal/samsung/exynos_tmu.c            | 181
> >> ++++--------------------
> >>  drivers/thermal/samsung/exynos_tmu.h            |  86 +----------
> >>  drivers/thermal/samsung/exynos_tmu_data.c       |  40 +-----
> >>  drivers/thermal/samsung/exynos_tmu_data.h       |  32 +----
> >>  5 files changed, 37 insertions(+), 303 deletions(-)

