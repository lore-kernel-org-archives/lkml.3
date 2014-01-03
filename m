Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbaACXL4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 18:11:56 -0500
Received: from mail.us.es ([193.147.175.20]:38749 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753750AbaACXLx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 18:11:53 -0500
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus4 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.98/18317. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-100.2/7.5):. 
 Processed in 3.815523 secs); 03 Jan 2014 23:11:52 -0000
X-Spam-ASN: AS12715 95.20.0.0/16
X-Envelope-From: pneira@us.es
Date: Sat, 4 Jan 2014 00:11:46 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] netfilter: remove unused variable
Message-ID: <20140103231146.GA23904@localhost>
References: <1388554039-28452-1-git-send-email-mina86@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388554039-28452-1-git-send-email-mina86@mina86.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 01, 2014 at 06:27:19AM +0100, Michal Nazarewicz wrote:
> The nfmsg variable is not used (except in sizeof operator which does
> not care about its value) between the first and second time it is
> assigned the value.  Furthermore, nlmsg_data has no side effects, so
> the assignment can be safely removed.

Applied with minor glitch, see below.

Thanks.

> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
> Cc: Patrick McHardy <kaber@trash.net>
> ---
>  net/netfilter/nf_tables_api.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index f93b7d0..9c56adc 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -2521,7 +2521,6 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
>  	u32 portid, seq;
>  	int event, err;
>  
> -	nfmsg = nlmsg_data(cb->nlh);
>  	err = nlmsg_parse(cb->nlh, sizeof(*nfmsg), nla, NFTA_SET_ELEM_LIST_MAX,

mangled this patch to use sizeof(struct nfgenmsg) instead. That change
is not required from the semantic point of view, of course, but for
readability reasons I think it's better not to refer to a variable
that is not used in that context.

>  			  nft_set_elem_list_policy);
>  	if (err < 0)
> -- 
> 1.8.4
> 
