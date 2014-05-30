Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbaE3BRo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 21:17:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9369 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753306AbaE3BRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 21:17:42 -0400
Date: Thu, 29 May 2014 21:16:36 -0400
From: Dave Jones <davej@redhat.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: George Spelvin <linux@horizon.com>, herbert@gondor.apana.org.au,
        james.guilford@intel.com, JBeulich@suse.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] crypto: crc32c-pclmul - Use pmovzxdq to shrink
 K_table
Message-ID: <20140530011636.GA31694@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	George Spelvin <linux@horizon.com>, herbert@gondor.apana.org.au,
	james.guilford@intel.com, JBeulich@suse.com,
	linux-kernel@vger.kernel.org
References: <20140529235432.19207.qmail@ns.horizon.com>
 <1401412036.2970.459.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401412036.2970.459.camel@schen9-DESK>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 06:07:16PM -0700, Tim Chen wrote:
 > On Thu, 2014-05-29 at 19:54 -0400, George Spelvin wrote:
 > > Sorry for the delay; my Ivy Bridge test machine isn't in my
 > > office and getting to the console to tweak the BIOS is a
 > > bit of a bother.
 > > 
 > > Anyway, i7-4930K, turbo boost & hyperthreading disabled,
 > > $ cat /sys/devices/system/cpu/cpu?/cpufreq/scaling_governor
 > > performance
 > > performance
 > > performance
 > > performance
 > > performance
 > > performance
 > > 
 > > Oddly, though, CPU speed still seems to be fluctuating:
 > > $ grep MHz /proc/cpuinfo
 > > cpu MHz         : 1255.875
 > > cpu MHz         : 3168.375
 > > cpu MHz         : 3062.125
 > > cpu MHz         : 1468.375
 > > cpu MHz         : 1309.000
 > > cpu MHz         : 2212.125
 > > $ grep MHz /proc/cpuinfo
 > > cpu MHz         : 1255.875
 > > cpu MHz         : 2690.250
 > > cpu MHz         : 1255.875
 > > cpu MHz         : 2530.875
 > > cpu MHz         : 2212.125
 > > cpu MHz         : 1521.500
 > 
 > This is odd.  On my Ivy Bridge system the CPU speed from /proc/cpuinfo 
 > is at max freq once I set the performance governor.  
 > The numbers above almost look like
 > the cpu frequency is fluctuating and an average is taken.
 > What version of the kernel are you running?  Is 
 > CONFIG_CPU_FREQ_GOV_PERFORMANCE compiled in?
 > 
 > Does /sys/devices/system/cpu/cpu?/cpufreq/scaling_cur_freq
 > also changes?
 > 
 > Can you check what are the available governors in your system
 > and available frequencies?
 > 
 > cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors
 > cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies
 > 
 > If userspace governor is available, you can try set the governor
 > to userspace, then pin frequency to 3400 MHz (assuming that's your
 > max) with command like:
 
intel_pstate overrides any governor choice you make through sysfs.

	Dave

