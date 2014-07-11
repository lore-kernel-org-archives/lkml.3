Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231AbaGKVwg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 17:52:36 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57864 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbaGKVwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 17:52:34 -0400
Date: Fri, 11 Jul 2014 14:52:33 -0700 (PDT)
Message-Id: <20140711.145233.467436750120498278.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net] r8152: fix r8152_csum_workaround function
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394712342-15778-14-Taiwan-albertk@realtek.com>
References: <1394712342-15778-14-Taiwan-albertk@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 11 Jul 2014 14:52:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Fri, 11 Jul 2014 16:48:27 +0800

> The transport offset of the IPv4 packet should be fixed and wouldn't
> be out of the hw limitation, so the r8152_csum_workaround() should
> be used for IPv6 packets.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

Applied and queued up for -stable, but this patch was harder to review
than it needed to be...

> -		features &= ~(NETIF_F_IP_CSUM | NETIF_F_SG | NETIF_F_TSO);
> +		features &= ~(NETIF_F_SG | NETIF_F_IPV6_CSUM | NETIF_F_TSO6);

because you changed the order of the flags unnecessarily.
