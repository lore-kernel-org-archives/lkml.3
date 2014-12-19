Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952AbaLSUoI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 15:44:08 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:59822 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbaLSUoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 15:44:05 -0500
Date: Fri, 19 Dec 2014 15:44:02 -0500 (EST)
Message-Id: <20141219.154402.54691026682141762.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] r8152: check the status before submitting
 rx
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394712342-15778-109-Taiwan-albertk@realtek.com>
References: <1394712342-15778-107-Taiwan-albertk@realtek.com>
	<1394712342-15778-109-Taiwan-albertk@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 19 Dec 2014 12:44:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Fri, 19 Dec 2014 16:56:00 +0800

> Don't submit the rx if the device is unplugged, linking down,
> or stopped.
 ...
> @@ -1789,6 +1789,11 @@ int r8152_submit_rx(struct r8152 *tp, struct rx_agg *agg, gfp_t mem_flags)
>  {
>  	int ret;
>  
> +	/* The rx would be stopped, so skip submitting */
> +	if (test_bit(RTL8152_UNPLUG, &tp->flags) ||
> +	    !test_bit(WORK_ENABLE, &tp->flags) || !(tp->speed & LINK_STATUS))
> +		return 0;
> +

I think netif_carrier_off() should always be true in all three of those
situations, and would be a much simpler test than what you've coded
here.
