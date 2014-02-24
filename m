Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922AbaBXH22 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 02:28:28 -0500
Received: from cassarossa.samfundet.no ([193.35.52.29]:52464 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbaBXH21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 02:28:27 -0500
Date: Mon, 24 Feb 2014 08:28:20 +0100
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        kbuild-all@01.org, daniel.lezcano@linaro.org,
        Haavard Skinnemoen <hskinnemoen@gmail.com>
Subject: Re: [PATCH] avr32: remove cpu_data macro to fix compiles
Message-ID: <20140224072820.GA9069@samfundet.no>
References: <53060d5d.XcmAdOiLt1MCo6Y5%fengguang.wu@intel.com>
 <1393057709-17925-1-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393057709-17925-1-git-send-email-wsa@the-dreams.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Sat 22 Feb 2014 09:28:27 +0100 or thereabout, Wolfram Sang wrote:
> Having cpu_data as a parameterless macro can easily cause build failures
> because it can be a variable name like in linux/pm_domain.h [1]. So,
> remove the macro and convert its only user. Because this architecture
> cannot do SMP, remove the whole SMP block, too. Only compile tested due
> to no hardware.

Looks sane, AVR32 doesn't support SMP, so this change should be fine.

> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> 

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

> [1] https://lists.01.org/pipermail/kbuild-all/2014-February/003252.html
>

clockevents/3.15 branch, mens what you have queued up for 3.15?

I can queue this in my linux-next, and send Linus an early pull request the
moment 3.14 is released.

> ---
> 
>  arch/avr32/include/asm/bugs.h      | 2 +-
>  arch/avr32/include/asm/processor.h | 7 +------
>  2 files changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/avr32/include/asm/bugs.h b/arch/avr32/include/asm/bugs.h
> index 7635e77..278661b 100644
> --- a/arch/avr32/include/asm/bugs.h
> +++ b/arch/avr32/include/asm/bugs.h
> @@ -9,7 +9,7 @@
>  
>  static void __init check_bugs(void)
>  {
> -	cpu_data->loops_per_jiffy = loops_per_jiffy;
> +	boot_cpu_data.loops_per_jiffy = loops_per_jiffy;
>  }
>  
>  #endif /* __ASM_AVR32_BUGS_H */
> diff --git a/arch/avr32/include/asm/processor.h b/arch/avr32/include/asm/processor.h
> index 48d71c5..972adcc 100644
> --- a/arch/avr32/include/asm/processor.h
> +++ b/arch/avr32/include/asm/processor.h
> @@ -83,13 +83,8 @@ static inline unsigned int avr32_get_chip_revision(struct avr32_cpuinfo *cpu)
>  
>  extern struct avr32_cpuinfo boot_cpu_data;
>  
> -#ifdef CONFIG_SMP
> -extern struct avr32_cpuinfo cpu_data[];
> -#define current_cpu_data cpu_data[smp_processor_id()]
> -#else
> -#define cpu_data (&boot_cpu_data)
> +/* No SMP support so far */
>  #define current_cpu_data boot_cpu_data
> -#endif
>  
>  /* This decides where the kernel will search for a free chunk of vm
>   * space during mmap's
-- 
mvh
Hans-Christian Egtvedt
