Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758751Ab3HOUl3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 16:41:29 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:40048 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289Ab3HOUl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 16:41:27 -0400
MIME-Version: 1.0
In-Reply-To: <20130815174626.GA10874@redhat.com>
References: <20130815174626.GA10874@redhat.com>
Date: Fri, 16 Aug 2013 04:41:26 +0800
Message-ID: <CAFeW=paTeaNsvK7ai-PPs6+MVW3LbaPaW9et_eu3XuGPpMqnuw@mail.gmail.com>
Subject: Re: [PATCH] macvtap: fix up direction in comment on offloading
From: Amos Kong <kongjianjun@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jason Wang <jasowang@redhat.com>, Eric Dumazet <edumazet@google.com>,
        Vlad Yasevich <vyasevic@redhat.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 1:46 AM, Michael S. Tsirkin <mst@redhat.com> wrote:
> It speaks about receiving frames, so while
> it says GSO, it really means GRO.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/net/macvtap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
> index a98fb0e..a98ed9f 100644
> --- a/drivers/net/macvtap.c
> +++ b/drivers/net/macvtap.c
> @@ -1047,7 +1047,7 @@ static int set_offload(struct macvtap_queue *q, unsigned long arg)
>          * accept TSO frames and turning it off means that user space
>          * does not support TSO.
>          * For macvtap, we have to invert it to mean the same thing.
> -        * When user space turns off TSO, we turn off GSO/LRO so that
> +        * When user space turns off TSO, we turn off GRO/LRO so that

Right fix.

Reviewed-by: Amos Kong <kongjianjun@gmail.com>

>          * user-space will not receive TSO frames.
>          */
>         if (feature_mask & (NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_UFO))
> --
> MST
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
