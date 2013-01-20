Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940Ab3ATJvR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 04:51:17 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:33510 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404Ab3ATJvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 04:51:15 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 20 Jan 2013 10:50:58 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Cc: linux1394-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire net: Ensure checksumming in upper layer.
Message-ID: <20130120105058.1aee26c4@stein>
In-Reply-To: <50FBA02C.9030203@linux-ipv6.org>
References: <50FBA02C.9030203@linux-ipv6.org>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.12; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 20 YOSHIFUJI Hideaki wrote:
> It is wrong to set skb->ip_summed to CHECKSUM_UNNECESSARY unless
> the device has already checked it.
> 
> Signed-off-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
> ---
>  drivers/firewire/net.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/firewire/net.c b/drivers/firewire/net.c
> index e7a711f5..df6a1ca 100644
> --- a/drivers/firewire/net.c
> +++ b/drivers/firewire/net.c
> @@ -520,7 +520,7 @@ static int fwnet_finish_incoming_packet(struct net_device *net,
>  	dev = netdev_priv(net);
>  	/* Write metadata, and then pass to the receive level */
>  	skb->dev = net;
> -	skb->ip_summed = CHECKSUM_UNNECESSARY;  /* don't check it */
> +	skb->ip_summed = CHECKSUM_NONE;
>  
>  	/*
>  	 * Parse the encapsulation header. This actually does the job of

Indeed neither the device nor the lower drivers check protocol checksums.
But the CRCs of the encapsulating 1394 packets are checked in hardware.
Shall protocol checksums be verified regardless?
-- 
Stefan Richter
-=====-===-= ---= =-=--
http://arcgraph.de/sr/
