Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750919AbaACKpU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 05:45:20 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:59227 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbaACKpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 05:45:17 -0500
Message-ID: <52C694BF.3020903@cogentembedded.com>
Date: Fri, 03 Jan 2014 14:45:19 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Libo Chen <clbchenlibo.chen@huawei.com>,
        David Miller <davem@davemloft.net>
CC: edumazet@google.com, kaber@trash.net, peterz@infradead.org,
        honkiko@gmail.com, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, jhs@mojatatu.com,
        Li Zefan <lizefan@huawei.com>, Serge Hallyn <serge.hallyn@ubuntu.com>
Subject: Re: [RFC PATCH net-next 3/4] veth: backup classid befor switch net_ns
References: <52C62A52.8050003@huawei.com>
In-Reply-To: <52C62A52.8050003@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 03-01-2014 7:11, Libo Chen wrote:

> dev_forward_skb will clear skb->sk, so we need save classid
> before that, otherwise the skb can not be under control by
> net_cls.

> Signed-off-by: Libo Chen <clbchenlibo.chen@huawei.com>
> ---
>   drivers/net/veth.c | 7 +++++++
>   1 file changed, 7 insertions(+)

> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> index 2ec2041..ce43a2d 100644
> --- a/drivers/net/veth.c
> +++ b/drivers/net/veth.c
[...]
> @@ -123,6 +124,12 @@ static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *dev)
>   	    rcv->features & NETIF_F_RXCSUM)
>   		skb->ip_summed = CHECKSUM_UNNECESSARY;
>
> +	/**

    Why you're using kernel-doc style comments out of place? The format of 
multi-line comments  in the networking code is this:

/* bla
  * bla
  */

> +	 * dev_forward_sbk will clear skb->sk, so save
> +	 * skb->sk->sk_classid for Qos
> +	 */
> +	bk_cls_classid(skb);
> +

WBR, Sergei


