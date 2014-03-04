Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903AbaCDQwq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 11:52:46 -0500
Received: from mail-yh0-f42.google.com ([209.85.213.42]:42572 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221AbaCDQwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 11:52:45 -0500
Message-ID: <1393951929.26794.120.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH net-next 08/12] r8152: support TSO
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Hayes Wang <hayeswang@realtek.com>
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Date: Tue, 04 Mar 2014 08:52:09 -0800
In-Reply-To: <1393934464-23675-9-git-send-email-hayeswang@realtek.com>
References: <1393934464-23675-1-git-send-email-hayeswang@realtek.com>
	 <1393934464-23675-9-git-send-email-hayeswang@realtek.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-04 at 20:01 +0800, Hayes Wang wrote:
> Support scatter gather and TSO.

>  
> -	netdev->features |= NETIF_F_RXCSUM | NETIF_F_IP_CSUM;
> -	netdev->hw_features = NETIF_F_RXCSUM | NETIF_F_IP_CSUM;
> +	netdev->features |= NETIF_F_RXCSUM | NETIF_F_IP_CSUM | NETIF_F_SG |
> +			    NETIF_F_TSO;
> +	netdev->hw_features = NETIF_F_RXCSUM | NETIF_F_IP_CSUM | NETIF_F_SG |
> +			      NETIF_F_TSO;
>  

Minor nit :

If you use skb_copy_bits(), then you also can add NETIF_F_FRAGLIST here.



