Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112Ab3IRGPD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 02:15:03 -0400
Received: from mail-ye0-f175.google.com ([209.85.213.175]:40796 "EHLO
	mail-ye0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab3IRGNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 02:13:35 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH 01/28] c6x: use boot_command_line instead of private c6x_command_line
To: Rob Herring <robherring2@gmail.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>, Mark Salter <msalter@redhat.com>,
        Aurelien Jacquiot <a-jacquiot@ti.com>, linux-c6x-dev@linux-c6x.org
In-Reply-To: <1379372965-22359-2-git-send-email-robherring2@gmail.com>
References: <1379372965-22359-1-git-send-email-robherring2@gmail.com> <1379372965-22359-2-git-send-email-robherring2@gmail.com>
Date: Tue, 17 Sep 2013 22:07:29 -0500
Message-Id: <20130918030729.DEB1BC42C91@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Sep 2013 18:08:57 -0500, Rob Herring <robherring2@gmail.com> wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> Save some pointless copying of the kernel command line and just use
> boot_command_line instead.
> 
> Also remove default_command_line as it is not referenced anywhere, and
> the DT code already handles the default command line.
> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: Mark Salter <msalter@redhat.com>
> Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
> Cc: linux-c6x-dev@linux-c6x.org

This and the next patch look good to me.

Reviewed-by: Grant Likely <grant.likely@linaro.org>

> ---
>  arch/c6x/include/asm/setup.h |  2 --
>  arch/c6x/kernel/devicetree.c |  2 +-
>  arch/c6x/kernel/setup.c      | 11 +----------
>  3 files changed, 2 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/c6x/include/asm/setup.h b/arch/c6x/include/asm/setup.h
> index ecead15..6968044 100644
> --- a/arch/c6x/include/asm/setup.h
> +++ b/arch/c6x/include/asm/setup.h
> @@ -14,8 +14,6 @@
>  #include <uapi/asm/setup.h>
>  
>  #ifndef __ASSEMBLY__
> -extern char c6x_command_line[COMMAND_LINE_SIZE];
> -
>  extern int c6x_add_memory(phys_addr_t start, unsigned long size);
>  
>  extern unsigned long ram_start;
> diff --git a/arch/c6x/kernel/devicetree.c b/arch/c6x/kernel/devicetree.c
> index 9e15ab9..5e8c838 100644
> --- a/arch/c6x/kernel/devicetree.c
> +++ b/arch/c6x/kernel/devicetree.c
> @@ -24,7 +24,7 @@ void __init early_init_devtree(void *params)
>  	 * device-tree, including the platform type, initrd location and
>  	 * size and more ...
>  	 */
> -	of_scan_flat_dt(early_init_dt_scan_chosen, c6x_command_line);
> +	of_scan_flat_dt(early_init_dt_scan_chosen, boot_command_line);
>  
>  	/* Scan memory nodes and rebuild MEMBLOCKs */
>  	of_scan_flat_dt(early_init_dt_scan_root, NULL);
> diff --git a/arch/c6x/kernel/setup.c b/arch/c6x/kernel/setup.c
> index f4e72bd..0e5a812 100644
> --- a/arch/c6x/kernel/setup.c
> +++ b/arch/c6x/kernel/setup.c
> @@ -68,13 +68,6 @@ unsigned long ram_end;
>  static unsigned long dma_start __initdata;
>  static unsigned long dma_size __initdata;
>  
> -char c6x_command_line[COMMAND_LINE_SIZE];
> -
> -#if defined(CONFIG_CMDLINE_BOOL)
> -static const char default_command_line[COMMAND_LINE_SIZE] __section(.cmdline) =
> -	CONFIG_CMDLINE;
> -#endif
> -
>  struct cpuinfo_c6x {
>  	const char *cpu_name;
>  	const char *cpu_voltage;
> @@ -296,8 +289,6 @@ notrace void __init machine_init(unsigned long dt_ptr)
>  	/* Do some early initialization based on the flat device tree */
>  	early_init_devtree(fdt);
>  
> -	/* parse_early_param needs a boot_command_line */
> -	strlcpy(boot_command_line, c6x_command_line, COMMAND_LINE_SIZE);
>  	parse_early_param();
>  }
>  
> @@ -309,7 +300,7 @@ void __init setup_arch(char **cmdline_p)
>  	printk(KERN_INFO "Initializing kernel\n");
>  
>  	/* Initialize command line */
> -	*cmdline_p = c6x_command_line;
> +	*cmdline_p = boot_command_line;
>  
>  	memory_end = ram_end;
>  	memory_end &= ~(PAGE_SIZE - 1);
> -- 
> 1.8.1.2
> 

