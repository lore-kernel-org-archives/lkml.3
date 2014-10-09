Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510AbaJIQ2k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 12:28:40 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:42114 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754972AbaJIQ2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 12:28:32 -0400
Date: Thu, 9 Oct 2014 09:28:29 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net sched: text ematch: zero out ts_state before using it
Message-ID: <20141009162829.GA20290@mew.home.network>
References: <1412870721-31061-1-git-send-email-osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412870721-31061-1-git-send-email-osandov@osandov.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 09:05:21AM -0700, Omar Sandoval wrote:
> textsearch_find zeroes out the offset, but the control buffer (which may or may
> not matter in this case) needs to be zeroed out as well.
> 
> Signed-off-by: Omar Sandoval <osandov@osandov.com>
> ---
>  net/sched/em_text.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/sched/em_text.c b/net/sched/em_text.c
> index 15d353d..2a1b6d9 100644
> --- a/net/sched/em_text.c
> +++ b/net/sched/em_text.c
> @@ -36,6 +36,8 @@ static int em_text_match(struct sk_buff *skb, struct tcf_ematch *m,
>  	int from, to;
>  	struct ts_state state;
>  
> +	memset(&state, 0, sizeof(state));
> +
>  	from = tcf_get_base_ptr(skb, tm->from_layer) - skb->data;
>  	from += tm->from_offset;
>  
> -- 
> 2.1.2
> 

I forgot to mention: this patch is against 3.17.

-- 
Omar
