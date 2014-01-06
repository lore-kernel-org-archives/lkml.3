Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757052AbaAFW7A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:59:00 -0500
Received: from mail-yh0-f54.google.com ([209.85.213.54]:47491 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756412AbaAFW66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:58:58 -0500
Message-ID: <1389049135.26646.14.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH 3.4 22/43] tg3: Expand 4g_overflow_test workaround to
 skb fragments of any size.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Nithin Nayak Sujir <nsujir@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Mon, 06 Jan 2014 14:58:55 -0800
In-Reply-To: <20140106223942.884336164@linuxfoundation.org>
References: <20140106223942.259651490@linuxfoundation.org>
	 <20140106223942.884336164@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-01-06 at 14:39 -0800, Greg Kroah-Hartman wrote:
> 3.4-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Nithin Sujir <nsujir@broadcom.com>
> 
> commit 375679104ab3ccfd18dcbd7ba503734fb9a2c63a upstream.
> 
> The current driver assumes that an skb fragment can only be upto jumbo
> size. Presumably this was a fast-path optimization. This assumption is
> no longer true as fragments can be upto 32k.
> 
> v2: Remove unnecessary parantheses per Eric Dumazet.
> 
> Signed-off-by: Nithin Nayak Sujir <nsujir@broadcom.com>
> Signed-off-by: Michael Chan <mchan@broadcom.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  drivers/net/ethernet/broadcom/tg3.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/drivers/net/ethernet/broadcom/tg3.c
> +++ b/drivers/net/ethernet/broadcom/tg3.c
> @@ -6619,7 +6619,7 @@ static inline int tg3_4g_overflow_test(d
>  {
>  	u32 base = (u32) mapping & 0xffffffff;
>  
> -	return (base > 0xffffdcc0) && (base + len + 8 < base);
> +	return base + len + 8 < base;
>  }
>  

Minor comment :

32KB frags were added later, in 3.7.

This patch makes no harm, so no worries.


