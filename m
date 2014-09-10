Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013AbaIJPiU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 11:38:20 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:13887 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbaIJPiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 11:38:18 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-c0-5410706685bd
Message-id: <1410363493.15593.26.camel@AMDC723>
Subject: Re: [PATCH] PM / Domains: add debugfs listing of struct
 generic_pm_domain-s
From: Maciej Matraszek <m.matraszek@samsung.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Wed, 10 Sep 2014 17:38:13 +0200
In-reply-to: <20140910144340.GA17967@kroah.com>
References: <1410348536-15201-1-git-send-email-m.matraszek@samsung.com>
 <20140910144340.GA17967@kroah.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOLMWRmVeSWpSXmKPExsVy+t/xK7ppBQIhBhPazSw2zljPatG8eD2b
	xesXhhazpuxlsri8aw6bxefeI4wWd08dZbM4c/oSqwOHx+I9L5k89s9dw+6x5Wo7i0ffllWM
	HitWf2f3+LxJLoAtissmJTUnsyy1SN8ugStjzaNHLAW3uCrWHTrO2MC4kaOLkZNDQsBEomtd
	BxuELSZx4d56IJuLQ0hgKaPEvf/z2SGcT4wS0+YtAqviFdCXmN50kRXEFhYIk/jTvxnMZhMw
	kNj8r58FxBYRMJboPzsLrJlZoIdJ4u+2w2DNLAKqEhuuvmECsTmBBs1vnAjWLCSQI/H4ZzMz
	iM0soC4xad4iIJsD6CRlicZ+N4i9ghI/Jt9jgSiRl9i85i3zBEaBWUg6ZiEpm4WkbAEj8ypG
	0dTS5ILipPRcQ73ixNzi0rx0veT83E2MkMD/soNx8TGrQ4wCHIxKPLyFF/lDhFgTy4orcw8x
	SnAwK4nwNjkIhAjxpiRWVqUW5ccXleakFh9iZOLglGpgnF93P8jOzzX93ZQt6vmxLafPibwp
	PTP5zzm9pS4hCfJMDU3ZMu/rrh+8mZLP+4pF5e/99NbTF84tvxRnEV6dk5bUKe8yV92y2XbH
	8zc/7hzR+ezg+FSbaf2ZiJ+zl8wRj8v4YnNQK2PDdndt/8c/futN47TvTNyW6hL64IPInENM
	OxXt1rNsUmIpzkg01GIuKk4EABQyNmhaAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,
thanks for your reply!

> > +static int __init pm_genpd_debug_init(void)
> > +{
> > +	struct dentry *d;
> > +
> > +	pm_genpd_debugfs_dir = debugfs_create_dir("pm_genpd", NULL);
> > +
> > +	/* No debugfs */
> > +	if (IS_ERR(pm_genpd_debugfs_dir))
> > +		return PTR_ERR(pm_genpd_debugfs_dir);
> 
> You shouldn't care at all, just do this check:
> 
> > +	if (!pm_genpd_debugfs_dir)
> > +		return -ENOMEM;
> 
> And all will be fine, because:
> 
> > +	d = debugfs_create_file("pm_genpd_summary", S_IRUGO,
> > +			pm_genpd_debugfs_dir, NULL, &pm_genpd_summary_fops);
> 
> That call will resolve away to nothing if debugfs is not enabled, and it
> doesn't make much sense to do anything with an "error" of no debugfs.

Great! I'll fix this bizarre double check.

> 
> > +	if (!d)
> > +		return -ENOMEM;
> > +
> > +	return 0;
> > +}
> > +late_initcall(pm_genpd_debug_init);
> > +#endif /* CONFIG_PM_ADVANCED_DEBUG */
> 
> No tear-down of the debugfs files on shutdown?

In drivers/clk/clk.c, there is no tear-down of debugfs files paired
with clk_debug_init(), same with wakeup_sources_debugfs_init() from
drivers/base/power/wakeup.c. On the other hand, some subsystems
perform it. What would you prefer?


> 
> thanks,
> 
> greg k-h

Thanks,
--
Maciej Matraszek
Samsung R&D Institute Poland
Samsung Electronics

