Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733AbaGJJRJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 05:17:09 -0400
Received: from canardo.mork.no ([148.122.252.1]:55424 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199AbaGJJRG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 05:17:06 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Tom Gundersen <teg@jklm.no>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        David Herrmann <dh.herrmann@gmail.com>, Kay Sievers <kay@vrfy.org>
Subject: Re: [PATCH v7 03/33] net: set name_assign_type in alloc_netdev()
Organization: m
References: <1404980258-30853-1-git-send-email-teg@jklm.no>
	<1404980258-30853-4-git-send-email-teg@jklm.no>
Date: Thu, 10 Jul 2014 11:16:50 +0200
In-Reply-To: <1404980258-30853-4-git-send-email-teg@jklm.no> (Tom Gundersen's
	message of "Thu, 10 Jul 2014 10:17:08 +0200")
Message-ID: <87tx6ph8u5.fsf@nemi.mork.no>
User-Agent: Gnus/5.130011 (Ma Gnus v0.11) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tom Gundersen <teg@jklm.no> writes:

> diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
> index 5dc638c..f405e05 100644
> --- a/net/ethernet/eth.c
> +++ b/net/ethernet/eth.c
> @@ -390,7 +390,8 @@ EXPORT_SYMBOL(ether_setup);
>  struct net_device *alloc_etherdev_mqs(int sizeof_priv, unsigned int txqs,
>  				      unsigned int rxqs)
>  {
> -	return alloc_netdev_mqs(sizeof_priv, "eth%d", ether_setup, txqs, rxqs);
> +	return alloc_netdev_mqs(sizeof_priv, "eth%d", NET_NAME_UNKNOWN,
> +				ether_setup, txqs, rxqs);
>  }
>  EXPORT_SYMBOL(alloc_etherdev_mqs);

I believe this chunk makes the rest of this exercise pretty pointless.

bjorn@nemi:/usr/local/src/git/linux$ git grep alloc_etherdev drivers/net/|wc -l
283

I don't care enough to go look, but I'd be surprised if none of those
drivers rename the device before registering it.


Bjørn
