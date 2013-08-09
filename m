Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030277Ab3HIDT3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 23:19:29 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:56108 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967580Ab3HIDT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 23:19:26 -0400
Message-ID: <52045FB3.9060001@gmail.com>
Date: Fri, 09 Aug 2013 08:49:15 +0530
From: Kumar Gaurav <kumargauravgupta3@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Kumar Gaurav <kumargauravgupta3@gmail.com>
CC: hskinnemoen@gmail.com, egtvedt@samfundet.no, tglx@linutronix.de,
        srivatsa.bhat@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH]arch:avr32:kernel:time.c: Removed IRQF_DISABLED
References: <1376018243-8565-1-git-send-email-kumargauravgupta3@gmail.com>
In-Reply-To: <1376018243-8565-1-git-send-email-kumargauravgupta3@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please ignore the below patch. I'll be resending this with 0 instead of 
IRQF_TRIGGER_NONE
On Friday 09 August 2013 08:47 AM, Kumar Gaurav wrote:
> Removed IRQF_DISABLED as it's no-op and should be removed
>
> Signed-off-by: Kumar Gaurav <kumargauravgupta3@gmail.com>
> ---
>   arch/avr32/kernel/time.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/avr32/kernel/time.c b/arch/avr32/kernel/time.c
> index 869a1c6..0566c81 100644
> --- a/arch/avr32/kernel/time.c
> +++ b/arch/avr32/kernel/time.c
> @@ -59,7 +59,7 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
>   static struct irqaction timer_irqaction = {
>   	.handler	= timer_interrupt,
>   	/* Oprofile uses the same irq as the timer, so allow it to be shared */
> -	.flags		= IRQF_TIMER | IRQF_DISABLED | IRQF_SHARED,
> +	.flags		= IRQF_TIMER | IRQF_TRIGGER_NONE | IRQF_SHARED,
>   	.name		= "avr32_comparator",
>   };
>   

