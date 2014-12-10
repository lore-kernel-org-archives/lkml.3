Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933317AbaLJWoR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 17:44:17 -0500
Received: from mail-qg0-f45.google.com ([209.85.192.45]:61364 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933160AbaLJWoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 17:44:15 -0500
MIME-Version: 1.0
In-Reply-To: <1418245000.23374.26.camel@t520.localdomain>
References: <1418245000.23374.26.camel@t520.localdomain>
From: Sonny Rao <sonnyrao@chromium.org>
Date: Wed, 10 Dec 2014 14:43:54 -0800
X-Google-Sender-Auth: ja3dVt2VuceZahGRkAzqfll2DrA
Message-ID: <CAPz6YkXcerUiLc3dQG0URSuioiLsAwcTLkDTivD4JU9YQsdR+Q@mail.gmail.com>
Subject: Re: arm64 hitting BUG in arch_timer.h
To: Mark Salter <msalter@redhat.com>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>, yingjoe.chen@mediatek.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 12:56 PM, Mark Salter <msalter@redhat.com> wrote:
> Using Linus' tree from this morning, I am hitting:
>
>    [    0.000000] BUG: failure at ./arch/arm64/include/asm/arch_timer.h:112/arch_counter_get_cntpct!
>
> This is triggered by commit 0b46b8a718 ("clocksource: arch_timer: Fix
> code to use physical timers when requested") which addresses an armv7
> problem. Arm64 wants to always use a virtual timer. I used this to avoid
> the BUG and get a booting kernel:
>
> diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch
> index 71846f9..4d8a01e 100644
> --- a/drivers/clocksource/arm_arch_timer.c
> +++ b/drivers/clocksource/arm_arch_timer.c
> @@ -468,7 +468,7 @@ static void __init arch_counter_register(unsigned type)
>
>         /* Register the CP15 based counter if we have one */
>         if (type & ARCH_CP15_TIMER) {
> -               if (arch_timer_use_virtual)
> +               if (IS_ENABLED(CONFIG_ARM64) || arch_timer_use_virtual)
>                         arch_timer_read_counter = arch_counter_get_cntvct;
>                 else
>                         arch_timer_read_counter = arch_counter_get_cntpct;
>
>

Yes Catalin has prepared a similar patch:
https://patchwork.kernel.org/patch/5468031/
