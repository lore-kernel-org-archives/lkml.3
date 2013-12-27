Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab3L0R2R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 12:28:17 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:59714 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068Ab3L0R2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 12:28:15 -0500
Date: Fri, 27 Dec 2013 12:28:13 -0500 (EST)
Message-Id: <20131227.122813.901851776030758668.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next 4/6] r8152: add rtl_ops
From: David Miller <davem@davemloft.net>
In-Reply-To: <1388111649-1014-5-git-send-email-hayeswang@realtek.com>
References: <1388111649-1014-1-git-send-email-hayeswang@realtek.com>
	<1388111649-1014-5-git-send-email-hayeswang@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 27 Dec 2013 09:28:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Fri, 27 Dec 2013 10:34:08 +0800

>  
> +static int rtl_ops_init(struct r8152 *tp, const struct usb_device_id *id)
 ...
>  
> +	if (rtl_ops_init(tp, id)) {
> +		netif_err(tp, probe, netdev, "Unknown Device");
> +		return -ENODEV;

You're completely ignoring the error code returned from rtl_ops_init()
(which, as an aside, uses -EFAULT which doesn't seem all that
appropriate).

You might as well have rtl_ops_init() return a boolean.
