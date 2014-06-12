Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301AbaFLUNa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 16:13:30 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:36680 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbaFLUN2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 16:13:28 -0400
MIME-Version: 1.0
In-Reply-To: <CAECMkcPM+TVv1f1xBwpd85JGNteVWzU7wx9gccfcohu9r2116w@mail.gmail.com>
References: <CAECMkcPM+TVv1f1xBwpd85JGNteVWzU7wx9gccfcohu9r2116w@mail.gmail.com>
Date: Thu, 12 Jun 2014 22:13:28 +0200
Message-ID: <CAFLxGvw9SNoDdnz9FbwgkCDKEYsKG3HFwSE+LfTYsa=p2FP3JA@mail.gmail.com>
Subject: Re: Patch Very Minor to loopback.c
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Zachary <zacharyw09264@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 9:43 PM, Zachary <zacharyw09264@gmail.com> wrote:
> Very minor patch to loopback.c that I noticed while comparing the
> dummy.c code to loopback.c code (dummy.c was based on loopback.c).  I
> did not see a maintainer in MAINTAINERS in my cursory glance, so I
> apologize if this is to the wrong place.  I am testing this patch
> right now on my laptop and it appears to be working without issues.
> It also compiled without warnings.
>
> diff --git a/drivers/net/loopback.c b/drivers/net/loopback.c
> index bb96409..f9f88d7 100644
> --- a/drivers/net/loopback.c
> +++ b/drivers/net/loopback.c
> @@ -22,6 +22,7 @@
>   *                                      interface.
>   *             Alexey Kuznetsov:       Potential hang under some extreme
>   *                                     cases removed.
> + *             Zachary Winnerman:  Extremely minor patch in loopback_xmit

No need to add your name here.
Nowadays we have git to respect everyone’s credit.

>   *
>   *             This program is free software; you can redistribute it and/or
>   *             modify it under the terms of the GNU General Public License
> @@ -72,7 +73,6 @@ static netdev_tx_t loopback_xmit(struct sk_buff *skb,
>                                  struct net_device *dev)
>  {
>         struct pcpu_lstats *lb_stats;
> -       int len;
>
>         skb_orphan(skb);
>
> @@ -86,10 +86,9 @@ static netdev_tx_t loopback_xmit(struct sk_buff *skb,
>         /* it's OK to use per_cpu_ptr() because BHs are off */
>         lb_stats = this_cpu_ptr(dev->lstats);
>
> -       len = skb->len;
>         if (likely(netif_rx(skb) == NET_RX_SUCCESS)) {
>                 u64_stats_update_begin(&lb_stats->syncp);
> -               lb_stats->bytes += len;
> +               lb_stats->bytes += skb->len;
>                 lb_stats->packets++;
>                 u64_stats_update_end(&lb_stats->syncp);
>         }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Thanks,
//richard
