Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750Ab3KUVag (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 16:30:36 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:59135 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752640Ab3KUVad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 16:30:33 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, Nishanth Menon <nm@ti.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>, Sripa Bagadia <ceh@ti.com>
Subject: Re: [PATCH] cpufreq: Make sure CPU is running on a freq from freq-table
Date: Thu, 21 Nov 2013 22:43:14 +0100
Message-ID: <1980582.Pd2pT79ZWp@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <528E4950.9030507@gmail.com>
References: <de5c3ff26e9d06a6e0b06f8ba3da6d8c3ff82304.1385017369.git.viresh.kumar@linaro.org> <CAKohpo=fZ8Fr=CMDzCy3daBU+mZBJ+9fOks6L7WLOZzE7WaAaQ@mail.gmail.com> <528E4950.9030507@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 21, 2013 09:56:32 AM Dirk Brandewie wrote:
> On 11/21/2013 07:57 AM, Viresh Kumar wrote:
> > On 21 November 2013 18:41, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> >> On Thursday, November 21, 2013 12:39:02 PM Viresh Kumar wrote:
> >
> >>> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> >>> @@ -1038,6 +1038,32 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
> >
> >>> +     if (has_target()) {
> >>> +             ret = __cpufreq_driver_target(policy, policy->cur,
> >>> +                             CPUFREQ_RELATION_L);
> >>> +             if (ret)
> >>> +                     pr_err("%s: Unable to set frequency from table: %d\n",
> >>> +                                     __func__, ret);
> >>
> >> Should we continue in that case?
> >
> > I wasn't sure. I thought maybe there are platforms which might not be
> > ready for transitions so early and so an error message would be fine,
> > as we will fail soon anyway in case there is a bug.
> >
> 
> The scaling driver for the CPU has already loaded and its .init procedure has 
> been called so .target better be callable.
> 
> Since the scaling driver is responsible maintaining the set of valid frequencies
> and setting policy->cur I think it is reasonable to have the scaling driver
> ensure that policy->cur returned from its .init and the operating frequency are
> in sync and match one of the values in its frequency table.

>From that I infer that we should not continue on errors here.  Which also is my
opinion.

Rafael

