Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051AbaGXJqe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:46:34 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:47747 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbaGXJqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:46:32 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-83-53d0d5f5aab4
Message-id: <1406195191.21857.6.camel@AMDC1943>
Subject: Re: [PATCH] cpuidle: coupled: Enable interrupts when early returning
 on invalid driver
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Colin Cross <ccross@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        stable@vger.kernel.org
Date: Thu, 24 Jul 2014 11:46:31 +0200
In-reply-to: <53D0D348.406@linaro.org>
References: <1406193999-20300-1-git-send-email-k.kozlowski@samsung.com>
 <53D0D348.406@linaro.org>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu1
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOLMWRmVeSWpSXmKPExsVy+t/xq7pfr14INjiylsli44z1rBbbN35j
	tZj3WdbibNMbdovLu+awWXzuPcJosfbIXXaLM6cvsVos2PiI0YHTY9vubawed67tYfPYcrWd
	xaNvyypGj8+b5AJYo7hsUlJzMstSi/TtErgyLj48y1jwUbxi3rtZzA2MG4S7GDk5JARMJDau
	uMIEYYtJXLi3nq2LkYtDSGApo0Tf6/lQzmdGifXvF4FV8QroS3y62MMOYgsLJEo8X/yRBcRm
	EzCW2Lx8CRuILSKgJ9H4vo0JpJlZYDOTxPXt28EaWARUJW5Mfg9mcwqoSVy59Ii5i5EDaEOy
	xKrJ9SBhZgF1iUnzFjFDXKQsMW//Mai9ghI/Jt9jgaiRl9i85i3zBEaBWUhaZiEpm4WkbAEj
	8ypG0dTS5ILipPRcI73ixNzi0rx0veT83E2MkMD/uoNx6TGrQ4wCHIxKPLwcL04FC7EmlhVX
	5h5ilOBgVhLhXbnpQrAQb0piZVVqUX58UWlOavEhRiYOTqkGxlNMR8+tSnA1yV5zq3V3xprN
	B08Lvv9m0ONU57xK/eW52/Ez9Xe/uvzX+nrIeol3m391eD66e/VUYaNM/NS6SaZMK8z3zjpj
	XKw3TSbf4LaW6umPGxodsg5ZTo/XW2G9+tASHTd1jT67o2ZZ03iClzq+PxqlbpU2b0K1gPre
	7W8rNMvjBAXvPVZiKc5INNRiLipOBACSbLwvWgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czw, 2014-07-24 at 11:35 +0200, Daniel Lezcano wrote:
> On 07/24/2014 11:26 AM, Krzysztof Kozlowski wrote:
> > cpuidle_enter_state is expected to return with interrupts enabled.
> > However cpuidle_enter_state_coupled returned with interrupts disabled if
> > the cpuidle driver was registered without mask of coupled cpus.
> 
> Hi Krzysztof,
> 
> may be your patch is right but I would like to clarify one thing. This 
> is the cpuidle driver for exynos. AFAICT, the coupled states shouldn't 
> be enabled for this driver, so how did you face this issue ?

I faced this on cpuidle drivers on both Exynos and MSM. But these were
not mainline cpuidle drivers.

Best regards,
Krzysztof

> > This could be observed as a warning:
> > [    1.613132] ------------[ cut here ]------------
> > [    1.613244] WARNING: CPU: 0 PID: 0 at kernel/sched/idle.c:175 cpu_idle_loop+0x2dc/0x6d0()
> > [    1.620268] Modules linked in:
> > [    1.623311] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.16.0-rc4-00102-g7669ccdbf8af-dirty #81
> > [    1.623619] dwmmc_exynos 12510000.mshc: 1 slots initialized
> > [    1.624890] logger: created 256K log 'log_main'
> > [    1.625483] logger: created 256K log 'log_events'
> > [    1.626084] logger: created 256K log 'log_radio'
> > [    1.626699] logger: created 256K log 'log_system'
> > [    1.655960] [<c00167cc>] (unwind_backtrace) from [<c0012c28>] (show_stack+0x10/0x14)
> > [    1.663679] [<c0012c28>] (show_stack) from [<c050ab00>] (dump_stack+0x70/0xbc)
> > [    1.670883] [<c050ab00>] (dump_stack) from [<c0023ac8>] (warn_slowpath_common+0x68/0x8c)
> > [    1.678954] [<c0023ac8>] (warn_slowpath_common) from [<c0023b08>] (warn_slowpath_null+0x1c/0x24)
> > [    1.687720] [<c0023b08>] (warn_slowpath_null) from [<c006ddd4>] (cpu_idle_loop+0x2dc/0x6d0)
> > [    1.696052] [<c006ddd4>] (cpu_idle_loop) from [<c006e1d4>] (cpupri_find+0x0/0xd4)
> > [    1.703518] [<c006e1d4>] (cpupri_find) from [<c07cdd14>] (processor_id+0x0/0x2c)
> > [    1.710917] ---[ end trace a85327313857296e ]---
> >
> > Enable the interrupts also when early returning from
> > cpuidle_enter_state_coupled due to invalid coupled configuration.
> >
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > Fixes: 4126c0197bc8 ("cpuidle: add support for states that affect multiple cpus")
> > Cc: <stable@vger.kernel.org>
> > ---
> >   drivers/cpuidle/coupled.c | 4 +++-
> >   1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/cpuidle/coupled.c b/drivers/cpuidle/coupled.c
> > index 73fe2f8d7f96..2b57c267e855 100644
> > --- a/drivers/cpuidle/coupled.c
> > +++ b/drivers/cpuidle/coupled.c
> > @@ -463,8 +463,10 @@ int cpuidle_enter_state_coupled(struct cpuidle_device *dev,
> >   	struct cpuidle_coupled *coupled = dev->coupled;
> >   	int w;
> >
> > -	if (!coupled)
> > +	if (!coupled) {
> > +		local_irq_enable();
> >   		return -EINVAL;
> > +	}
> >
> >   	while (coupled->prevent) {
> >   		cpuidle_coupled_clear_pokes(dev->cpu);
> >
> 
> 

