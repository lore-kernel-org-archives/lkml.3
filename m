Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882AbaLHWXA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 17:23:00 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:60827 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbaLHWW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 17:22:29 -0500
Message-ID: <54862498.8080101@gmail.com>
Date: Mon, 08 Dec 2014 14:22:16 -0800
From: Florian Fainelli <f.fainelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>, arm@kernel.org
CC: mporter@linaro.org, bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Scott Branden <sbranden@broadcom.com>
Subject: Re: [PATCH] ARM: bcm: fix __iomem annotation on kona_smc
References: <1418075148-8752-1-git-send-email-olof@lixom.net>
In-Reply-To: <1418075148-8752-1-git-send-email-olof@lixom.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/14 13:45, Olof Johansson wrote:
> Fixes the following sparse warning:
> arch/arm/mach-bcm/bcm_kona_smc.c:145:21: warning: incorrect type in initializer (different address spaces)
> arch/arm/mach-bcm/bcm_kona_smc.c:145:21:    expected unsigned int [usertype] *args
> arch/arm/mach-bcm/bcm_kona_smc.c:145:21:    got void [noderef] <asn:2>*static [toplevel] [assigned] bcm_smc_buffer
> arch/arm/mach-bcm/bcm_kona_smc.c:151:9: warning: incorrect type in argument 2 (different address spaces)
> arch/arm/mach-bcm/bcm_kona_smc.c:151:9:    expected void volatile [noderef] <asn:2>*addr
> arch/arm/mach-bcm/bcm_kona_smc.c:151:9:    got unsigned int [usertype] *
> [+ 2 more instances]
> 
> Signed-off-by: Olof Johansson <olof@lixom.net>
> ---
> 
> Florian, should we just apply this directly on arm-soc?

Yes please.

> 
> 
> -Olof
> 
>  arch/arm/mach-bcm/bcm_kona_smc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-bcm/bcm_kona_smc.c b/arch/arm/mach-bcm/bcm_kona_smc.c
> index a55a7ec..d506d17 100644
> --- a/arch/arm/mach-bcm/bcm_kona_smc.c
> +++ b/arch/arm/mach-bcm/bcm_kona_smc.c
> @@ -142,7 +142,7 @@ static int bcm_kona_do_smc(u32 service_id, u32 buffer_phys)
>  static void __bcm_kona_smc(void *info)
>  {
>  	struct bcm_kona_smc_data *data = info;
> -	u32 *args = bcm_smc_buffer;
> +	u32 __iomem *args = bcm_smc_buffer;

Your fix looks good to me, although the original code sounds a little
dubious, especially in LPAE environment.

>  
>  	BUG_ON(smp_processor_id() != 0);
>  	BUG_ON(!args);
> 

