Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab3IRQpO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 12:45:14 -0400
Received: from top.free-electrons.com ([176.31.233.9]:39037 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751627Ab3IRQpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 12:45:12 -0400
Date: Wed, 18 Sep 2013 18:45:09 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jason Cooper <jason@lakedaemon.net>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        patches@linaro.org,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH] arm: mvebu: use the main timer as clock source from DT
Message-ID: <20130918184509.0ad0a5be@skate>
In-Reply-To: <1379519624-4267-1-git-send-email-jean.pihet@linaro.org>
References: <1379519624-4267-1-git-send-email-jean.pihet@linaro.org>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Jean Pihet,

On Wed, 18 Sep 2013 17:53:44 +0200, Jean Pihet wrote:
> This commit:
>   573145f08c2b92c45498468afbbba909f6ce6135
>   clocksource: armada-370-xp: Use CLOCKSOURCE_OF_DECLARE
> 
> replaced a call to the driver's timer initialization by a call to
> clocksource_of_init(). However, it failed to select CONFIG_CLKSRC_OF.
> 
> Fix this by selecting CONFIG_CLKSRC_OF for Armada370/XP machines.
> Without this change the kernel is stuck at: 'Calibrating delay
> loop...'.
> 
> Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
> Acked-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
> ---
>  arch/arm/mach-mvebu/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/mach-mvebu/Kconfig b/arch/arm/mach-mvebu/Kconfig
> index 9eb63d7..25e6c00 100644
> --- a/arch/arm/mach-mvebu/Kconfig
> +++ b/arch/arm/mach-mvebu/Kconfig
> @@ -26,6 +26,7 @@ config MACH_ARMADA_370_XP
>  	select HAVE_SMP
>  	select CACHE_L2X0
>  	select CPU_PJ4B
> +	select CLKSRC_OF

I disagree. This should go to drivers/clocksource/Kconfig, because it's
the clocksource driver that uses CLOCKSOURCE_OF_DECLARE. See what is
already done in drivers/clocksource/Kconfig for other drivers.

Thanks,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
