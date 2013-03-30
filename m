Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757656Ab3C3CJk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 22:09:40 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:47199 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757634Ab3C3CJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 22:09:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, arvind.chauhan@arm.com, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, jacob.shin@amd.com
Subject: Re: [PATCH V4 0/2] Implement per policy instance of governor
Date: Sat, 30 Mar 2013 03:17:09 +0100
Message-ID: <2566297.LngxUqUYMZ@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <cover.1364398686.git.viresh.kumar@linaro.org>
References: <cover.1364398686.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, March 27, 2013 09:28:56 PM Viresh Kumar wrote:
> Hi Guys,
> 
> All patches are pushed here for others to apply (you can apply from mail to):
> http://git.linaro.org/gitweb?p=people/vireshk/linux.git;a=shortlog;h=refs/heads/governor-per-policy-v4
> 
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
> This patchset is inclined towards fixing this issue. Now we will create
> governors directory in cpu/cpu*/cpufreq/<gov> for platforms which have multiple
> struct policy alive at any moment. Platform drivers requiring this feature must
> set have_governor_per_policy variable in their instance of cpufreq_driver. For
> others the interface is kept same: cpu/cpufreq/<gov>.
> 
> 
> This is V4 of this patchset. V3 is already applied by Rafael in his linux-next
> branch. Jacob Shin reported some regressions with this patchset and when I went
> into testing it with his configuration I found more issues then what he
> reported.
> 
> To test these over linux-next you need to revert following first:
> db9baec cpufreq: Get rid of "struct global_attr"
> 86bd6f0 cpufreq: governor: Implement per policy instances of governors
> 8ae67b1 cpufreq: Add per policy governor-init/exit infrastructure
> 
> I have tested this for following now and believe there are no more regressions
> with it:
> - platform with a single policy instance or single group of cpu
> - platform with multiple policies but which don't want per policy instance of
>   governor
> - platform with multiple policies and which want per policy instance of governor
> 
> I have tried with different settings and combinations of governors.
> 
> @Rafael: To simplify your life I have sorted out your branch and you can simply
> pickup the complete branch that I have pushed.

I've applied these two patches and re-applied the queue on top of them.

All is in my linux-next branch now.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
