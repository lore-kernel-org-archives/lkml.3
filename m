Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751321AbaKYU5U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 15:57:20 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:55065 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbaKYU5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 15:57:18 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, tglx@linutronix.de, kernel@stlinux.com,
        jason@lakedaemon.net
Subject: Re: [PATCH v2 2/8] irqchip: Supply new driver for STi based devices
Date: Tue, 25 Nov 2014 21:57:07 +0100
Message-ID: <2433040.4NqTrOMmEE@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1416932705-16880-3-git-send-email-lee.jones@linaro.org>
References: <1416932705-16880-1-git-send-email-lee.jones@linaro.org> <1416932705-16880-3-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:vBNXPIGU4UrOHI47acCUctO2LGEqhF/zr63Qk2/Vrly
 Ss/V1Ek3vYWDYwUwWhrIjmgW+QNkC7JUA4yrtqkCl5tJRCnvrE
 9IA4SOZ1xLbvQX0jLBYuCcGgoA7XHZh2mAr4gbDLq0g+fPNR9N
 uFQ4f5cXdKWon1Dwsnryf2GiprtFKzdK3otxOHRCLpph075cuc
 IwWm1gg0cNYk4pEn+YAS8g2/3RJ+PiZYTOToN1NikciOwo0rhj
 CR7HIC19cC7Z/ljkXAVMqQLxN0PPrPD51V8twWUrGSC/bisA3p
 WqeFq584/Iruhz1CZvvcewauuSaX6MfvNego3qiK5KNmFsaPPD
 GzjPDipm6zvvj5TKREq4=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 November 2014 16:24:59 Lee Jones wrote:

> diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
> index b21f12f..e502f15 100644
> --- a/drivers/irqchip/Kconfig
> +++ b/drivers/irqchip/Kconfig
> @@ -93,6 +93,13 @@ config RENESAS_IRQC
>  	bool
>  	select IRQ_DOMAIN
>  
> +config ST_IRQCHIP
> +	bool
> +	select REGMAP
> +	select MFD_SYSCON
> +	help
> +	  Enables SysCfg Controlled IRQs on STi based platforms.
> +

I'm confused by the purpose of this code. It's apparently a driver
in drivers/irqchip, the Kconfig symbol contains the string IRQCHIP,
yet it doesn't actually register an irq_chip.

Also, the name is a bit too generic, ST has lots of different irqchips,
and this apparently isn't even one of them ;-)

	Arnd
