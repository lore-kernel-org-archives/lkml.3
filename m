Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993AbaFNPj0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 11:39:26 -0400
Received: from mail.kernel.org ([198.145.19.201]:44681 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754759AbaFNPjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 11:39:24 -0400
Message-ID: <539C6D20.7080907@kernel.org>
Date: Sat, 14 Jun 2014 16:41:20 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Himangi Saraogi <himangi774@gmail.com>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: julia.lawall@lip6.fr
Subject: Re: [PATCH] iio: adc: at91_adc: Correct call to input_free_device
References: <20140613171146.GA2831@himangi-Dell>
In-Reply-To: <20140613171146.GA2831@himangi-Dell>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/06/14 18:11, Himangi Saraogi wrote:
> This error handling code can be reached before st->ts_input is
> initialized, so it is safer to always use the original name, input_dev.
>
> A simplified version of the semantic match that finds this problem is:
>
> // <smpl>
> @r exists@
> local idexpression struct input_dev * x;
> expression ra,rr;
> @@
>
> * x = input_allocate_device(...)
> ...  when != x = rr
>       when != input_free_device(x,...)
>       when != if (...) { ... input_free_device(x,...) ...}
> if(...) { ... when != x = ra
>       when forall
> *     when != input_free_device(x,...)
>   \(return <+...x...+>; \| return...; \) }
>
> // </smpl>
>
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
The error handling in this function has been completely rewritten so the
bug is no longer there and this no longer applies.

Thanks,

Jonathan
> ---
>   drivers/iio/adc/at91_adc.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/iio/adc/at91_adc.c b/drivers/iio/adc/at91_adc.c
> index 3b5bacd..73b2bb5 100644
> --- a/drivers/iio/adc/at91_adc.c
> +++ b/drivers/iio/adc/at91_adc.c
> @@ -1114,7 +1114,7 @@ static int at91_ts_register(struct at91_adc_state *st,
>   	return ret;
>
>   err:
> -	input_free_device(st->ts_input);
> +	input_free_device(input);
>   	return ret;
>   }
>
>

