Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006AbbAZNFV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 08:05:21 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:35886 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbbAZNFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 08:05:17 -0500
Message-ID: <54C63B8A.9000702@cogentembedded.com>
Date: Mon, 26 Jan 2015 16:05:14 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Wenyou Yang <wenyou.yang@atmel.com>, nicolas.ferre@atmel.com,
        linux@arm.linux.org.uk
CC: sylvain.rochet@finsecur.com, Patrice.VILCHEZ@atmel.com,
        linux-kernel@vger.kernel.org, alexandre.belloni@free-electrons.com,
        peda@axentia.se, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/7] pm: at91: pm_suspend: add the WFI support for ARMv7
References: <1422266617-24381-1-git-send-email-wenyou.yang@atmel.com> <1422266761-24487-1-git-send-email-wenyou.yang@atmel.com>
In-Reply-To: <1422266761-24487-1-git-send-email-wenyou.yang@atmel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 1/26/2015 1:06 PM, Wenyou Yang wrote:

> Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
> ---
>   arch/arm/mach-at91/pm_suspend.S |   54 ++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 53 insertions(+), 1 deletion(-)

> diff --git a/arch/arm/mach-at91/pm_suspend.S b/arch/arm/mach-at91/pm_suspend.S
> index 122a3f1..e796722 100644
> --- a/arch/arm/mach-at91/pm_suspend.S
> +++ b/arch/arm/mach-at91/pm_suspend.S
> @@ -53,6 +53,58 @@ mode	.req	r6
>   	beq	1b
>   	.endm
>
> +/*
> + * Put the processor to enter the WFI state
> + */
> +	.macro _do_wfi
> +
> +#if defined(CONFIG_CPU_V7)
> +	/*
> +	 * Execute an ISB instruction to flush the pipeline to ensure
> +	 * that all of operations have beem completed.

    Been.

> +	 */
> +	isb
> +
> +	/*
> +	 * Execute an ISB instruction to ensure that all of the

    ISB again, while you're executing DSB/DMB?

> +	 * CP15 register changes have been committed.
> +	 */
> +	dsb
> +	dmb
> +
> +	/* Disable the processor's clock */
> +	mov	tmp1, #AT91_PMC_PCK

    What's 'tmp1'? Is that a register name?

> +	str	tmp1, [pmc, #AT91_PMC_SCDR]
> +
> +	/* Execute a WFI instruction */

    Self-obvious comment, I'd say...

> +	wfi	@ Wait For Interrupt
> +
> +	/*
> +	 * CPU can specualatively prefetch the instructions

    Speculatively.

[...]

WBR, Sergei

