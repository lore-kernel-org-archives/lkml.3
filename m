Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353Ab3K0Si1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 13:38:27 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:44765 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab3K0SiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 13:38:25 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1311271328590.22932@pianoman.cluster.toy>
References: <1384275531-10892-1-git-send-email-eranian@google.com>
	<1384275531-10892-4-git-send-email-eranian@google.com>
	<alpine.DEB.2.02.1311271328590.22932@pianoman.cluster.toy>
Date: Wed, 27 Nov 2013 19:38:25 +0100
Message-ID: <CABPqkBScotKO03hTA6YNcD4sDVj_Gx1fjicmWOJh_MBYTF+rfQ@mail.gmail.com>
Subject: Re: [PATCH v7 3/4] perf,x86: add Intel RAPL PMU support
From: Stephane Eranian <eranian@google.com>
To: Vince Weaver <vince@deater.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, "Yan, Zheng" <zheng.z.yan@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 7:35 PM, Vince Weaver <vince@deater.net> wrote:
> On Tue, 12 Nov 2013, Stephane Eranian wrote:
>
>> This patch adds a new uncore PMU to expose the Intel
>> RAPL energy consumption counters. Up to 3 counters,
>> each counting a particular RAPL event are exposed.
>>
>> The RAPL counters are available on Intel SandyBridge,
>> IvyBridge, Haswell. The server skus add a 3rd counter.
>
> So I notice PP1 (which is the GPU power on non-server chips)
> is not supported.
>
> Is that just for simplicity?
>
Does it work on specific models only? I bet so. How to detect those?

>> The following events are available and exposed in sysfs:
>> - power/energy-cores: power consumption of all cores on socket
>> - power/energy-pkg: power consumption of all cores + LLc cache
>> - power/energy-dram: power consumption of DRAM (servers only)
>
> This "power" naming seems a bit generic.  If other hardware has power
> measurements can they be put in the same directory?
> power/gpu? power/usb?
>
I think so.

> Also, can support for reading the power from other vendors be put here?
> Like AMDs (unfortunately named) APM (active power management) power
> readings?
>
>> Files are:
>>       /sys/devices/power/events/energy-*.unit
>>       /sys/devices/power/events/energy-*.scale
>
> Are all of these sys files having documentation added under
> Documentation/ABI?
>
Not yet.

>> The RAPL PMU is uncore by nature and is implemented such
>> that it only works in system-wide mode. Measuring only
>> one CPU per socket is sufficient. The /sys/devices/power/cpumask
>> file can be used by tools to figure out which CPUs to monitor
>> by default. For instance, on a 2-socket system, 2 CPUs
>> (one on each socket) will be shown.
>
> do the measurements require CAP_SYS_ADMIN like other system-wide uncore
> measurements?  It didn't look like it in the patch but I might have missed
> it.
>
Measurements are limited to system-wide counting. Thus, you need
CAP_SYS_ADMIN.

> I'm sure the security people will start making claims that you can make
> guesses about password encryption algorithms based on the global power
> consumption numbers.
>
>
> Sorry if these are annoying questions, I am glad to see this driver make
> progress, as I've had the misfortune of maintaining various user-space-MSR
> hacks designed to get this info because of lack of kernel support.
>
You don't really need a driver, you can also just use modprobe msr + the
turbostat utility now part of the kernel source tree. It taps into the same
counters.
