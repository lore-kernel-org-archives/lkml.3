Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875Ab3AOE5O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 23:57:14 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:62768 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755501Ab3AOE5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 23:57:13 -0500
Subject: Re: [PATCH 1/1] net: ipv4: refine the logic for determining daddr
 in ip_queue_xmit.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Harvey Yang <harvey.huawei.yang@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1358225255-30973-1-git-send-email-harvey.huawei.yang@gmail.com>
References: <1358225255-30973-1-git-send-email-harvey.huawei.yang@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Jan 2013 20:57:09 -0800
Message-ID: <1358225829.8744.4508.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-15 at 12:47 +0800, Harvey Yang wrote:
> The destination address daddr is faddr if source route option is set, otherwise it is inet_daddr. So use if-else to assign the value.
> 
> Signed-off-by: Harvey Yang <harvey.huawei.yang@gmail.com>
> ---
>  net/ipv4/ip_output.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
> index 3e98ed2..22b738c 100644
> --- a/net/ipv4/ip_output.c
> +++ b/net/ipv4/ip_output.c
> @@ -349,10 +349,10 @@ int ip_queue_xmit(struct sk_buff *skb, struct flowi *fl)
>  		__be32 daddr;
>  
>  		/* Use correct destination address if we have options. */
> -		daddr = inet->inet_daddr;
>  		if (inet_opt && inet_opt->opt.srr)
>  			daddr = inet_opt->opt.faddr;
> -
> +		else
> +			daddr = inet->inet_daddr;
>  		/* If this fails, retransmit mechanism of transport layer will
>  		 * keep trying until route appears or the connection times
>  		 * itself out.

Current code is faster, srr is not often used.



