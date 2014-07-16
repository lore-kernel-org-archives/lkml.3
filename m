Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400AbaGPTzu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:55:50 -0400
Received: from wolff.to ([98.103.208.27]:46205 "HELO wolff.to"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750791AbaGPTzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:55:48 -0400
Date: Wed, 16 Jul 2014 14:54:14 -0500
From: Bruno Wolff III <bruno@wolff.to>
To: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Josh Boyer <jwboyer@redhat.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Scheduler regression from
 caffcdd8d27ba78730d5540396ce72ad022aff2c
Message-ID: <20140716195414.GA16401@wolff.to>
References: <20140716145546.GA6922@wolff.to>
 <20140716151748.GC2460@hansolo.jdub.homelinux.org>
 <53C6CFCC.2050300@arm.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="82I3+IH0IqGh5yIs"
Content-Disposition: inline
In-Reply-To: <53C6CFCC.2050300@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

On Wed, Jul 16, 2014 at 21:17:32 +0200,
  Dietmar Eggemann <dietmar.eggemann@arm.com> wrote:
>Hi Bruno and Josh,
>
>From the issue, I see that the machine making trouble is an Xeon (2 
>processors w/ hyper-threading).
>
>Could you please share:
>
> cat /proc/cpuinfo and

I have attached it to the bug and to this message.

> cat /proc/schedstat (kernel config w/ CONFIG_SCHEDSTATS=y)

It looks like that isn't set for my previous builds and I'll need to 
set it for my next test build.

>Could you also put the two BUG_ON lines into build_sched_groups() 
>[kernel/sched/core.c] wo/ the cpumask_clear() and setting 
>sg->sgc->capacity to 0 and share the possible crash output as well?

I can try a new build with this. I can probably get results back tomorrow 
before I leave for work. The crashes happen too early in the boot process 
for me to easily capture output as text. I can slow things down to take 
pictures though.

--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="cpuinfo.out"

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 15
model		: 2
model name	: Intel(R) Xeon(TM) CPU 2.66GHz
stepping	: 9
microcode	: 0x2d
cpu MHz		: 2657.830
cache size	: 512 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 1
apicid		: 0
initial apicid	: 0
fdiv_bug	: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 2
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe pebs bts cid xtpr
bogomips	: 5315.66
clflush size	: 64
cache_alignment	: 128
address sizes	: 36 bits physical, 32 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 15
model		: 2
model name	: Intel(R) Xeon(TM) CPU 2.66GHz
stepping	: 9
microcode	: 0x2d
cpu MHz		: 2657.830
cache size	: 512 KB
physical id	: 3
siblings	: 2
core id		: 0
cpu cores	: 1
apicid		: 6
initial apicid	: 6
fdiv_bug	: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 2
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe pebs bts cid xtpr
bogomips	: 5314.67
clflush size	: 64
cache_alignment	: 128
address sizes	: 36 bits physical, 32 bits virtual
power management:

processor	: 2
vendor_id	: GenuineIntel
cpu family	: 15
model		: 2
model name	: Intel(R) Xeon(TM) CPU 2.66GHz
stepping	: 9
microcode	: 0x2d
cpu MHz		: 2657.830
cache size	: 512 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 1
apicid		: 1
initial apicid	: 1
fdiv_bug	: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 2
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe pebs bts cid xtpr
bogomips	: 5314.68
clflush size	: 64
cache_alignment	: 128
address sizes	: 36 bits physical, 32 bits virtual
power management:

processor	: 3
vendor_id	: GenuineIntel
cpu family	: 15
model		: 2
model name	: Intel(R) Xeon(TM) CPU 2.66GHz
stepping	: 9
microcode	: 0x2d
cpu MHz		: 2657.830
cache size	: 512 KB
physical id	: 3
siblings	: 2
core id		: 0
cpu cores	: 1
apicid		: 7
initial apicid	: 7
fdiv_bug	: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 2
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe pebs bts cid xtpr
bogomips	: 5314.68
clflush size	: 64
cache_alignment	: 128
address sizes	: 36 bits physical, 32 bits virtual
power management:


--82I3+IH0IqGh5yIs--
