Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932692Ab3CVNPV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 09:15:21 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:33595 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753876Ab3CVNPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 09:15:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Amit Kucheria <amit.kucheria@linaro.org>,
        Robin Randhawa <robin.randhawa@arm.com>, linux-pm@vger.kernel.org,
        Liviu Dudau <Liviu.Dudau@arm.com>, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, Steve Bannister <Steve.Bannister@arm.com>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Charles Garcia-Tobin <charles.garcia-tobin@arm.com>
Subject: Re: [PATCH] cpufreq: stats: do cpufreq_cpu_put() corresponding to cpufreq_cpu_get
Date: Fri, 22 Mar 2013 14:22:39 +0100
Message-ID: <1557799.tbMLSpRn7J@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohpokYkieTyv=e9kM=zp6qJ9o5+c1D7eodsHf2ncCUig-1MA@mail.gmail.com>
References: <234906745c34fb72b0c450d897f261a22ed18d40.1363947023.git.viresh.kumar@linaro.org> <2999694.A2YTRdtkxt@vostro.rjw.lan> <CAKohpokYkieTyv=e9kM=zp6qJ9o5+c1D7eodsHf2ncCUig-1MA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 22, 2013 05:40:25 PM Viresh Kumar wrote:
> On 22 March 2013 17:42, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > Which would be useful to write in the changelog, wouldn't it?
> 
> Hmm..
> 
> copy-paste with gmail is also broken, so find it attached too.
> 
> New change log, no change in patch and you can trust me on that :)

OK, applied to bleeding-edge.

Thanks,
Rafael


> ----------x-------------x--------
> 
> From 034e5ac4cccd09872592a46decd38d5f24047f10 Mon Sep 17 00:00:00 2001
> Message-Id: <034e5ac4cccd09872592a46decd38d5f24047f10.1363954124.git.viresh.kumar@linaro.org>
> From: Viresh Kumar <viresh.kumar@linaro.org>
> Date: Fri, 22 Mar 2013 15:15:48 +0530
> Subject: [PATCH] cpufreq: stats: do cpufreq_cpu_put() corresponding to
>  cpufreq_cpu_get
> 
> In cpufreq_stats_free_sysfs() we aren't balancing calls to cpufreq_cpu_get()
> with cpufreq_cpu_put(). This will never let us have ref count to policy->kobj as
> zero.
> 
> We will get a hang if somehow cpufreq_driver_unregister() is called. And that
> can happen when we compile our driver as module and insmod/rmmod it.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
