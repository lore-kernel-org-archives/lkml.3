Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033Ab3ISNiL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 09:38:11 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:51995 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751Ab3ISNiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 09:38:09 -0400
Message-ID: <523AFE3C.7050907@atmel.com>
Date: Thu, 19 Sep 2013 15:38:04 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
CC: <linux@maxim.org.za>, <plagnioj@jcrosoft.com>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RESEND] ARM: at91: remove IRQF_DISABLED
References: <1378270479-24628-1-git-send-email-michael.opdenacker@free-electrons.com>
In-Reply-To: <1378270479-24628-1-git-send-email-michael.opdenacker@free-electrons.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2013 06:54, Michael Opdenacker :
> This flag is a NOOP since 2.6.36 and can be removed.
>
> This is an update for 3.11 of a patch already sent for 3.10
>
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>

Thanks Michael, I stacked it on at91-3.12-fixes as I guess it can be 
accepted for this kernel release.

Bye,

> ---
>   arch/arm/mach-at91/at91rm9200_time.c  | 2 +-
>   arch/arm/mach-at91/at91sam926x_time.c | 2 +-
>   arch/arm/mach-at91/at91x40_time.c     | 2 +-
>   3 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm/mach-at91/at91rm9200_time.c b/arch/arm/mach-at91/at91rm9200_time.c
> index 180b302..f607deb 100644
> --- a/arch/arm/mach-at91/at91rm9200_time.c
> +++ b/arch/arm/mach-at91/at91rm9200_time.c
> @@ -93,7 +93,7 @@ static irqreturn_t at91rm9200_timer_interrupt(int irq, void *dev_id)
>
>   static struct irqaction at91rm9200_timer_irq = {
>   	.name		= "at91_tick",
> -	.flags		= IRQF_SHARED | IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
> +	.flags		= IRQF_SHARED | IRQF_TIMER | IRQF_IRQPOLL,
>   	.handler	= at91rm9200_timer_interrupt,
>   	.irq		= NR_IRQS_LEGACY + AT91_ID_SYS,
>   };
> diff --git a/arch/arm/mach-at91/at91sam926x_time.c b/arch/arm/mach-at91/at91sam926x_time.c
> index 3a4bc2e..bb39232 100644
> --- a/arch/arm/mach-at91/at91sam926x_time.c
> +++ b/arch/arm/mach-at91/at91sam926x_time.c
> @@ -171,7 +171,7 @@ static irqreturn_t at91sam926x_pit_interrupt(int irq, void *dev_id)
>
>   static struct irqaction at91sam926x_pit_irq = {
>   	.name		= "at91_tick",
> -	.flags		= IRQF_SHARED | IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
> +	.flags		= IRQF_SHARED | IRQF_TIMER | IRQF_IRQPOLL,
>   	.handler	= at91sam926x_pit_interrupt,
>   	.irq		= NR_IRQS_LEGACY + AT91_ID_SYS,
>   };
> diff --git a/arch/arm/mach-at91/at91x40_time.c b/arch/arm/mach-at91/at91x40_time.c
> index 2919eba..c0e637a 100644
> --- a/arch/arm/mach-at91/at91x40_time.c
> +++ b/arch/arm/mach-at91/at91x40_time.c
> @@ -57,7 +57,7 @@ static irqreturn_t at91x40_timer_interrupt(int irq, void *dev_id)
>
>   static struct irqaction at91x40_timer_irq = {
>   	.name		= "at91_tick",
> -	.flags		= IRQF_DISABLED | IRQF_TIMER,
> +	.flags		= IRQF_TIMER,
>   	.handler	= at91x40_timer_interrupt
>   };
>
>


-- 
Nicolas Ferre
