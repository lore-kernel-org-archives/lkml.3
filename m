Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab3LCI70 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 03:59:26 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:40765 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab3LCI7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 03:59:23 -0500
Message-ID: <529D9D43.6040101@ti.com>
Date: Tue, 3 Dec 2013 14:28:43 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Marek Belisko <marek.belisko@open-nandra.com>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <hns@goldelico.com>
Subject: Re: [PATCH] omap: twl-common: Fix musb-hdrc device name.
References: <1386059589-4030-1-git-send-email-marek.belisko@open-nandra.com>
In-Reply-To: <1386059589-4030-1-git-send-email-marek.belisko@open-nandra.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 03 December 2013 02:03 PM, Marek Belisko wrote:
> Without this change when booting omap3 device (gta04) with board file
> leads to follwing errors:
> 
> [    1.203308] musb-hdrc musb-hdrc.0.auto: unable to find phy
> [    1.209075] HS USB OTG: no transceiver configured
> [    1.214019] musb-hdrc musb-hdrc.0.auto: musb_init_controller failed with status -517
> 
> and usb isn't working.
> 
> This is probably regression caused by commit: 6c27f939

I think a better fix would be to have this merged..
https://lkml.org/lkml/2013/7/26/91
> 
> Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
> ---
>  arch/arm/mach-omap2/twl-common.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-omap2/twl-common.c b/arch/arm/mach-omap2/twl-common.c
> index b0d54da..3640ce0 100644
> --- a/arch/arm/mach-omap2/twl-common.c
> +++ b/arch/arm/mach-omap2/twl-common.c
> @@ -92,7 +92,7 @@ void __init omap_pmic_late_init(void)
>  
>  #if defined(CONFIG_ARCH_OMAP3)
>  struct phy_consumer consumers[] = {
> -	PHY_CONSUMER("musb-hdrc.0", "usb"),
> +	PHY_CONSUMER("musb-hdrc.0.auto", "usb"),

the index '0' might vary for some boards leading it to again break musb.

Thanks
Kishon
