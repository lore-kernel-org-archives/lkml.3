Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152Ab3EBKwx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 06:52:53 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:48198 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757467Ab3EBKww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 06:52:52 -0400
Date: Thu, 2 May 2013 11:52:46 +0100
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        mian.yousaf.kaukab@stericsson.com
Subject: Re: [PATCH 10/10] ARM: ux500: Remove empty function
 u8500_of_init_devices()
Message-ID: <20130502105246.GK25256@gmail.com>
References: <1366729394-11406-1-git-send-email-lee.jones@linaro.org>
 <1366729394-11406-11-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1366729394-11406-11-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Apr 2013, Lee Jones wrote:

> As promised, now all devices which resided in u8500_of_init_devices()
> have been enabled for Device Tree, we can completely remove it.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  arch/arm/mach-ux500/cpu-db8500.c |   14 +-------------
>  1 file changed, 1 insertion(+), 13 deletions(-)
> 
> diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
> index 36ef6ed..a2c83c2 100644
> --- a/arch/arm/mach-ux500/cpu-db8500.c
> +++ b/arch/arm/mach-ux500/cpu-db8500.c
> @@ -221,15 +221,6 @@ struct device * __init u8500_init_devices(struct ab8500_platform_data *ab8500)
>  }
>  
>  #ifdef CONFIG_MACH_UX500_DT
> -
> -/* TODO: Once all pieces are DT:ed, remove completely. */
> -static struct device * __init u8500_of_init_devices(void)
> -{
> -	struct device *parent = db8500_soc_device_init();
> -
> -	return parent;
> -}
> -
>  static struct of_dev_auxdata u8500_auxdata_lookup[] __initdata = {
>  	/* Requires call-back bindings. */
>  	OF_DEV_AUXDATA("arm,cortex-a9-pmu", 0, "arm-pmu", &db8500_pmu_platdata),
> @@ -288,7 +279,7 @@ static const struct of_device_id u8500_local_bus_nodes[] = {
>  
>  static void __init u8500_init_machine(void)
>  {
> -	struct device *parent = NULL;
> +	struct device *parent = db8500_soc_device_init();
>  
>  	/* Pinmaps must be in place before devices register */
>  	if (of_machine_is_compatible("st-ericsson,mop500"))
> @@ -301,9 +292,6 @@ static void __init u8500_init_machine(void)
>  	else if (of_machine_is_compatible("st-ericsson,ccu9540")) {}
>  		/* TODO: Add pinmaps for ccu9540 board. */
>  
> -	/* TODO: Export SoC, USB, cpu-freq and DMA40 */
> -	parent = u8500_of_init_devices();
> -
>  	/* automatically probe child nodes of db8500 device */
>  	of_platform_populate(NULL, u8500_local_bus_nodes, u8500_auxdata_lookup, parent);
>  }

Linus, poke.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
