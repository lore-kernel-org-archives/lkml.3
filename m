Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359AbaDBXaN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 19:30:13 -0400
Received: from mail1.windriver.com ([147.11.146.13]:54273 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758819AbaDBXaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 19:30:10 -0400
Message-ID: <533C9D8E.7030406@windriver.com>
Date: Wed, 2 Apr 2014 19:30:22 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "Brown, Len" <len.brown@intel.com>
CC: "WYSOCKI, RAFAL" <rafael.j.wysocki@intel.com>,
        Arne Bockholdt <linux-kernel@bockholdt.com>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Regression in intel_idle on Avaton/Rangely Mohon Peak board
References: <533B0288.2020304@windriver.com> <1A7043D5F58CCB44A599DFD55ED4C948452FD582@FMSMSX106.amr.corp.intel.com> <533C6C90.3000708@windriver.com> <20140402203130.GA22525@windriver.com> <1A7043D5F58CCB44A599DFD55ED4C948452FDABF@FMSMSX106.amr.corp.intel.com>
In-Reply-To: <1A7043D5F58CCB44A599DFD55ED4C948452FDABF@FMSMSX106.amr.corp.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.56.57]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-04-02 05:58 PM, Brown, Len wrote:
>> [    0.840668] intel_idle: lapic_timer_reliable_states 0x2
> vs.
>> [    0.877528] intel_idle: lapic_timer_reliable_states 0xffffffff
> 
> This means CPUID.ARAT is set for the new board, and not set
> for the old board.  You can observe that also in /proc/cpuinfo flags
> where you will likely also find a visible stepping difference between
> these two boards.

Stepping is same, but ucode is different:

-microcode      : 0x7
+microcode      : 0xc
-bogomips       : 3399.78
+bogomips       : 4787.51
-cpu MHz                : 1700.000
+cpu MHz                : 2393.759

...and the newer core has "nonstop_tsc" and "arat" as you'd guessed.

> 
> Bring-up Avoton had ARAT disabled, and also had broken deep C-states.
> It looks like that is what your old board has.  Throw it away and
> use only production steppings.  If you are stuck w/ pre-production hardware,

Yep, understood (and expected) -- that is why I'd mentioned at the
beginning that "It may be that this early board/early bios makes it
a non-issue for mainline..."

> then you need to manually modify upstream Linux to make it happy --
> since upstream Linux only cares about production hardware.

Actually it turns out that the defconfig boots okay because it doesn't
use CONFIG_INTEL_IDLE, so that, or the command line max_cstate are
two easy work-arounds if others are stuck on the pre production kit.

Thanks for the suggestions and the final diagnosis.  The full cpuinfo
is below if there is anything you wanted to also see.

Paul.
---

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 77
model name      : Genuine Intel(R) CPU   4000  @ 1.70GHz
stepping        : 0
microcode       : 0x7
cpu MHz         : 1700.000
cache size      : 1024 KB
physical id     : 0
siblings        : 8
core id         : 0
cpu cores       : 8
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 11
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est ssse3 cx16 xtpr pdcm sse4_1 sse4_2 movbe popcnt tsc_deadline_timer aes rdrand lahf_lm 3dnowprefetch dtherm tpr_shadow vnmi flexpriority ept vpid tsc_adjust smep erms
bogomips        : 3399.78
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:
