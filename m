Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757294Ab3E0KDd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 06:03:33 -0400
Received: from intranet.asianux.com ([58.214.24.6]:41201 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755907Ab3E0KDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 06:03:31 -0400
X-Spam-Score: -100.8
Message-ID: <51A32F40.1050309@asianux.com>
Date: Mon, 27 May 2013 18:02:40 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>, Marc Zyngier <Marc.Zyngier@arm.com>
CC: Catalin Marinas <Catalin.Marinas@arm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH v2] arm64: kernel: compiling issue, need delete read_current_timer().
References: <5199C725.8050102@asianux.com> <168084c28e8ba5124c05553e97463172@localhost> <20130520095606.GH31359@mudshark.cambridge.arm.com> <519AF2DC.2040200@asianux.com> <20130521085325.GB10453@mudshark.cambridge.arm.com> <519B425D.4030806@asianux.com>
In-Reply-To: <519B425D.4030806@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Maintainers:

Please help check this patch whether OK, when you have time.

Thanks.

On 05/21/2013 05:46 PM, Chen Gang wrote:
> 
> Under arm64, we will calibrate the delay loop statically using a known
> timer frequency, so delete read_current_timer(), or it will cause
> compiling issue with allmodconfig.
> 
> The related error:
>   ERROR: "read_current_timer" [lib/rbtree_test.ko] undefined!
>   ERROR: "read_current_timer" [lib/interval_tree_test.ko] undefined!
>   ERROR: "read_current_timer" [fs/ext4/ext4.ko] undefined!
>   ERROR: "read_current_timer" [crypto/tcrypt.ko] undefined!
> 
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  arch/arm64/include/asm/timex.h |    6 +++---
>  arch/arm64/kernel/time.c       |    6 ------
>  2 files changed, 3 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/timex.h b/arch/arm64/include/asm/timex.h
> index b24a31a..81a076e 100644
> --- a/arch/arm64/include/asm/timex.h
> +++ b/arch/arm64/include/asm/timex.h
> @@ -16,14 +16,14 @@
>  #ifndef __ASM_TIMEX_H
>  #define __ASM_TIMEX_H
>  
> +#include <asm/arch_timer.h>
> +
>  /*
>   * Use the current timer as a cycle counter since this is what we use for
>   * the delay loop.
>   */
> -#define get_cycles()	({ cycles_t c; read_current_timer(&c); c; })
> +#define get_cycles()	arch_counter_get_cntvct()
>  
>  #include <asm-generic/timex.h>
>  
> -#define ARCH_HAS_READ_CURRENT_TIMER
> -
>  #endif
> diff --git a/arch/arm64/kernel/time.c b/arch/arm64/kernel/time.c
> index a551f88..03dc371 100644
> --- a/arch/arm64/kernel/time.c
> +++ b/arch/arm64/kernel/time.c
> @@ -68,12 +68,6 @@ unsigned long long notrace sched_clock(void)
>  	return arch_timer_read_counter() * sched_clock_mult;
>  }
>  
> -int read_current_timer(unsigned long *timer_value)
> -{
> -	*timer_value = arch_timer_read_counter();
> -	return 0;
> -}
> -
>  void __init time_init(void)
>  {
>  	u32 arch_timer_rate;
> 


-- 
Chen Gang

Asianux Corporation
