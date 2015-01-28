Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761895AbbA2C2Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:28:16 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:52307 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758758AbbA2C2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:28:12 -0500
Message-ID: <54C8B54B.3090607@cogentembedded.com>
Date: Wed, 28 Jan 2015 13:09:15 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Wenyou Yang <wenyou.yang@atmel.com>, nicolas.ferre@atmel.com,
        linux@arm.linux.org.uk
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alexandre.belloni@free-electrons.com, sylvain.rochet@finsecur.com,
        peda@axentia.se, linux@maxim.org.za
Subject: Re: [PATCH v2 3/3] pm: at91: add disable/enable the L1/L2 cache while
 suspend/resume
References: <1422411707-10945-1-git-send-email-wenyou.yang@atmel.com> <1422411844-13241-1-git-send-email-wenyou.yang@atmel.com>
In-Reply-To: <1422411844-13241-1-git-send-email-wenyou.yang@atmel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 1/28/2015 5:24 AM, Wenyou Yang wrote:

> For the sama5, disable L1 D-cache and L2 cache before the cpu go to wfi,
> after wakeing up, enable L1 D-cache and L2 cache.

    Waking.

> Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
> ---
>   arch/arm/mach-at91/pm.c         |   12 +++++
>   arch/arm/mach-at91/pm_suspend.S |  107 +++++++++++++++++++++++++++++++++++++++
>   2 files changed, 119 insertions(+)

[...]
> diff --git a/arch/arm/mach-at91/pm_suspend.S b/arch/arm/mach-at91/pm_suspend.S
> index 311cc23..02d4e56 100644
> --- a/arch/arm/mach-at91/pm_suspend.S
> +++ b/arch/arm/mach-at91/pm_suspend.S
[...]
> @@ -324,3 +325,109 @@ ram_restored:
[...]
> +l2x_sync:

    I don't see where this label is used.

> +	ldr	r0, [r2, #L2X0_CACHE_SYNC]
> +	bic	r0, r0, #0x1
> +	str	r0, [r2, #L2X0_CACHE_SYNC]
> +sync:
> +	ldr	r0, [r2, #L2X0_CACHE_SYNC]
> +	ands	r0, r0, #0x1
> +	bne	sync
> +
> +skip_l2disable:
> +	ldmfd	sp!, {r4 - r12, pc}
> +ENDPROC(at91_disable_l1_l2_cache)
[...]

WBR, Sergei

