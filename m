Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344Ab3E0KGC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 06:06:02 -0400
Received: from intranet.asianux.com ([58.214.24.6]:41258 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755907Ab3E0KF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 06:05:58 -0400
X-Spam-Score: -100.8
Message-ID: <51A32FD4.4000001@asianux.com>
Date: Mon, 27 May 2013 18:05:08 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: ben-linux@fluff.org, "kgene.kim@samsung.com" <kgene.kim@samsung.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org >> \"linux-kernel@vger.kernel.org\"" 
	<linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] ARM: S5PV210: dependency issue, S5P_SLEEP is depend on
 ARM_CPU_SUSPEND
References: <5199E4AF.7040607@asianux.com>
In-Reply-To: <5199E4AF.7040607@asianux.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Maintainers:

Please help check this patch whether OK, when you have time.


Thanks.

On 05/20/2013 04:54 PM, Chen Gang wrote:
> 
> When randconfig with MMU for arm s5pv210 (and select all cpu type),
> need let S5P_SLEEP depend on ARM_CPU_SUSPEND, or will cause issue below:
> 
>   arch/arm/plat-samsung/built-in.o: In function `s3c_cpu_resume':
>   arch/arm/plat-samsung/s5p-sleep.S:83: undefined reference to `cpu_resume'
> 
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  arch/arm/plat-samsung/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/plat-samsung/Kconfig b/arch/arm/plat-samsung/Kconfig
> index f8ed2de..1d38541 100644
> --- a/arch/arm/plat-samsung/Kconfig
> +++ b/arch/arm/plat-samsung/Kconfig
> @@ -483,6 +483,7 @@ config S5P_PM
>  
>  config S5P_SLEEP
>  	bool
> +	select ARM_CPU_SUSPEND
>  	help
>  	  Internal config node to apply common S5P sleep management code.
>  	  Can be selected by S5P and newer SoCs with similar sleep procedure.
> 


-- 
Chen Gang

Asianux Corporation
