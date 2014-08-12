Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838AbaHLMPG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 08:15:06 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:35811 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbaHLMPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 08:15:03 -0400
Message-ID: <1407845701.10122.60.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH] tcp: don't use timestamp from repaired skb-s to
 calculate RTT
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andrey Vagin <avagin@openvz.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Tue, 12 Aug 2014 05:15:01 -0700
In-Reply-To: <1407836714-26813-1-git-send-email-avagin@openvz.org>
References: <1407836714-26813-1-git-send-email-avagin@openvz.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-08-12 at 13:45 +0400, Andrey Vagin wrote:
> We don't know right timestamp for repaired skb-s. Wrong RTT estimations
> isn't good, because some congestion modules heavily depends on it.
> 
> This patch adds the TCPCB_REPAIRED flag, which is included in
> TCPCB_RETRANS.

...

> +
> +				/* All packets are restored as if they have
> +				 * already been sent. skb_mstamp isn't set to
> +				 * avoid wrong rtt estimation.
> +				 */
> +				if (tp->repair) {
> +					TCP_SKB_CB(skb)->sacked |= TCPCB_REPAIRED;
> +					TCP_SKB_CB(skb)->when = tcp_time_stamp;
> +				}
>  			}
>  
>  			/* Try to append data to the end of skb. */


Are you sure TCP_SKB_CB(skb)->when needs to be set ?

It should not anymore.

If yes, I believe a comment would help a lot here.

Also, please include this tag to ease stable backports (3.15+) :

Fixes: 431a91242d8d ("tcp: timestamp SYN+DATA messages")
Fixes: 740b0f1841f6 ("tcp: switch rtt estimations to usec resolution")

Thanks !


