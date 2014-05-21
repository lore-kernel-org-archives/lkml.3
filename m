Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbaEUPTf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 11:19:35 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:53644 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbaEUPTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 11:19:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Georgi Djakov <gdjakov@mm-sol.com>
Cc: linux@arm.linux.org.uk, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, sboyd@codeaurora.org, rvaswani@codeaurora.org,
        davidb@codeaurora.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v1 4/4] ARM: debug: qcom: Add APQ8084 DEBUG_LL UART support
Date: Wed, 21 May 2014 17:18:52 +0200
Message-ID: <4365639.JcFl1cP048@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1400684225-21381-5-git-send-email-gdjakov@mm-sol.com>
References: <1400684225-21381-1-git-send-email-gdjakov@mm-sol.com> <1400684225-21381-5-git-send-email-gdjakov@mm-sol.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:B553I9x26yiUA5Ql2vdcAT8Z8Eb6j0btpfnGtU7WvS1
 gLNHuMWeA2d+dLfh1sK+IDiB8BBfHwcO+PrV4yPoRsNpMqUnpz
 5IPc8eflwcOQBuHDm59Y3/cQWR4pq3VTaFPmockaPVB1W/iHqP
 JeNcm5sBSOrd1CsbahShXR7ToXo10rQO5JoTu9yvG3RHpl+Ebj
 W0Fc4LEWgCv4WNwKdalNg4gW5L3lB6On21Y+O3PgEWtJiatvo/
 C+pQEzE/9HojVMROAfW8qzRKwGRBcIXczMO7GFparJKJ8RjCUm
 wVQpyJb546NVaKob5JjBDeI0yr3EhEmRvjAJV/A5PuKwjTGGCe
 10wGtmTZ5awa63N0Q8so=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 May 2014 17:57:05 Georgi Djakov wrote:
> 
> diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
> index eab8ecb..91d5184 100644
> --- a/arch/arm/Kconfig.debug
> +++ b/arch/arm/Kconfig.debug
> @@ -101,6 +101,15 @@ choice
>                 bool "Kernel low-level debugging on 9263 and 9g45"
>                 depends on HAVE_AT91_DBGU1
>  
> +       config DEBUG_APQ8084_UART
> +               bool "Kernel low-level debugging messages via APQ8084 UART"
> +               depends on ARCH_QCOM
> +               select MSM_HAS_DEBUG_UART_HS
> +               select DEBUG_MSM_UART
> +               help
> +                 Say Y here if you want the debug print routines to direct
> +                 their output to the serial port on Qualcomm APQ8084 devices.
> +
>         config DEBUG_BCM2835
>                 bool "Kernel low-level debugging on BCM2835 PL011 UART"
>                 depends on ARCH_BCM2835
> diff --git a/arch/arm/include/debug/msm.S b/arch/arm/include/debug/msm.S
> index 9d653d4..178636d 100644
> --- a/arch/arm/include/debug/msm.S
> +++ b/arch/arm/include/debug/msm.S
> @@ -36,6 +36,11 @@
>  #define MSM_DEBUG_UART_PHYS    MSM_UART3_PHYS
>  #endif
>  
> +#ifdef CONFIG_DEBUG_APQ8084_UART
> +#define MSM_DEBUG_UART_BASE    0xFA75E000
> +#define MSM_DEBUG_UART_PHYS    0xF995E000
> +#endif
> +
>  #ifdef CONFIG_DEBUG_MSM8660_UART
>  #define MSM_DEBUG_UART_BASE    0xF0040000
>  #define MSM_DEBUG_UART_PHYS    0x19C40000
> 

Maybe we should move debug/msm.S over to use
CONFIG_DEBUG_UART_PHYS/CONFIG_DEBUG_UART_VIRT now?

	Arnd
