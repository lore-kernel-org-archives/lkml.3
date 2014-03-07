Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602AbaCGV1g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 16:27:36 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:43588 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbaCGV1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 16:27:34 -0500
Date: Fri, 07 Mar 2014 16:27:32 -0500 (EST)
Message-Id: <20140307.162732.1801095905509663010.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next 0/7] r8152: tx/rx improvement
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394161480-2918-1-git-send-email-hayeswang@realtek.com>
References: <1393934464-23675-1-git-send-email-hayeswang@realtek.com>
	<1394161480-2918-1-git-send-email-hayeswang@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 07 Mar 2014 13:27:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Fri, 7 Mar 2014 11:04:33 +0800

>  - Select the suitable spin lock for each function.
>  - Add additional check to reduce the spin lock.
>  - Up the priority of the tx to avoid interrupted by rx.
>  - Support rx checksum, large send, and IPv6 hw checksum.

Series applied, thanks.

Note that if you ever add ->ndo_poll_controller support to this driver,
you will have to revert your spin_lock_irq{save,restore}() changes to
your ->ndo_start_xmit.

Because the transmit function can indeed be invoked from hard IRQ
context once you support netpoll.
