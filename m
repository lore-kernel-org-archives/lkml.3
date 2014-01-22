Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234AbaAVTSA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 14:18:00 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:53567 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720AbaAVTR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 14:17:59 -0500
MIME-Version: 1.0
In-Reply-To: <20140122184511.GB389@x4>
References: <52DEF495.2020304@oracle.com>
	<20140122104532.GJ31570@twins.programming.kicks-ass.net>
	<20140122120048.GB389@x4>
	<20140122120757.GL31570@twins.programming.kicks-ass.net>
	<20140122122609.GA392@x4>
	<20140122123022.GN31570@twins.programming.kicks-ass.net>
	<20140122131456.GA389@x4>
	<52DFD50E.800@oracle.com>
	<20140122183538.GA389@x4>
	<20140122184253.GN30183@twins.programming.kicks-ass.net>
	<20140122184511.GB389@x4>
Date: Wed, 22 Jan 2014 14:17:58 -0500
X-Google-Sender-Auth: pGLVHQaXn1XrG_PS5hkJ_aT10pw
Message-ID: <CA+5PVA5pO_SWpfLGEwWHXDTFyANsiyWYo_t5R3pGj4TOhDgbOA@mail.gmail.com>
Subject: Re: [PATCH 13/15] sched: Use a static_key for sched_clock_stable
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Arjan van de Ven <arjan@linux.intel.com>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        Zhang Rui <rui.zhang@intel.com>, jacob.jun.pan@linux.intel.com,
        Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@amacapital.net>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Dave Young <dyoung@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 1:45 PM, Markus Trippelsdorf
<markus@trippelsdorf.de> wrote:
> On 2014.01.22 at 19:42 +0100, Peter Zijlstra wrote:
>> On Wed, Jan 22, 2014 at 07:35:38PM +0100, Markus Trippelsdorf wrote:
>>
>> > >FYI it happens on real hardware on my machine:
>>
>> > >[   60.375384] process: using AMD E400 aware idle routine
>>
>> > But this is a different issue. I've bisected it to:
>> >
>> > commit 20d1c86a57762f0a33a78988e3fc8818316badd4
>> > Author: Peter Zijlstra <peterz@infradead.org>
>> > Date:   Fri Nov 29 15:40:29 2013 +0100
>> >
>> >     sched/clock, x86: Rewrite cyc2ns() to avoid the need to disable IRQs
>> >
>> > Reverting the commit "fixes" the issue:
>>
>> Hurm.. what kind of AMD machine is that?
>
> It's an ancient one:
>
> processor       : 0
> vendor_id       : AuthenticAMD
> cpu family      : 16
> model           : 4
> model name      : AMD Phenom(tm) II X4 955 Processor
> stepping        : 2
> microcode       : 0x10000db
> cpu MHz         : 800.000
> cache size      : 512 KB
> physical id     : 0
> siblings        : 4
> core id         : 0
> cpu cores       : 4
> apicid          : 0
> initial apicid  : 0
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 5
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm 3dnowext 3
> dnow constant_tsc rep_good nopl nonstop_tsc extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit
> wdt hw_pstate npt lbrv svm_lock nrip_save
> bogomips        : 6424.73
> TLB size        : 1024 4K pages
> clflush size    : 64
> cache_alignment : 64
> address sizes   : 48 bits physical, 48 bits virtual
> power management: ts ttp tm stc 100mhzsteps hwpstate

I'm seeing the odd printk timestamp jump going from 0.xxx to 49.xx on
an i7-2600 so it isn't just old hardware.

[    0.000000] kmemleak: Kernel memory leak detector disabled
[    0.000000] ODEBUG: 32 of 32 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.001000] tsc: Detected 3392.351 MHz processor
[   49.777360] Calibrating delay loop (skipped), value calculated
using timer frequency.. 6784.70 BogoMIPS (lpj=3392351)
[   49.777363] pid_max: default: 32768 minimum: 301
[   49.777572] Security Framework initialized


josh
