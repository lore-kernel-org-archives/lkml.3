Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768Ab3HEWm2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 18:42:28 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:54350 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754946Ab3HEWm0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 18:42:26 -0400
Date: Mon, 5 Aug 2013 15:42:22 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Linus =?ISO-8859-1?B?TPxzc2luZw==?= <linus.luessing@web.de>
Cc: bridge@lists.linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Cong Wang <amwang@redhat.com>, Adam Baker <linux@baker-net.org.uk>,
        Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH] bridge: don't try to update timers in case of broken
 MLD queries
Message-ID: <20130805154222.58361734@nehalam.linuxnetplumber.net>
In-Reply-To: <1375741925-22179-1-git-send-email-linus.luessing@web.de>
References: <1375741925-22179-1-git-send-email-linus.luessing@web.de>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  6 Aug 2013 00:32:05 +0200
Linus Lüssing <linus.luessing@web.de> wrote:

> Currently we are reading an uninitialized value for the max_delay
> variable when snooping an MLD query message of invalid length and would
> update our timers with that.
> 
> Fixing this by simply ignoring such broken MLD queries (just like we do
> for IGMP already).
> 
> This is a regression introduced by:
> "bridge: disable snooping if there is no querier" (b00589af3b04)
> 
> Reported-by: Paul Bolle <pebolle@tiscali.nl>
> Signed-off-by: Linus Lüssing <linus.luessing@web.de>
> ---
>  net/bridge/br_multicast.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
> index 61c5e81..08e576a 100644
> --- a/net/bridge/br_multicast.c
> +++ b/net/bridge/br_multicast.c
> @@ -1195,7 +1195,7 @@ static int br_ip6_multicast_query(struct net_bridge *br,
>  		max_delay = msecs_to_jiffies(ntohs(mld->mld_maxdelay));
>  		if (max_delay)
>  			group = &mld->mld_mca;
> -	} else if (skb->len >= sizeof(*mld2q)) {
> +	} else {
>  		if (!pskb_may_pull(skb, sizeof(*mld2q))) {
>  			err = -EINVAL;
>  			goto out;

Why not use else if here, other than that looks great.
