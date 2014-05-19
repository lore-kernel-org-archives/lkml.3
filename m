Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932782AbaESRo5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 13:44:57 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:41345 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932438AbaESRo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 13:44:56 -0400
Message-ID: <1400521493.5367.61.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH] macvlan: Fix checksum errors when ip_summed is
 CHECKSUM_PARTIAL
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Michael Spang <spang@chromium.org>
Cc: Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Daniel Lezcano <daniel.lezcano@free.fr>
Date: Mon, 19 May 2014 10:44:53 -0700
In-Reply-To: <1400520254-5142-1-git-send-email-spang@chromium.org>
References: <1400520254-5142-1-git-send-email-spang@chromium.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-19 at 13:24 -0400, Michael Spang wrote:
> Changing ip_summed from CHECKSUM_PARTIAL to CHECKSUM_UNNECESSARY
> will result in an incorrect checksum if the packet is sent off the box.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Michael Spang <spang@chromium.org>
> ---
>  drivers/net/macvlan.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
> index 753a8c2..806b56a 100644
> --- a/drivers/net/macvlan.c
> +++ b/drivers/net/macvlan.c
> @@ -267,7 +267,9 @@ static int macvlan_queue_xmit(struct sk_buff *skb, struct net_device *dev)
>  
>  	if (vlan->mode == MACVLAN_MODE_BRIDGE) {
>  		const struct ethhdr *eth = (void *)skb->data;
> -		skb->ip_summed = CHECKSUM_UNNECESSARY;
> +
> +		if (skb->ip_summed == CHECKSUM_NONE)
> +			skb->ip_summed = CHECKSUM_UNNECESSARY;
>  
>  		/* send to other bridge ports directly */
>  		if (is_multicast_ether_addr(eth->h_dest)) {

Hi Michael

Any idea why commit 12a2856b604476c27d85a5f9a57ae1661fc46019
added this stuff then ?

You should give more infos of your use case.

CC Daniel Lezcano <daniel.lezcano@free.fr>

I removed stable@ , as stable submissions are not done like that.


