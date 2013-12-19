Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab3LSRqg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 12:46:36 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:55288 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab3LSRqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 12:46:33 -0500
Message-ID: <52B330F3.4090603@gmail.com>
Date: Thu, 19 Dec 2013 09:46:27 -0800
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH 29/40] mips: Replace __get_cpu_var uses
References: <20131219155015.443763038@linux.com> <20131219155033.834416420@linux.com>
In-Reply-To: <20131219155033.834416420@linux.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2013 07:50 AM, Christoph Lameter wrote:
[...]
>
>
> Cc: Ralf Baechle<ralf@linux-mips.org>
> Signed-off-by: Christoph Lameter<cl@linux.com>
>
> Index: linux/arch/mips/include/asm/fpu_emulator.h
> ===================================================================
> --- linux.orig/arch/mips/include/asm/fpu_emulator.h	2013-12-02 16:07:58.254398466 -0600
> +++ linux/arch/mips/include/asm/fpu_emulator.h	2013-12-02 16:07:58.244398747 -0600
> @@ -43,7 +43,7 @@ DECLARE_PER_CPU(struct mips_fpu_emulator
>   #define MIPS_FPU_EMU_INC_STATS(M)					\
>   do {									\
>   	preempt_disable();						\
> -	__local_inc(&__get_cpu_var(fpuemustats).M);			\
> +	__this_cpu_inc(fpuemustats.M);					\
>   	preempt_enable();						\
>   } while (0)
>

Something seems to be incorrect in this bit.

I applied patches 01-16,18-23,25-29  (17 and 24 went missing)

building for arch/mips/configs/cavium_octeon_defconfig, I get:

.
.
.
   CC      arch/mips/math-emu/cp1emu.o
arch/mips/math-emu/cp1emu.c: In function 'cop1Emulate':
arch/mips/math-emu/cp1emu.c:957:1: error: invalid operands to binary + 
(have 'local_t' and 'int')
arch/mips/math-emu/cp1emu.c:957:1: error: invalid operands to binary + 
(have 'local_t' and 'int')
arch/mips/math-emu/cp1emu.c:957:1: error: invalid operands to binary + 
(have 'local_t' and 'int')
arch/mips/math-emu/cp1emu.c:957:1: error: invalid operands to binary + 
(have 'local_t' and 'int')
.
.
.



