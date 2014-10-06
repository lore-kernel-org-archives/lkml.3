Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184AbaJFBP4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 21:15:56 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:56477 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbaJFBPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 21:15:54 -0400
Date: Sun, 05 Oct 2014 21:15:52 -0400 (EDT)
Message-Id: <20141005.211552.452619735296906900.davem@davemloft.net>
To: antoine.tenart@free-electrons.com
Cc: dan.carpenter@oracle.com, kou.ishizaki@toshiba.co.jp, jens@de.ibm.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] net: spider_net: fix possible bitops errors
From: David Miller <davem@davemloft.net>
In-Reply-To: <1412348517-20352-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1412348517-20352-1-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 Oct 2014 18:15:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Antoine Tenart <antoine.tenart@free-electrons.com>
Date: Fri,  3 Oct 2014 17:01:53 +0200

> Dan reported a possible signedness issue on the pxa168_eth driver. While
> having a look at it, I came across a similar problem in the spider_net
> driver.
> 
> Here is one proposal to fix it. The first patch rework the
> spider_net_set_mac() function by removing the spider_net_get_mac_address()
> call and using memcpy() to set netdev->dev_addr (which is what's done in
> lots of Ethernet drivers) and the second one fix the actual signedness
> issue.
> 
> If for any reason you really want to keep a call to
> spider_net_get_mac_address() because the memcpy() is somehow not good
> enough here, we can also come up with a solution involving a temporary
> unsigned char variable.

Series applied, thanks.
