Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432AbaGUKIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 06:08:52 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:37029 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142AbaGUKIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 06:08:50 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-f3-53cce6af03d3
Message-id: <1405937325.21645.2.camel@AMDC1943>
Subject: Re: [PATCH 1/3] cpuidle: exynos: Allow to use the driver without AFTR
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene.kim@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Sachin Kamat <sachin.kamat@samsung.com>,
        Tushar Behera <tushar.behera@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Date: Mon, 21 Jul 2014 12:08:45 +0200
In-reply-to: <53CCE31C.90300@linaro.org>
References: <1405931771-24100-1-git-send-email-k.kozlowski@samsung.com>
 <53CCE31C.90300@linaro.org>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu1
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t/xK7rrn50JNlh8Xtdi44z1rBbzPsta
	9C64ymZxtukNu8Wmx9dYLS7vmsNm8bn3CKPFjPP7mCxuX+a1WHvkLrvFmdOXWC2uXDrFZrF+
	xmsWi/a/e9kc+DxamnvYPO5c28PmsXlJvceWq+0sHn1bVjF6fN4kF8AWxWWTkpqTWZZapG+X
	wJUx79pNpoINfBULZt5lbWBcyd3FyMkhIWAisXn6IzYIW0ziwr31QDYXh5DAUkaJ0ydnMkI4
	nxkl1nYcZwSp4hXQl3i+6z0riC0s4Cdx7NBnMJtNwFhi8/IlYJNEBPQkGt+3MYE0Mwv0sEi0
	7G9jAUmwCKhKXPrewQRicwpoSFyacxQozgG0IVXi1bokkDCzgLrEpHmLmCEuUpaYt/8YE8Re
	QYkfk++xQNTIS2xe85Z5AqPALCQts5CUzUJStoCReRWjaGppckFxUnqukV5xYm5xaV66XnJ+
	7iZGSMR83cG49JjVIUYBDkYlHl6OF6eChVgTy4orcw8xSnAwK4nwnsg4EyzEm5JYWZValB9f
	VJqTWnyIkYmDU6qBUfPNrHcztPp9I4Xzhbi/zP9rJ33lk26X4pmbM6ys/TYLdr9mS63Or21b
	9vzCHj35R9P/BO3NCn/8d3kVs203d+p7q/lX1zXcqP905PvLo0er+fxLebY9n/9HR/UXw52m
	voJdH+I4zuhILCzx3B9su2XuIff41v9sj6LK1IQybkleWOFY8TF5uRJLcUaioRZzUXEiAO1Q
	VJN2AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pon, 2014-07-21 at 11:53 +0200, Daniel Lezcano wrote:
> On 07/21/2014 10:36 AM, Krzysztof Kozlowski wrote:
> > Allow the driver to be used when AFTR enter function is not provided
> > (device platform data is NULL).
> >
> > This actually does not give any special energy-saving benefits but
> > allows to track the idle time of each core. Additionally it is a safe
> > way to validate supplied platform data.
> >
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> 
> I think we already talk about this in the mailing list several times.
> It does not make sense to enable the cpuidle driver for WFI just for the 
> sake of tracking via sysfs some idle timings.
> 
> Using the cpuidle driver means using the underlying cpuidle 
> infrastructure with all the stats computation in the governor.
> 
> If there is a *real* need of a WFI cpuidle driver, then a generic WFI 
> cpuidle driver could be implemented to supersede this one.
> 
> It took a while to cleanup this driver and remove all the hacks around 
> this AFTR state... :)

Sure, I understand.

Best regards,
Krzysztof


> 
> > ---
> >   drivers/cpuidle/cpuidle-exynos.c | 3 +++
> >   1 file changed, 3 insertions(+)
> >
> > diff --git a/drivers/cpuidle/cpuidle-exynos.c b/drivers/cpuidle/cpuidle-exynos.c
> > index 7c0151263828..5325a394be7e 100644
> > --- a/drivers/cpuidle/cpuidle-exynos.c
> > +++ b/drivers/cpuidle/cpuidle-exynos.c
> > @@ -77,7 +77,10 @@ static int exynos_cpuidle_probe(struct platform_device *pdev)
> >   {
> >   	int ret;
> >
> > +	/* If NULL enter only WFI */
> >   	exynos_enter_aftr = (void *)(pdev->dev.platform_data);
> > +	if (!exynos_enter_aftr)
> > +		exynos_idle_driver.state_count = 1;
> >
> >   	ret = cpuidle_register(&exynos_idle_driver, NULL);
> >   	if (ret) {
> >
> 
> 

