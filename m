Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbaEZO6M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 10:58:12 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:50652 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752386AbaEZO6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 10:58:11 -0400
Message-ID: <1401116287.6068.15.camel@x220>
Subject: Re: [PATCH] ARM: msm: Update the references to DEBUG_MSM_UARTx
From: Paul Bolle <pebolle@tiscali.nl>
To: Georgi Djakov <gdjakov@mm-sol.com>
Cc: galak@codeaurora.org, iivanov@mm-sol.com, arm@kernel.org,
        khilman@linaro.org, arnd@arndb.de, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, olof@lixom.net, davidb@codeaurora.org,
        linux-arm-kernel@lists.infradead.org, agross@codeaurora.org,
        linus.walleij@linaro.org, srinivas.kandagatla@linaro.org
Date: Mon, 26 May 2014 16:58:07 +0200
In-Reply-To: <1401112733-23649-1-git-send-email-gdjakov@mm-sol.com>
References: <1401108595.6068.5.camel@x220>
	 <1401112733-23649-1-git-send-email-gdjakov@mm-sol.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 May 2014 14:58:08.0461 (UTC) FILETIME=[E7DF17D0:01CF78F2]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Georgi,

On Mon, 2014-05-26 at 16:58 +0300, Georgi Djakov wrote:
> The Kconfig options DEBUG_MSM_UART1, DEBUG_MSM_UART2 and DEBUG_MSM_UART3
> are removed, but they are still referenced in arch/arm/mach-msm/io.c
> Fix this by updating the reference to the new Kconfig option.
> 
> Reported-by: Paul Bolle <pebolle@tiscali.nl>
> Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
> ---
>  arch/arm/mach-msm/io.c |    6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/mach-msm/io.c b/arch/arm/mach-msm/io.c
> index 34e0947..b042dca 100644
> --- a/arch/arm/mach-msm/io.c
> +++ b/arch/arm/mach-msm/io.c
> @@ -57,8 +57,7 @@ static struct map_desc msm_io_desc[] __initdata = {
>  		.length =   MSM_SHARED_RAM_SIZE,
>  		.type =     MT_DEVICE,
>  	},
> -#if defined(CONFIG_DEBUG_MSM_UART1) || defined(CONFIG_DEBUG_MSM_UART2) || \
> -		defined(CONFIG_DEBUG_MSM_UART3)
> +#if defined(CONFIG_DEBUG_MSM_UART)
>  	{
>  		/* Must be last: virtual and pfn filled in by debug_ll_addr() */
>  		.length = SZ_4K,
> @@ -76,8 +75,7 @@ void __init msm_map_common_io(void)
>  	 * pages are peripheral interface or not.
>  	 */
>  	asm("mcr p15, 0, %0, c15, c2, 4" : : "r" (0));
> -#if defined(CONFIG_DEBUG_MSM_UART1) || defined(CONFIG_DEBUG_MSM_UART2) || \
> -		defined(CONFIG_DEBUG_MSM_UART3)
> +#if defined(CONFIG_DEBUG_MSM_UART)
>  #ifdef CONFIG_MMU
>  	debug_ll_addr(&msm_io_desc[size - 1].pfn,
>  		      &msm_io_desc[size - 1].virtual);

Should I now redo https://lkml.org/lkml/2014/5/15/249 by making the
(outdated) checks in arch/arm/mach-msm/board-trout.c and
arch/arm/mach-msm/board-trout-gpio.c also use CONFIG_DEBUG_MSM_UART?


Paul Bolle

