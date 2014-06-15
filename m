Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428AbaFOGxG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 02:53:06 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38638 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbaFOGxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 02:53:05 -0400
Date: Sat, 14 Jun 2014 23:53:00 -0700 (PDT)
Message-Id: <20140614.235300.1228145928404410306.davem@davemloft.net>
To: xerofoify@gmail.com
Cc: andriy.shevchenko@linux.intel.com, dvhart@linux.intel.com,
        jeffrey.t.kirsher@intel.com, ast@plumgrid.com, dborkman@redhat.com,
        bhutchings@solarflare.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Missing return check against Null for return value of
 netdev_alloc_dev_skb()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1402805139-6363-1-git-send-email-xerofoify@gmail.com>
References: <1402805139-6363-1-git-send-email-xerofoify@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sat, 14 Jun 2014 23:53:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick <xerofoify@gmail.com>
Date: Sun, 15 Jun 2014 00:05:39 -0400

> Signed-off-by: Nick <xerofoify@gmail.com>
> ---
>  drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
> index 73e6683..704cf63 100644
> --- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
> +++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
> @@ -1515,6 +1515,8 @@ static void pch_gbe_alloc_tx_buffers(struct pch_gbe_adapter *adapter,
>  	for (i = 0; i < tx_ring->count; i++) {
>  		buffer_info = &tx_ring->buffer_info[i];
>  		skb = netdev_alloc_skb(adapter->netdev, bufsz);
> +		if (!skb)
> +			return NULL;

You didn't even compile test this.

The function has a void return type, you can't return NULL.

Furthermore, you have to adjust things so that the caller knows that
this operation failed, because the device cannot be brought up
successfully unless all the TX buffer slots get allocated properly.
