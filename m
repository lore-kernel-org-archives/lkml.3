Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483Ab3EHNVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 09:21:31 -0400
Received: from mail-a03.ithnet.com ([217.64.83.98]:42443 "HELO ithnet.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754935Ab3EHNVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 09:21:30 -0400
X-Sender-Authentication: SMTP AUTH verified <skraw>
Date: Wed, 8 May 2013 15:21:25 +0200
From: Stephan von Krawczynski <skraw@ithnet.com>
To: linux-kernel@vger.kernel.org
Subject: acpi_cpufreq on Intel(R) Core(TM)2 Quad CPU  Q6600  @ 2.40GHz
 problem (3.[4-9].X)
Message-Id: <20130508152125.f48b7b55.skraw@ithnet.com>
Organization: ith Kommunikationstechnik GmbH
X-Mailer: Sylpheed 3.1.2 (GTK+ 2.24.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I see some kind of bug with acpi_cpufreq on Intels Q6600 cpus. If you load the
module you see this in proc:

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz
stepping        : 11
cpu MHz         : 600.000
cache size      : 4096 KB
physical id     : 0
siblings        : 4
core id         : 0
cpu cores       : 4
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm
constant_tsc arch_perfmon pebs bts rep_good nopl aperfmperf pni dtes64 monitor
ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm lahf_lm dtherm tpr_shadow vnmi
flexpriority bogomips        : 4800.22 clflush size    : 64 cache_alignment :
64 address sizes   : 36 bits physical, 48 bits virtual power management:

(repeated for other cores)

As you can see cpu MHz shows 600. Now take a look at cpufreq-info output and
see:

hardware limits: 600 MHz - 900 MHz

Obviously this is wrong, I don't know what the minimum should be, but the max
should be 2.40 GHz. If you stress the cpu you will notice MHz go up to 900,
but that's it. I have several such boxes, and all act the same with all
kernels I tried so far (3.4.X, 3.8.X, 3.9.X).
If you unload acpi_cpufreq you see the correct values. To me seems to be no
display problem. The box "feels" slower when the module is loaded.
With a cpu type Q9300 btw everything works as expected.
If there are ideas or patches to test how to remove this problem, feel free to
mail/cc me. I can check out whatever looks promising.

-- 
Regards,
Stephan
