Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802AbaGWOGo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 10:06:44 -0400
Received: from mail.active-venture.com ([67.228.131.205]:60078 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353AbaGWOGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 10:06:42 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53CFC170.9090505@roeck-us.net>
Date: Wed, 23 Jul 2014 07:06:40 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>, geert@linux-m68k.org
CC: rostedt@goodmis.org, gnomes@lxorguk.ukuu.org.uk, xerofoify@gmail.com,
        linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH] m68k/q40: Revert "m68k/q40: Fix q40_irq_startup() to
 return -ENXIO on failures"
References: <1406119899-22659-1-git-send-email-sasha.levin@oracle.com>
In-Reply-To: <1406119899-22659-1-git-send-email-sasha.levin@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2014 05:51 AM, Sasha Levin wrote:
> Revert since we're trying to return -ENXIO from a function returning
> unsigned int. Not only it causes compiler warnings it's also obviously
> incorrect.
>
> In general, watch for patches from Nick Krause since they are not even
> build tested.
>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Guess I wasn't fast enough with my comments :-(

Acked-by: Guenter Roeck <linux@roeck-us.net>

> ---
>   arch/m68k/q40/q40ints.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/m68k/q40/q40ints.c b/arch/m68k/q40/q40ints.c
> index 9dfa1ea..513f9bb 100644
> --- a/arch/m68k/q40/q40ints.c
> +++ b/arch/m68k/q40/q40ints.c
> @@ -49,7 +49,7 @@ static unsigned int q40_irq_startup(struct irq_data *data)
>   	case 1: case 2: case 8: case 9:
>   	case 11: case 12: case 13:
>   		printk("%s: ISA IRQ %d not implemented by HW\n", __func__, irq);
> -		return -ENXIO;
> +		/* FIXME return -ENXIO; */
>   	}
>   	return 0;
>   }
>

