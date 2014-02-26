Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417AbaBZMAD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 07:00:03 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1663 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752333AbaBZMAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 07:00:00 -0500
Message-ID: <530DD73D.3020507@nod.at>
Date: Wed, 26 Feb 2014 12:59:57 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: thierry.reding@gmail.com
CC: linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH] pwm,renesas-tpu: Add dependency on HAS_IOMEM
References: <1391172318-17853-1-git-send-email-richard@nod.at>
In-Reply-To: <1391172318-17853-1-git-send-email-richard@nod.at>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 31.01.2014 13:45, schrieb Richard Weinberger:
> On archs like S390 or um this driver cannot build nor work.
> Make it depend on HAS_IOMEM to bypass build failures.
> 
> drivers/built-in.o: In function `tpu_probe':
> drivers/pwm/pwm-renesas-tpu.c:421: undefined reference to `devm_ioremap_resource'
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>

Ping?

Thanks,
//richard

> ---
>  drivers/pwm/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> index 22f2f28..0b7a3c9 100644
> --- a/drivers/pwm/Kconfig
> +++ b/drivers/pwm/Kconfig
> @@ -160,6 +160,7 @@ config PWM_PXA
>  config PWM_RENESAS_TPU
>  	tristate "Renesas TPU PWM support"
>  	depends on ARCH_SHMOBILE || COMPILE_TEST
> +	depends on HAS_IOMEM
>  	help
>  	  This driver exposes the Timer Pulse Unit (TPU) PWM controller found
>  	  in Renesas chips through the PWM API.
> 
