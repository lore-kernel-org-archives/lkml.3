Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965893AbaFTUHk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 16:07:40 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:61458 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757540AbaFTUHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 16:07:39 -0400
Message-ID: <53A49488.6050902@gmail.com>
Date: Fri, 20 Jun 2014 13:07:36 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>, linux-mips <linux-mips@linux-mips.org>
CC: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH 19/31] MIPS: Replace __get_cpu_var uses in FPU emulator.
References: <20140620193115.547427118@linux.com> <20140620193127.123705312@linux.com>
In-Reply-To: <20140620193127.123705312@linux.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ linux-mips@linux-mips.org, as that is the main MIPS patch reviewing list.

On 06/20/2014 12:31 PM, Christoph Lameter wrote:
> From: David Daney<david.daney@cavium.com>
>
> The use of __this_cpu_inc() requires a fundamental integer type, so
> change the type of all the counters to unsigned long, which is the
> same width they were before, but not wrapped in local_t.
>
> Signed-off-by: David Daney<david.daney@cavium.com>
> Signed-off-by: Christoph Lameter<cl@linux.com>
> ---
>   arch/mips/include/asm/fpu_emulator.h | 14 +++++++-------
>   arch/mips/math-emu/cp1emu.c          |  6 +++---
>   2 files changed, 10 insertions(+), 10 deletions(-)
>
> Index: linux/arch/mips/include/asm/fpu_emulator.h
> ===================================================================
> --- linux.orig/arch/mips/include/asm/fpu_emulator.h	2014-06-16 09:15:42.199326017 -0500
> +++ linux/arch/mips/include/asm/fpu_emulator.h	2014-06-16 09:17:42.776959733 -0500
> @@ -33,17 +33,17 @@
>   #ifdef CONFIG_DEBUG_FS
>
>   struct mips_fpu_emulator_stats {
> -	local_t emulated;
> -	local_t loads;
> -	local_t stores;
> -	local_t cp1ops;
> -	local_t cp1xops;
> -	local_t errors;
> -	local_t ieee754_inexact;
> -	local_t ieee754_underflow;
> -	local_t ieee754_overflow;
> -	local_t ieee754_zerodiv;
> -	local_t ieee754_invalidop;
> +	unsigned long emulated;
> +	unsigned long loads;
> +	unsigned long stores;
> +	unsigned long cp1ops;
> +	unsigned long cp1xops;
> +	unsigned long errors;
> +	unsigned long ieee754_inexact;
> +	unsigned long ieee754_underflow;
> +	unsigned long ieee754_overflow;
> +	unsigned long ieee754_zerodiv;
> +	unsigned long ieee754_invalidop;
>   };
>
>   DECLARE_PER_CPU(struct mips_fpu_emulator_stats, fpuemustats);
> @@ -51,7 +51,7 @@
>   #define MIPS_FPU_EMU_INC_STATS(M)					\
>   do {									\
>   	preempt_disable();						\
> -	__local_inc(&__get_cpu_var(fpuemustats).M);			\
> +	__this_cpu_inc(fpuemustats.M);					\
>   	preempt_enable();						\
>   } while (0)
>
>

