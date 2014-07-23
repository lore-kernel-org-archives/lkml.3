Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941AbaGWEyV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 00:54:21 -0400
Received: from mail.active-venture.com ([67.228.131.205]:63429 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbaGWEyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 00:54:20 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53CF3FFB.4080809@roeck-us.net>
Date: Tue, 22 Jul 2014 21:54:19 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Nicholas Krause <xerofoify@gmail.com>, geert@linux-m68k.org
CC: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] m68k: Remove printk statement and add return statement
 in q40ints.c
References: <1406088515-4026-1-git-send-email-xerofoify@gmail.com>
In-Reply-To: <1406088515-4026-1-git-send-email-xerofoify@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2014 09:08 PM, Nicholas Krause wrote:
> This removes the printk statement for irqs not defined by the hardware in
> function q40_irq_startup and instead returns -ENXIO as stated by the fix
> me message.
>
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>   arch/m68k/q40/q40ints.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/arch/m68k/q40/q40ints.c b/arch/m68k/q40/q40ints.c
> index 513f9bb..86f05c0 100644
> --- a/arch/m68k/q40/q40ints.c
> +++ b/arch/m68k/q40/q40ints.c
> @@ -48,8 +48,7 @@ static unsigned int q40_irq_startup(struct irq_data *data)
>   	switch (irq) {
>   	case 1: case 2: case 8: case 9:
>   	case 11: case 12: case 13:
> -		printk("%s: ISA IRQ %d not implemented by HW\n", __func__, irq);
> -		/* FIXME return -ENXIO; */
> +		return -ENXIO;

Returning -ENXIO from a function returning an unsigned int isn't really very helpful,
don't you think ?

With all those FIXMEs, you might want to keep in mind that there is typically a
good reason for it. If it was as easy as your proposed fix, you can assume
that the FIXME would not have been there in the first place.

Guenter

