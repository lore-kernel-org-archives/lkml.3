Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670Ab3G2Nrx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 09:47:53 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:47646 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab3G2Nrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 09:47:51 -0400
Message-ID: <51F67286.5010402@linaro.org>
Date: Mon, 29 Jul 2013 15:47:50 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Paul Mundt <lethal@linux-sh.org>,
        Simon Horman <horms+renesas@verge.net.au>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SH: cpuidle: Add missing parameter for cpuidle_register()
References: <1374790444-25473-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1374790444-25473-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2013 12:14 AM, Geert Uytterhoeven wrote:
> arch/sh/kernel/cpu/shmobile/cpuidle.c: In function 'sh_mobile_setup_cpuidle':
> arch/sh/kernel/cpu/shmobile/cpuidle.c:102:2: error: too few arguments to function 'cpuidle_register'
> include/linux/cpuidle.h:129:12: note: declared here
> arch/sh/kernel/cpu/shmobile/cpuidle.c:94:6: warning: unused variable 'ret' [-Wunused-variable]
> 
> Add the missing parameter, and remove the unused variable.
> 
> Both introduced by commit b181a3b03f866776211f22390c185c4da1dc45ff ("SH:
> cpuidle: use init/exit common routine").
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---

Thanks for the fix.

Applied to my tree.

>  arch/sh/kernel/cpu/shmobile/cpuidle.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/arch/sh/kernel/cpu/shmobile/cpuidle.c b/arch/sh/kernel/cpu/shmobile/cpuidle.c
> index d306225..e3abfd4 100644
> --- a/arch/sh/kernel/cpu/shmobile/cpuidle.c
> +++ b/arch/sh/kernel/cpu/shmobile/cpuidle.c
> @@ -91,13 +91,11 @@ static struct cpuidle_driver cpuidle_driver = {
>  
>  int __init sh_mobile_setup_cpuidle(void)
>  {
> -	int ret;
> -
>  	if (sh_mobile_sleep_supported & SUSP_SH_SF)
>  		cpuidle_driver.states[1].disabled = false;
>  
>  	if (sh_mobile_sleep_supported & SUSP_SH_STANDBY)
>  		cpuidle_driver.states[2].disabled = false;
>  
> -	return cpuidle_register(&cpuidle_driver);
> +	return cpuidle_register(&cpuidle_driver, NULL);
>  }
> 


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

