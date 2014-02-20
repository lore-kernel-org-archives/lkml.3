Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbaBTIiZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 03:38:25 -0500
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:55160 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060AbaBTIiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 03:38:22 -0500
Date: Thu, 20 Feb 2014 09:38:16 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: linux-kernel@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux390@de.ibm.com, linux-s390@vger.kernel.org
Subject: Re: [PATCH RFC/RFT v3 4/9] s390: move cacheinfo sysfs to generic
 cacheinfo infrastructure
Message-ID: <20140220083816.GA4203@osiris>
References: <1392825976-17633-1-git-send-email-sudeep.holla@arm.com>
 <1392825976-17633-5-git-send-email-sudeep.holla@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392825976-17633-5-git-send-email-sudeep.holla@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022008-1948-0000-0000-000007DF9390
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 04:06:11PM +0000, Sudeep Holla wrote:
> From: Sudeep Holla <sudeep.holla@arm.com>
> 
> This patch removes the redundant sysfs cacheinfo code by making use of
> the newly introduced generic cacheinfo infrastructure.
> 
> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: linux390@de.ibm.com
> Cc: linux-s390@vger.kernel.org
> ---
>  arch/s390/kernel/cache.c | 388 ++++++++++++-----------------------------------
>  1 file changed, 93 insertions(+), 295 deletions(-)

(FWIW, if you send an update of your series, please cc me on all patches, so I
 don't have to search LKML for the rest of the patch set)

I gave your patches series a test and I get this nice message on boot:

io scheduler cfq registered
DEBUG_LOCKS_WARN_ON(irqs_disabled_flags(flags))
------------[ cut here ]------------
WARNING: at kernel/locking/lockdep.c:2742
Modules linked in:
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14.0-rc3-00177-g468cee08c2ea #7
task: 0000000000adcc60 ti: 0000000000ac4000 task.ti: 0000000000ac4000
Krnl PSW : 0404c00180000000 000000000019af3e (lockdep_trace_alloc+0x116/0x120)
           R:0 T:1 IO:0 EX:0 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 EA:3
Krnl GPRS: 0000000000000020 0000000000adcc60 000000000000002f 0000000000000000
           000000000019af3a 0000000000000000 0000000000000001 0000000000000000
           000000003ff26140 000000000055fb92 00000000000001b0 00000000000080d0
           0400000000000000 00000000000080d0 000000000019af3a 000000000001bc30
Krnl Code: 000000000019af2e: c020003b1e34       larl    %r2,8feb96
           000000000019af34: c0e5002e0304       brasl   %r14,75b53c
          #000000000019af3a: a7f40001           brc     15,19af3c
          >000000000019af3e: e32003100004       lg      %r2,784
           000000000019af44: a7f4ff9f           brc     15,19ae82
           000000000019af48: e31003100004       lg      %r1,784
           000000000019af4e: e32013f00150       sty     %r2,5104(%r1)
           000000000019af54: 07fe               bcr     15,%r14
Call Trace:
([<000000000019af3a>] lockdep_trace_alloc+0x112/0x120)
 [<000000000027a7d2>] __kmalloc+0x5a/0x204
 [<000000000055fb92>] detect_cache_attributes+0x66/0xd4
 [<000000000055fc2e>] _detect_cache_attributes+0x2e/0x3c
 [<00000000001ce7a2>] generic_smp_call_function_single_interrupt+0x9a/0xe8
 [<000000000010b462>] do_ext_interrupt+0x12a/0x24c
 [<00000000001afab0>] handle_irq_event_percpu+0x70/0x240
 [<00000000001b3218>] handle_percpu_irq+0x6c/0x98
 [<00000000001af16e>] generic_handle_irq+0x46/0x68
 [<000000000010b6c2>] do_IRQ+0x5e/0x84
 [<0000000000768b06>] ext_skip+0x44/0x4a
 [<000000000076827c>] vtime_stop_cpu+0x50/0xa4
([<0000000000768262>] vtime_stop_cpu+0x36/0xa4)
 [<0000000000103848>] arch_cpu_idle+0x6c/0xbc
 [<00000000001af032>] cpu_startup_entry+0x146/0x218
 [<0000000000b64932>] start_kernel+0x3fa/0x408
 [<0000000000100020>] _stext+0x20/0x80
INFO: lockdep is turned off.
Last Breaking-Event-Address:
 [<000000000019af3a>] lockdep_trace_alloc+0x112/0x120
---[ end trace 9c0011ccc7b324d6 ]---
brd: module loaded

In addition /proc/cpuinfo is now incorrect.
With your patches it looks like this:

[root@p2345007 ~]# cat /proc/cpuinfo 
vendor_id       : IBM/S390
# processors    : 4
bogomips per cpu: 18115.00
features        : esan3 zarch stfle msa ldisp eimm dfp etf3eh highgprs 
cache0          : level=1 type=Data scope=Shared size=96K line_size=256 associativity=6
cache1          : level=1 type=Data scope=Shared size=96K line_size=256 associativity=6
cache2          : level=1 type=Data scope=Shared size=96K line_size=256 associativity=6
cache3          : level=1 type=Data scope=Shared size=96K line_size=256 associativity=6
cache4          : level=1 type=Data scope=Shared size=96K line_size=256 associativity=6
cache5          : level=1 type=Data scope=Shared size=96K line_size=256 associativity=6
processor 0: version = FF,  identification = 2F6D15,  machine = 2827
processor 1: version = FF,  identification = 2F6D15,  machine = 2827
processor 2: version = FF,  identification = 2F6D15,  machine = 2827
processor 3: version = FF,  identification = 2F6D15,  machine = 2827

However it is supposed to look like this:

[root@p2345007 ~]# cat /proc/cpuinfo 
vendor_id       : IBM/S390
# processors    : 4
bogomips per cpu: 18115.00
features        : esan3 zarch stfle msa ldisp eimm dfp etf3eh highgprs 
cache0          : level=1 type=Data scope=Private size=96K line_size=256 associativity=6
cache1          : level=1 type=Instruction scope=Private size=64K line_size=256 associativity=4
cache2          : level=2 type=Data scope=Private size=1024K line_size=256 associativity=8
cache3          : level=2 type=Instruction scope=Private size=1024K line_size=256 associativity=8
cache4          : level=3 type=Unified scope=Shared size=49152K line_size=256 associativity=12
cache5          : level=4 type=Unified scope=Shared size=393216K line_size=256 associativity=24
processor 0: version = FF,  identification = 2F6D15,  machine = 2827
processor 1: version = FF,  identification = 2F6D15,  machine = 2827
processor 2: version = FF,  identification = 2F6D15,  machine = 2827
processor 3: version = FF,  identification = 2F6D15,  machine = 2827

The sysfs files and it contents seem to be ok.

