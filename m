Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbaCGS4X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 13:56:23 -0500
Received: from mga11.intel.com ([192.55.52.93]:31185 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138AbaCGS4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 13:56:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,609,1389772800"; 
   d="scan'208";a="488097994"
Message-ID: <531A164B.8040402@linux.intel.com>
Date: Fri, 07 Mar 2014 10:56:11 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: Andreas Herrmann <andreas.herrmann3@amd.com>,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Yinghai Lu <yhlu.kernel@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [qemu64,+smep,+smap] WARNING: CPU: 1 PID: 0 at arch/x86/kernel/cpu/amd.c:220
 init_amd()
References: <20140307015833.GA10048@localhost> <53195336.9080606@linux.intel.com> <20140307055035.GA5230@localhost>
In-Reply-To: <20140307055035.GA5230@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2014 09:50 PM, Fengguang Wu wrote:
>>
>> Unfortunately these things are hard to fix in Qemu.
> 
> OK. As an alternative, is it possible to pass one of the below CPUID flags in
> the Qemu command line, so as to quiet the warning?
> 

I don't see the AMD SMP CPUID flag in there.

Boris, could you help?  The problem is that "qemu -cpu
qemu64,+smep,+smap" identifies as an AMD CPU which triggers a
warning/taint because the SMP flag isn't set.

> 
> Recognized CPUID flags:
>   pbe ia64 tm ht ss sse2 sse fxsr mmx acpi ds clflush pn pse36 pat cmov mca pge mtrr sep apic cx8 mce pae msr tsc pse de vme fpu
>   hypervisor rdrand f16c avx osxsave xsave aes tsc-deadline popcnt movbe x2apic sse4.2|sse4_2 sse4.1|sse4_1 dca pcid pdcm xtpr cx16 fma cid ssse3 tm2 est smx vmx ds_cpl monitor dtes64 pclmulqdq|pclmuldq pni|sse3
>   smap adx rdseed rtm invpcid erms bmi2 smep avx2 hle bmi1 fsgsbase
>   3dnow 3dnowext lm|i64 rdtscp pdpe1gb fxsr_opt|ffxsr mmxext nx|xd syscall
>   perfctr_nb perfctr_core topoext tbm nodeid_msr tce fma4 lwp wdt skinit xop ibs osvw 3dnowprefetch misalignsse sse4a abm cr8legacy extapic svm cmp_legacy lahf_lm
>   pmm-en pmm phe-en phe ace2-en ace2 xcrypt-en xcrypt xstore-en xstore
>   kvm_pv_eoi kvm_steal_time kvm_asyncpf kvmclock kvm_mmu kvm_nopiodelay kvmclock
>   pfthreshold pause_filter decodeassists flushbyasid vmcb_clean tsc_scale nrip_save svm_lock lbrv npt
> 

	-hpa


