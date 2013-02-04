Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab3BDN6U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 08:58:20 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:34696 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220Ab3BDN6R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 08:58:17 -0500
MIME-Version: 1.0
In-Reply-To: <20130204133648.GE13909@pd.tnic>
References: <cover.1359976493.git.viresh.kumar@linaro.org>
	<5808458.pvV2iHpBWm@vostro.rjw.lan>
	<CAKohpok7RiJ_HKGi3r0vU26kNEtFKq==pMMoshT6Z2yy9ghemA@mail.gmail.com>
	<20130204123221.GA22340@pd.tnic>
	<CAKohpomcrtV3i9fL4zV6Mt0uDza-9pHTOsqTe2=C1t6mE6cpCQ@mail.gmail.com>
	<20130204130403.GD13909@pd.tnic>
	<CAKohpokuFC5gnTFcD3+RH3p5XaW8vBtyfq+Kej=d2J8tERdmoQ@mail.gmail.com>
	<20130204133648.GE13909@pd.tnic>
Date: Mon, 4 Feb 2013 19:28:16 +0530
Message-ID: <CAKohpo=aLnhM0Op_32ohWZK5eG5nT7iK0OktBe+8ygOQW7zUqQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] CPUFreq: Implement per policy instances of governors
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Borislav Petkov <bp@alien8.de>, Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 February 2013 19:06, Borislav Petkov <bp@alien8.de> wrote:
> On Mon, Feb 04, 2013 at 06:55:25PM +0530, Viresh Kumar wrote:
>> That's not completely true. There lies cpufreq directory in cpu/cpu*/
>> too, where we have per policy stuff in cpu/cpu*/, like policy tunables
>> and stats. And the same is true for governor too.
>
> $ tree /sys/devices/system/cpu/cpu0/cpufreq/
> /sys/devices/system/cpu/cpu0/cpufreq/
> ├── affected_cpus
> ├── bios_limit
> ├── cpb
> ├── cpuinfo_cur_freq
> ├── cpuinfo_max_freq
> ├── cpuinfo_min_freq
> ├── cpuinfo_transition_latency
> ├── related_cpus
> ├── scaling_available_frequencies
> ├── scaling_available_governors
> ├── scaling_cur_freq
> ├── scaling_driver
> ├── scaling_governor
> ├── scaling_max_freq
> ├── scaling_min_freq
> ├── scaling_setspeed
> └── stats
>     ├── time_in_state
>     ├── total_trans
>     └── trans_table
>
> 1 directory, 19 files
>
> $ grep -r . /sys/devices/system/cpu/cpu0/cpufreq/*
> /sys/devices/system/cpu/cpu0/cpufreq/affected_cpus:0
> /sys/devices/system/cpu/cpu0/cpufreq/bios_limit:4000000
> /sys/devices/system/cpu/cpu0/cpufreq/cpb:1
> /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq:1400000
> /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq:4000000
> /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_min_freq:1400000
> /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_transition_latency:4000
> /sys/devices/system/cpu/cpu0/cpufreq/related_cpus:0 1
> /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies:4000000 3400000 2800000 2100000 1400000
> /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors:powersave userspace conservative ondemand perform
> /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq:1400000
> /sys/devices/system/cpu/cpu0/cpufreq/scaling_driver:acpi-cpufreq
> /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor:ondemand
> /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq:4000000
> /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq:1400000
> /sys/devices/system/cpu/cpu0/cpufreq/scaling_setspeed:<unsupported>
> /sys/devices/system/cpu/cpu0/cpufreq/stats/time_in_state:4000000 3089328
> /sys/devices/system/cpu/cpu0/cpufreq/stats/time_in_state:3400000 47448
> /sys/devices/system/cpu/cpu0/cpufreq/stats/time_in_state:2800000 67185
> /sys/devices/system/cpu/cpu0/cpufreq/stats/time_in_state:2100000 92731
> /sys/devices/system/cpu/cpu0/cpufreq/stats/time_in_state:1400000 11416914
> /sys/devices/system/cpu/cpu0/cpufreq/stats/trans_table:   From  :    To
> /sys/devices/system/cpu/cpu0/cpufreq/stats/trans_table:         :   4000000   3400000   2800000   2100000   140000
> /sys/devices/system/cpu/cpu0/cpufreq/stats/trans_table:  4000000:         0     34756     46388     53179    21824
> /sys/devices/system/cpu/cpu0/cpufreq/stats/trans_table:  3400000:     12938         0      3755      3555     1450
> /sys/devices/system/cpu/cpu0/cpufreq/stats/trans_table:  2800000:     19940         0         0      4547     2565
> /sys/devices/system/cpu/cpu0/cpufreq/stats/trans_table:  2100000:     18523         0         0         0     4275
> /sys/devices/system/cpu/cpu0/cpufreq/stats/trans_table:  1400000:    301168         0         0         0
> /sys/devices/system/cpu/cpu0/cpufreq/stats/total_trans:799918
>
> Show me the policy tunables here.

All files which are directly present in cpu/cpu*/cpufreq/ folder. I am not
talking about governor tunables but policy tunables. Things like
scaling_[min]max_freq are policy tunables.

>> That was slightly confusing to me :( The whole governor directory
>> is per policy, i have to keep that in cpu/cpu*/cpufreq instead of
>> cpu/cpufreq.
>
> So make a /sys/devices/system/cpu/cpufreq/policies/ and add
> functionality to assign cpus to policies or whatever the design of this
> thing will be.

Policies don't have a name associated with them and so cpu/cpufreq/policies
doesn't make any sense. Rather one policy is related to multiple cpus and
its tunables are linked in all the cpus that belong to it, like
scaling_[min]max_freq.

>> Its not only for multicluster system, but a system where multiple cpus
>> have separate clock control and hence multiple policy structures.
>
> What are those systems? Examples?

Don't have examples of these, but there can be few. Over that it is
a must for multicluster systems as clusters normally have separate
clock control.

>> Problem with this is it would fail for single image solutions on which
>> everybody is working on. So, with multiple platforms compiled into a
>> single image, this wouldn't work.
>
> Single-image solutions will enable that config option and get built with
> it - no problem at all.

But then we will get governors tunables in cpu/cpu*/cpufreq/ instead of
cpu/cpufreq/ . Will that not break userspace for other systems?
