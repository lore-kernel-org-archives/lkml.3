Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298AbaKGQf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 11:35:29 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:39881 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbaKGQf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 11:35:26 -0500
Date: Fri, 07 Nov 2014 11:35:22 -0500 (EST)
Message-Id: <20141107.113522.837502028522211960.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] r8152: adjust rtl_start_rx
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394712342-15778-90-Taiwan-albertk@realtek.com>
References: <1394712342-15778-88-Taiwan-albertk@realtek.com>
	<1394712342-15778-90-Taiwan-albertk@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 07 Nov 2014 08:35:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Fri, 7 Nov 2014 17:55:11 +0800

> Submit all the rx buffers, even though a error occurs. Otherwise
> the buffers which are not submitted would be lost until next
> rtl_start_rx() is called. Besides, the fail buffer could be
> re-submitted later.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

Does this even work?

If you leave a hole in the ring, the device is going to stop there
anyways.

So better to replenish the next time you call into this function
rather than leaving gaps in your receive ring.
