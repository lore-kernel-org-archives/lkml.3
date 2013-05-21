Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341Ab3EUOfm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 10:35:42 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:50685 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861Ab3EUOfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 10:35:40 -0400
Message-ID: <1369146938.3301.225.camel@edumazet-glaptop>
Subject: Re: [PATCH v4 net-next 1/4] net: implement support for low latency
 socket polling
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: Dave Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Or Gerlitz <or.gerlitz@gmail.com>,
        Eilon Greenstien <eilong@broadcom.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Date: Tue, 21 May 2013 07:35:38 -0700
In-Reply-To: <20130521142650.18498.71715.stgit@ladj378.jer.intel.com>
References: <20130521142641.18498.52856.stgit@ladj378.jer.intel.com>
	 <20130521142650.18498.71715.stgit@ladj378.jer.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-21 at 17:26 +0300, Eliezer Tamir wrote:

> +/* should be called when destroying a napi struct */
> +static inline void inc_ll_gen_id(void)
> +{
> +	ll_global_gen_id++;
> +}
> +
> +static inline void skb_mark_ll(struct sk_buff *skb, struct napi_struct *napi)
> +{
> +	skb->dev_ref = napi;
> +	skb->ll_gen_id = SKB_LL_GEN(ll_global_gen_id);
> +}
> +
> +static inline void sk_mark_ll(struct sock *sk, struct sk_buff *skb)
> +{
> +	if (skb->dev_ref && skb->ll_gen_id == SKB_LL_GEN(ll_global_gen_id)) {
> +		sk->dev_ref = skb->dev_ref;
> +		sk->ll_gen_id = ll_global_gen_id;
> +	} else
> +		sk->dev_ref = NULL; /* clear expired ref */
> +}
> +

Thats really hacky.

Please dont rush sending a new patch set every day.



