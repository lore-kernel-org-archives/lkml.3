Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508Ab3C1OcT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 10:32:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:34958 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab3C1OcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 10:32:17 -0400
Date: Thu, 28 Mar 2013 14:32:16 +0000
From: Thomas Graf <tgraf@suug.ch>
To: Hong Zhiguo <honkiko@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net,
        stephen@networkplumber.org
Subject: Re: [PATCH 1/6] net-next: replace obsolete NLMSG_* with type safe
 nlmsg_*
Message-ID: <20130328143216.GC23043@casper.infradead.org>
References: <1364402824-32680-1-git-send-email-honkiko@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364402824-32680-1-git-send-email-honkiko@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <tgraf@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/13 at 12:47am, Hong Zhiguo wrote:
> diff --git a/net/ipv4/udp_diag.c b/net/ipv4/udp_diag.c
> index 505b30a..467fb92 100644
> --- a/net/ipv4/udp_diag.c
> +++ b/net/ipv4/udp_diag.c
> @@ -64,9 +64,9 @@ static int udp_dump_one(struct udp_table *tbl, struct sk_buff *in_skb,
>  		goto out;
>  
>  	err = -ENOMEM;
> -	rep = alloc_skb(NLMSG_SPACE((sizeof(struct inet_diag_msg) +
> -				     sizeof(struct inet_diag_meminfo) +
> -				     64)), GFP_KERNEL);
> +	rep = nlmsg_new(sizeof(struct inet_diag_msg) +
> +				     sizeof(struct inet_diag_meminfo) + 64,
> +				     GFP_KERNEL);

This is formatted incorrectly, otherwise the patch looks good.
