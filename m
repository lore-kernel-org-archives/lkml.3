Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135Ab3BDMKv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 07:10:51 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:36171 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755014Ab3BDMKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 07:10:48 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com
Subject: Re: [PATCH 0/4] CPUFreq: Implement per policy instances of governors
Date: Mon, 04 Feb 2013 13:17:04 +0100
Message-ID: <5808458.pvV2iHpBWm@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc6; KDE/4.9.5; x86_64; ; )
In-Reply-To: <cover.1359976493.git.viresh.kumar@linaro.org>
References: <cover.1359976493.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 04, 2013 05:08:50 PM Viresh Kumar wrote:
> Currently, there can't be multiple instances of single governor_type. If we have
> a multi-package system, where we have multiple instances of struct policy (per
> package), we can't have multiple instances of same governor. i.e. We can't have
> multiple instances of ondemand governor for multiple packages.
> 
> Governors directory in sysfs is created at /sys/devices/system/cpu/cpufreq/
> governor-name/. Which again reflects that there can be only one instance of a
> governor_type in the system.
> 
> This is a bottleneck for multicluster system, where we want different packages
> to use same governor type, but with different tunables.
> 
> This patchset is inclined towards fixing this issue.
> 
> Viresh Kumar (4):
>   cpufreq: Don't check cpu_online(policy->cpu)
>   cpufreq: stats: Get rid of CPUFREQ_STATDEVICE_ATTR
>   cpufreq: Add per policy governor-init/exit infrastructure
>   cpufreq: governor: Implement per policy instances of governors

Well, [1-2/4] are things I can take for v3.9 no problem.  The other two I'd
wait for the next cycle to be honest.  We already have 30+ cpufreq patches
scheduled for v3.9 and some of them quite subtle for that matter.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
