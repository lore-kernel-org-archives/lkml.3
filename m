Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519AbaJKOty (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 10:49:54 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:49956 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268AbaJKOtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 10:49:53 -0400
Message-ID: <5439438A.9090407@roeck-us.net>
Date: Sat, 11 Oct 2014 07:49:46 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm64: Fix compile error seen in non-SMP builds
References: <1412990134-31186-1-git-send-email-linux@roeck-us.net> <20141011131618.GA4043@lerouge>
In-Reply-To: <20141011131618.GA4043@lerouge>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020206.54394390.0058,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 1
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2014 06:16 AM, Frederic Weisbecker wrote:
> On Fri, Oct 10, 2014 at 06:15:34PM -0700, Guenter Roeck wrote:
>> Fix:
>>
>> In file included from ./arch/arm64/include/asm/irq_work.h:4:0,
>>          from include/linux/irq_work.h:46,
>>          from include/linux/perf_event.h:49,
>>          from include/linux/ftrace_event.h:9,
>>          from include/trace/syscall.h:6,
>>          from include/linux/syscalls.h:81,
>>          from init/main.c:18:
>> ./arch/arm64/include/asm/smp.h:24:3:
>> 	error: #error "<asm/smp.h> included in non-SMP build"
>>   # error "<asm/smp.h> included in non-SMP build"
>>     ^
>> ./arch/arm64/include/asm/smp.h:27:0: warning: "raw_smp_processor_id" redefined
>>   #define raw_smp_processor_id() (current_thread_info()->cpu)
>>   ^
>>
>> and:
>>
>> In file included from ./arch/arm64/include/asm/irq_work.h:4:0,
>>          from include/linux/irq_work.h:46,
>>          from kernel/irq_work.c:11:
>> ./arch/arm64/include/asm/smp_plat.h:56:30:
>>          error: ‘NR_CPUS’ undeclared here (not in a function)
>>          extern u64 __cpu_logical_map[NR_CPUS];
>>
>> by providing a helper function in smp_plat.h, similar to the arm implementation,
>> and by removing NR_CPUS from smp_plat.h.
>>
>> Fixes: 3631073659d0 ("arm64: Tell irq work about self IPI support")
>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>
> That looks good to me.
>
> Note, ARM64 is one of the archs I couldn't test due to the lack of a
> nolibc cross compiler in https://www.kernel.org/pub/tools/crosstool/
>
No worries. Even if you had, you might not have caught the non-SMP case.
I only recently added a non-SMP build myself.

Is the toolchain issue out of principle (not wanting to use a cross
compiler that includes glibc) or because you did not find a cross
compiler ? Linaro provides toolchains for aarch64, though they are
only 32 bit. I built one myself using buildroot (select binutils 2.24
and gcc 4.9.1).

In general I have been quite successful using buildroot to create
toolchains, including ones for oddball architectures like score
(after patching buildroot to support it, of course).

Guenter

