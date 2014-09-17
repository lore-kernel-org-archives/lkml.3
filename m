Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712AbaIQTBW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 15:01:22 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:36212 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756207AbaIQTBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 15:01:19 -0400
MIME-Version: 1.0
In-Reply-To: <1410897290-27815-1-git-send-email-geert+renesas@glider.be>
References: <1410897290-27815-1-git-send-email-geert+renesas@glider.be>
Date: Wed, 17 Sep 2014 21:01:18 +0200
Message-ID: <CAPDyKFpOPoehPCkRr5Y-Kpo==NmaOWnWBrvGEfNFJBhVYJWyuQ@mail.gmail.com>
Subject: Re: [PATCH] frv: Remove unused cpuinfo_frv and friends to fix future
 build error
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: David Howells <dhowells@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        kbuild test robot <fengguang.wu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 September 2014 21:54, Geert Uytterhoeven <geert+renesas@glider.be> wrote:
> Frv has a macro named cpu_data, interfering with variables and struct
> members with the same name:
>
> include/linux/pm_domain.h:75:24: error: expected identifier or '('
> before '&' token
>   struct gpd_cpu_data *cpu_data;
>
> As struct cpuinfo_frv, boot_cpu_data, cpu_data, and current_cpu_data are
> not used, removed them to fix this.
>
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Thanks for looking into this Geert!

I am not sure I fully understand what's causing the future build
errors, at least not yet. :-)

Anyway, do you think those should prevent Rafael from queing my patch
set below? If so, I guess I could resend it with this patch folded
into it? What do you think?

http://marc.info/?l=linux-pm&m=141026259703629&w=2

Kind regards
Uffe

> ---
> There are a few more waiting for this to happen:
>
> arch/m32r/include/asm/processor.h:#define cpu_data (&boot_cpu_data)
> arch/mn10300/include/asm/processor.h:#define cpu_data &boot_cpu_data
> arch/um/include/asm/processor-generic.h:#define cpu_data (&boot_cpu_data)
>
>  arch/frv/include/asm/processor.h | 16 ----------------
>  arch/frv/kernel/setup.c          |  2 --
>  2 files changed, 18 deletions(-)
>
> diff --git a/arch/frv/include/asm/processor.h b/arch/frv/include/asm/processor.h
> index 6554e78893f26bc8..ae8d423e79d9dbe5 100644
> --- a/arch/frv/include/asm/processor.h
> +++ b/arch/frv/include/asm/processor.h
> @@ -35,22 +35,6 @@
>  struct task_struct;
>
>  /*
> - *  CPU type and hardware bug flags. Kept separately for each CPU.
> - */
> -struct cpuinfo_frv {
> -#ifdef CONFIG_MMU
> -       unsigned long   *pgd_quick;
> -       unsigned long   *pte_quick;
> -       unsigned long   pgtable_cache_sz;
> -#endif
> -} __cacheline_aligned;
> -
> -extern struct cpuinfo_frv __nongprelbss boot_cpu_data;
> -
> -#define cpu_data               (&boot_cpu_data)
> -#define current_cpu_data       boot_cpu_data
> -
> -/*
>   * Bus types
>   */
>  #define EISA_bus 0
> diff --git a/arch/frv/kernel/setup.c b/arch/frv/kernel/setup.c
> index 9f3a7a62d7873dc2..9f4a9a607dbe68fd 100644
> --- a/arch/frv/kernel/setup.c
> +++ b/arch/frv/kernel/setup.c
> @@ -104,8 +104,6 @@ unsigned long __nongprelbss dma_coherent_mem_end;
>  unsigned long __initdata __sdram_old_base;
>  unsigned long __initdata num_mappedpages;
>
> -struct cpuinfo_frv __nongprelbss boot_cpu_data;
> -
>  char __initdata command_line[COMMAND_LINE_SIZE];
>  char __initdata redboot_command_line[COMMAND_LINE_SIZE];
>
> --
> 1.9.1
>
