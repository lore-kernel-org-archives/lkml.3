Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbaE3R4g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 13:56:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:41025 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525AbaE3R4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 13:56:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,942,1392192000"; 
   d="scan'208";a="549040344"
Subject: Re: [RFC PATCH] crypto: crc32c-pclmul - Use pmovzxdq to shrink
 K_table
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Dave Jones <davej@redhat.com>,
        "dirk.brandewie@gmail.com" <dirk.brandewie@gmail.com>
Cc: George Spelvin <linux@horizon.com>, herbert@gondor.apana.org.au,
        james.guilford@intel.com, JBeulich@suse.com,
        linux-kernel@vger.kernel.org, Jacob jun Pan <jacob.jun.pan@intel.com>
In-Reply-To: <20140530011636.GA31694@redhat.com>
References: <20140529235432.19207.qmail@ns.horizon.com>
	 <1401412036.2970.459.camel@schen9-DESK> <20140530011636.GA31694@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 May 2014 10:56:32 -0700
Message-ID: <1401472592.2970.483.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-05-29 at 21:16 -0400, Dave Jones wrote:
> On Thu, May 29, 2014 at 06:07:16PM -0700, Tim Chen wrote:
>  > On Thu, 2014-05-29 at 19:54 -0400, George Spelvin wrote:
>  > > Sorry for the delay; my Ivy Bridge test machine isn't in my
>  > > office and getting to the console to tweak the BIOS is a
>  > > bit of a bother.
>  > > 
>  > > Anyway, i7-4930K, turbo boost & hyperthreading disabled,
>  > > $ cat /sys/devices/system/cpu/cpu?/cpufreq/scaling_governor
>  > > performance
>  > > performance
>  > > performance
>  > > performance
>  > > performance
>  > > performance
>  > > 
>  > > Oddly, though, CPU speed still seems to be fluctuating:
>  > > $ grep MHz /proc/cpuinfo
>  > > cpu MHz         : 1255.875
>  > > cpu MHz         : 3168.375
>  > > cpu MHz         : 3062.125
>  > > cpu MHz         : 1468.375
>  > > cpu MHz         : 1309.000
>  > > cpu MHz         : 2212.125
>  > > $ grep MHz /proc/cpuinfo
>  > > cpu MHz         : 1255.875
>  > > cpu MHz         : 2690.250
>  > > cpu MHz         : 1255.875
>  > > cpu MHz         : 2530.875
>  > > cpu MHz         : 2212.125
>  > > cpu MHz         : 1521.500
>  > 
>  > This is odd.  On my Ivy Bridge system the CPU speed from /proc/cpuinfo 
>  > is at max freq once I set the performance governor.  
>  > The numbers above almost look like
>  > the cpu frequency is fluctuating and an average is taken.
>  > What version of the kernel are you running?  Is 
>  > CONFIG_CPU_FREQ_GOV_PERFORMANCE compiled in?
>  > 
>  > Does /sys/devices/system/cpu/cpu?/cpufreq/scaling_cur_freq
>  > also changes?
>  > 
>  > Can you check what are the available governors in your system
>  > and available frequencies?
>  > 
>  > cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors
>  > cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies
>  > 
>  > If userspace governor is available, you can try set the governor
>  > to userspace, then pin frequency to 3400 MHz (assuming that's your
>  > max) with command like:
>  
> intel_pstate overrides any governor choice you make through sysfs.
> 
> 	Dave
> 

Dirk,

Wonder if this the right behavior for intel_pstate that when I set the 
governor to performance, intel_pstate driver still adjusts 
the cpu frequencies around?

Turbotstat also confirms that the frequencies are not at max,
even though the max_perf_pct and min_perf_pct are both set at 100.  

I ran on my HSW system with 3.15-rc7 kernel and see similar
issue that Geroge reported.

It is really a pain when we need to do performance benchmarking and 
need to have a constant cpu frequency.  

Thanks.

Tim

