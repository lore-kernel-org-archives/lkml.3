Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306AbaIEM2P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 08:28:15 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:60376 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146AbaIEM2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 08:28:10 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-14-5409ac56aa51
Message-id: <1409920084.2811.4.camel@AMDC1943>
Subject: Re: [PATCH v5 0/5] ARM: EXYNOS: cpuidle: fix AFTR mode on boards with
 secure firmware enabled
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-pm@vger.kernel.org, Sachin Kamat <sachin.kamat@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>, tomasz.figa@gmail.com,
        linaro-kernel@lists.linaro.org, linux-arm-kernel@lists.infradead.org
Date: Fri, 05 Sep 2014 14:28:04 +0200
In-reply-to: <53E0F338.8080006@linaro.org>
References: <1407245666-20016-1-git-send-email-b.zolnierkie@samsung.com>
 <53E0E420.8060207@linaro.org> <53E0E98F.5020706@samsung.com>
 <53E0F338.8080006@linaro.org>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsVy+t/xq7phazhDDC5PlrXYOGM9q8W8z7IW
	vQuuslmcbXrDbvH+0DNmi02Pr7FaXN41h83ic+8RRosZ5/cxWZw5fYnV4uSfXkaLVbv+MFps
	/OrhwOuxc9Zddo871/aweWxeUu9x+99jZo8tV9tZPPq2rGL0+LxJLoA9issmJTUnsyy1SN8u
	gSvjyB2tggUiFfMP3WNrYDzH38XIySEhYCJxsnkTM4QtJnHh3nq2LkYuDiGBpYwS054cZIFw
	PjNK3Pt2FKyKV0BP4uSfTWwgtrBAhsSjfxdYQGw2AWOJzcuXgMVFgGoa37cxgdjMAkeYJTqW
	pYPYLAKqEm3/doDVcApoSbRu+MMMsWA5o8TUrl+MEA3qEpPmLQJKcACdpCzR2O8GsVdQ4sfk
	eywQJfISm9e8ZZ7AKDALSccsJGWzkJQtYGRexSiaWppcUJyUnmukV5yYW1yal66XnJ+7iRES
	L193MC49ZnWIUYCDUYmHt0OTM0SINbGsuDL3EKMEB7OSCK/7FKAQb0piZVVqUX58UWlOavEh
	RiYOTqkGxgWfzexzMt2+MLE/+Fl2efllyw/8gZvmx2lIxvsxNqf4HHt/K+WPivemsPm3Xkz6
	uVJxTitP6LmzGZ1HDY+e/NZ2/UR3tsFFA70FZt1pr78are5+uE7l89fsnw/2L3Hdf6px9aYv
	CsqMjQF3ChRb9t2z//DevVfbzOGaX7KAd/Tpy/vOzUpvUldiKc5INNRiLipOBAA3YZ7FdQIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wto, 2014-08-05 at 17:07 +0200, Daniel Lezcano wrote:
> On 08/05/2014 04:26 PM, Krzysztof Kozlowski wrote:
> > On 05.08.2014 16:03, Daniel Lezcano wrote:
> >> On 08/05/2014 03:34 PM, Bartlomiej Zolnierkiewicz wrote:
> >>> Hi,
> >>>
> >>> This patch series adds support for AFTR idle mode on boards with
> >>> secure firmware enabled and allows EXYNOS cpuidle driver usage on
> >>> Exynos4x12 SoCs.
> >>>
> >>> It has been tested on Trats2 board (using Exynos4412 SoC with secure
> >>> firmware enabled) on which AFTR mode reduces power consumption by ~12%
> >>> when EXYNOS cpuidle driver is enabled (in both cases the default
> >>> exynos_defconfig config is used and CPU1-3 are offlined).
> >>
> >> As a sidenote:
> >>
> >> On my odroid-U2:
> >>   * 4 cpus online -> 130 mA
> >>   * 3 cpus online -> 164 mA
> >>   * 2 cpus online -> 160 mA
> >>   * 1 cpu online  -> 157 mA
> >>
> >> So were are consuming more when there are unplugged cpu ... any ideas ?
> >
> > On which tree are you testing? Current next has ARMCLK down feature
> > enabled. ARMCLK down may stop working after hotunplugging CPU:
> > http://www.spinics.net/lists/arm-kernel/msg352890.html
> >
> > That was observed especially on Exynos4212 where ARMCLK down stops
> > working permanently. On Trats2 (Exynos4412) the clock down stopped only
> > a for short period after disabling CPU.
> 
> Hi Krzysztof,
> 
> I tested the patches you mentioned above on top of this patchset.
> 
> You are right this is directly related to the ARMCLK but the behavior 
> may be not as you expect I think.
> 
> When I boot:
> 
> 4 cpus online => 131 mA
> 
> Then I unplug one by one the cpus:
> 
> 3 cpus online => 127 mA
> 2 cpus online => 123 mA
> 1 cpu online  => 120 mA
> 
> This is consistent.
> 
> But now, I online the cpus:
> 
> 2 cpus online => 162 mA
> 3 cpus online => 165 mA
> 4 cpus online => 131 mA
> 
> 
> -- side note --
> 
> Please note, I did not disable the cpuidle neither the AFTR state and 
> the kernel did not hang but I don't see the noticeable power saving we 
> should be observing when there is one cpu remaining entering the AFTR 
> state (cpuidle stats show we enter AFTR). So there is definitively 
> something wrong with this state.

Strange things happen... on current next-20140904 I couldn't reproduce
this inconsistent energy consumption after hotplug. At least on Trats2
(Exynos4412) and Gear1 (Exynos4212) it behaves consistently (and
properly with my patches).

Anyway I'll respin the patchset.

Best regards,
Krzysztof


