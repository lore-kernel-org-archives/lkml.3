Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035AbaFZWzv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 18:55:51 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38535 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751559AbaFZWzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 18:55:50 -0400
Message-ID: <53ACA4F3.2070206@free-electrons.com>
Date: Fri, 27 Jun 2014 00:55:47 +0200
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] ARM: smp_scu: Used defined value instead of literal
 constant
References: <1403822608-31158-1-git-send-email-gregory.clement@free-electrons.com> <1403822608-31158-2-git-send-email-gregory.clement@free-electrons.com>
In-Reply-To: <1403822608-31158-2-git-send-email-gregory.clement@free-electrons.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/06/2014 00:43, Gregory CLEMENT wrote:
> The first bit of the SCU control register is actually the enable
> it. So let's name it instead of using literal constant.
> 
> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> ---
>  arch/arm/kernel/smp_scu.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/kernel/smp_scu.c b/arch/arm/kernel/smp_scu.c
> index 1aafa0d785eb..cfea41b41ad0 100644
> --- a/arch/arm/kernel/smp_scu.c
> +++ b/arch/arm/kernel/smp_scu.c
> @@ -17,6 +17,7 @@
>  #include <asm/cputype.h>
>  
>  #define SCU_CTRL		0x00
> +#define SCU_CTRL_ENABLE		    BIT(1)

As Ezequiel rightly pointed it to me, this line is obviously wrong!
it should be
+#define SCU_CTRL_ENABLE		    BIT(0)

>  #define SCU_CONFIG		0x04
>  #define SCU_CPU_STATUS		0x08
>  #define SCU_INVALIDATE		0x0c
> @@ -43,17 +44,18 @@ void scu_enable(void __iomem *scu_base)
>  	/* Cortex-A9 only */
>  	if ((read_cpuid_id() & 0xff0ffff0) == 0x410fc090) {
>  		scu_ctrl = readl_relaxed(scu_base + 0x30);
> -		if (!(scu_ctrl & 1))
> -			writel_relaxed(scu_ctrl | 0x1, scu_base + 0x30);
> +		if (!(scu_ctrl & SCU_CTRL_ENABLE))
> +			writel_relaxed(scu_ctrl | SCU_CTRL_ENABLE,
> +				scu_base + 0x30);
>  	}
>  #endif
>  
>  	scu_ctrl = readl_relaxed(scu_base + SCU_CTRL);
>  	/* already enabled? */
> -	if (scu_ctrl & 1)
> +	if (scu_ctrl & SCU_CTRL_ENABLE)
>  		return;
>  
> -	scu_ctrl |= 1;
> +	scu_ctrl |= SCU_CTRL_ENABLE;
>  	writel_relaxed(scu_ctrl, scu_base + SCU_CTRL);
>  
>  	/*
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
