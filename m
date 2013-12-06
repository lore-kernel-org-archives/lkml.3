Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031Ab3LFGI1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 01:08:27 -0500
Received: from mail.active-venture.com ([67.228.131.205]:62801 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631Ab3LFGI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 01:08:26 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52A169D4.4060209@roeck-us.net>
Date: Thu, 05 Dec 2013 22:08:20 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Zhi Yong Wu <zwu.kernel@gmail.com>, netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: Re: [net-next PATCH 3/6] macvtap: remove the dead branch
References: <1386282527-14094-1-git-send-email-zwu.kernel@gmail.com> <1386282527-14094-4-git-send-email-zwu.kernel@gmail.com>
In-Reply-To: <1386282527-14094-4-git-send-email-zwu.kernel@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2013 02:28 PM, Zhi Yong Wu wrote:
> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>
> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> ---
>   drivers/net/macvtap.c |    2 --
>   1 files changed, 0 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
> index 9093004..d271fb4 100644
> --- a/drivers/net/macvtap.c
> +++ b/drivers/net/macvtap.c
> @@ -779,8 +779,6 @@ static ssize_t macvtap_put_user(struct macvtap_queue *q,
>   			return -EINVAL;
>
>   		ret = macvtap_skb_to_vnet_hdr(skb, &vnet_hdr);
> -		if (ret)
> -			return ret;
>
Assigning the function's return value to ret just to ignore it seems odd.

Might make sense to change the function type to void.

Guenter

