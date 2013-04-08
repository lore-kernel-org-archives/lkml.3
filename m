Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934622Ab3DHQQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 12:16:17 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49322 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934422Ab3DHQQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 12:16:16 -0400
Date: Mon, 08 Apr 2013 12:16:14 -0400 (EDT)
Message-Id: <20130408.121614.2170605259377916404.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: netdev@vger.kernel.org, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Subject: Re: [PATCH net,1/2] hyperv: Fix a kernel warning from
 netvsc_linkstatus_callback()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1365198280-23270-1-git-send-email-haiyangz@microsoft.com>
References: <1365198280-23270-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Mon, 08 Apr 2013 09:16:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Fri,  5 Apr 2013 14:44:39 -0700

> The warning about local_bh_enable inside IRQ happens when disconnecting a
> virtual NIC.
> 
> The reason for the warning is -- netif_tx_disable() is called when the NIC
> is disconnected. And it's called within irq context. netif_tx_disable() calls
> local_bh_enable() which displays warning if in irq.
> 
> The fix is to remove the unnecessary netif_tx_disable & wake_queue() in the
> netvsc_linkstatus_callback().
> 
> Reported-by: Richard Genoud <richard.genoud@gmail.com>
> Tested-by: Long Li <longli@microsoft.com>
> Tested-by: Richard Genoud <richard.genoud@gmail.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>

Applied.
