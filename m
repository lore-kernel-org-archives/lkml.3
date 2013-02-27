Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760719Ab3B0Slq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 13:41:46 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:55684 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508Ab3B0Slo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 13:41:44 -0500
Message-ID: <1361990502.15793.0.camel@edumazet-glaptop>
Subject: Re: [RFC PATCH 3/5] ixgbe: Add support for ndo_ll_poll
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Eliezer Tamir <eliezer.tamir@linux.jf.intel.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Dave Miller <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Date: Wed, 27 Feb 2013 10:41:42 -0800
In-Reply-To: <20130227175606.10611.55498.stgit@gitlad.jf.intel.com>
References: <20130227175549.10611.82188.stgit@gitlad.jf.intel.com>
	 <20130227175606.10611.55498.stgit@gitlad.jf.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-27 at 09:56 -0800, Eliezer Tamir wrote:

> @@ -1458,7 +1459,9 @@ static void ixgbe_rx_skb(struct ixgbe_q_vector *q_vector,
>  {
>  	struct ixgbe_adapter *adapter = q_vector->adapter;
>  
> -	if (!(adapter->flags & IXGBE_FLAG_IN_NETPOLL))
> +	if (ixgbe_qv_ll_polling(q_vector))
> +		netif_receive_skb(skb);
> +	else if (!(adapter->flags & IXGBE_FLAG_IN_NETPOLL))
>  		napi_gro_receive(&q_vector->napi, skb);
>  	else
>  		netif_rx(skb);

Interesting reordering issue here.

Why by-passing GRO stack if its enabled ?



