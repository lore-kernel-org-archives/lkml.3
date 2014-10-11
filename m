Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290AbaJKNQZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 09:16:25 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:49325 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbaJKNQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 09:16:24 -0400
Date: Sat, 11 Oct 2014 15:16:21 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm64: Fix compile error seen in non-SMP builds
Message-ID: <20141011131618.GA4043@lerouge>
References: <1412990134-31186-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1412990134-31186-1-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 06:15:34PM -0700, Guenter Roeck wrote:
> Fix:
> 
> In file included from ./arch/arm64/include/asm/irq_work.h:4:0,
>         from include/linux/irq_work.h:46,
>         from include/linux/perf_event.h:49,
>         from include/linux/ftrace_event.h:9,
>         from include/trace/syscall.h:6,
>         from include/linux/syscalls.h:81,
>         from init/main.c:18:
> ./arch/arm64/include/asm/smp.h:24:3:
> 	error: #error "<asm/smp.h> included in non-SMP build"
>  # error "<asm/smp.h> included in non-SMP build"
>    ^
> ./arch/arm64/include/asm/smp.h:27:0: warning: "raw_smp_processor_id" redefined
>  #define raw_smp_processor_id() (current_thread_info()->cpu)
>  ^
> 
> and:
> 
> In file included from ./arch/arm64/include/asm/irq_work.h:4:0,
>         from include/linux/irq_work.h:46,
>         from kernel/irq_work.c:11:
> ./arch/arm64/include/asm/smp_plat.h:56:30:
>         error: ‘NR_CPUS’ undeclared here (not in a function)
>         extern u64 __cpu_logical_map[NR_CPUS];
> 
> by providing a helper function in smp_plat.h, similar to the arm implementation,
> and by removing NR_CPUS from smp_plat.h.
> 
> Fixes: 3631073659d0 ("arm64: Tell irq work about self IPI support")
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

That looks good to me.

Note, ARM64 is one of the archs I couldn't test due to the lack of a
nolibc cross compiler in https://www.kernel.org/pub/tools/crosstool/

Thanks!
