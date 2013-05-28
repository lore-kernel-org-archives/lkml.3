Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758318Ab3E1A0Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 20:26:25 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:53449 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758252Ab3E1A0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 20:26:23 -0400
Message-ID: <1369700781.3301.497.camel@edumazet-glaptop>
Subject: Re: [PATCH v5 net-next 2/5] net: implement support for low latency
 socket polling
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: Dave Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eilon Greenstien <eilong@broadcom.com>,
        Or Gerlitz <or.gerlitz@gmail.com>, Alex Rosenbaum <alexr@mellanox.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Date: Mon, 27 May 2013 17:26:21 -0700
In-Reply-To: <20130527074411.29882.88391.stgit@ladj378.jer.intel.com>
References: <20130527074351.29882.51106.stgit@ladj378.jer.intel.com>
	 <20130527074411.29882.88391.stgit@ladj378.jer.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-27 at 10:44 +0300, Eliezer Tamir wrote:

> diff --git a/include/net/sock.h b/include/net/sock.h
> index 66772cf..c7c3ea6 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -281,6 +281,7 @@ struct cg_proto;
>    *	@sk_error_report: callback to indicate errors (e.g. %MSG_ERRQUEUE)
>    *	@sk_backlog_rcv: callback to process the backlog
>    *	@sk_destruct: called at sock freeing time, i.e. when all refcnt == 0
> +  *	@sk_napi_id: id of the last napi context to receive data for sk
>   */
>  struct sock {
>  	/*
> @@ -399,6 +400,9 @@ struct sock {
>  	int			(*sk_backlog_rcv)(struct sock *sk,
>  						  struct sk_buff *skb);
>  	void                    (*sk_destruct)(struct sock *sk);
> +#ifdef CONFIG_NET_LL_RX_POLL
> +	unsigned int		sk_napi_id;
> +#endif
>  };

I believe this is a bad choice for data locality.

I would rather move it in the same cache line than sk_rxhash



