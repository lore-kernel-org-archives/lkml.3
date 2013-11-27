Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259Ab3K0SdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 13:33:19 -0500
Received: from smtpauth02.mfg.siteprotect.com ([64.26.60.136]:33242 "EHLO
	smtpauth02.mfg.siteprotect.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752446Ab3K0SdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 13:33:16 -0500
Date: Wed, 27 Nov 2013 13:35:35 -0500 (EST)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Stephane Eranian <eranian@google.com>
cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, acme@redhat.com, jolsa@redhat.com,
        zheng.z.yan@intel.com, bp@alien8.de, maria.n.dimakopoulou@gmail.com
Subject: Re: [PATCH v7 3/4] perf,x86: add Intel RAPL PMU support
In-Reply-To: <1384275531-10892-4-git-send-email-eranian@google.com>
Message-ID: <alpine.DEB.2.02.1311271328590.22932@pianoman.cluster.toy>
References: <1384275531-10892-1-git-send-email-eranian@google.com> <1384275531-10892-4-git-send-email-eranian@google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020202.52963AEC.0055,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Nov 2013, Stephane Eranian wrote:

> This patch adds a new uncore PMU to expose the Intel
> RAPL energy consumption counters. Up to 3 counters,
> each counting a particular RAPL event are exposed.
> 
> The RAPL counters are available on Intel SandyBridge,
> IvyBridge, Haswell. The server skus add a 3rd counter.

So I notice PP1 (which is the GPU power on non-server chips) 
is not supported.

Is that just for simplicity?

> The following events are available and exposed in sysfs:
> - power/energy-cores: power consumption of all cores on socket
> - power/energy-pkg: power consumption of all cores + LLc cache
> - power/energy-dram: power consumption of DRAM (servers only)

This "power" naming seems a bit generic.  If other hardware has power
measurements can they be put in the same directory?
power/gpu? power/usb?

Also, can support for reading the power from other vendors be put here?
Like AMDs (unfortunately named) APM (active power management) power
readings?

> Files are:
> 	/sys/devices/power/events/energy-*.unit
> 	/sys/devices/power/events/energy-*.scale

Are all of these sys files having documentation added under 
Documentation/ABI?

> The RAPL PMU is uncore by nature and is implemented such
> that it only works in system-wide mode. Measuring only
> one CPU per socket is sufficient. The /sys/devices/power/cpumask
> file can be used by tools to figure out which CPUs to monitor
> by default. For instance, on a 2-socket system, 2 CPUs
> (one on each socket) will be shown.

do the measurements require CAP_SYS_ADMIN like other system-wide uncore 
measurements?  It didn't look like it in the patch but I might have missed 
it.

I'm sure the security people will start making claims that you can make 
guesses about password encryption algorithms based on the global power 
consumption numbers.


Sorry if these are annoying questions, I am glad to see this driver make 
progress, as I've had the misfortune of maintaining various user-space-MSR 
hacks designed to get this info because of lack of kernel support.

Vince
