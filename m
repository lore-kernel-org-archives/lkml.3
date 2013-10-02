Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab3JBVMj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 17:12:39 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49541 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733Ab3JBVMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 17:12:37 -0400
Date: Wed, 02 Oct 2013 17:12:33 -0400 (EDT)
Message-Id: <20131002.171233.1409614287842381990.davem@davemloft.net>
To: sebastian.hesselbarth@gmail.com
Cc: buytenh@wantstofly.org, jason@lakedaemon.net, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] net: mv643xx_eth: various small fixes for v3.12
From: David Miller <davem@davemloft.net>
In-Reply-To: <1380711442-24735-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1380711442-24735-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 02 Oct 2013 14:12:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Date: Wed,  2 Oct 2013 12:57:19 +0200

> This patch set comprises some one-liners to fix issues with repeated
> loading and unloading of a modular mv643xx_eth driver.
> 
> First two patches take care of the periodic port statistic timer, that
> updates statistics by reading port registers using add_timer/mod_timer.
> 
> Patch 1 moves timer re-schedule from mib_counters_update to the timer
> callback. As mib_counters_update is also called from non-timer context,
> this ensures the timer is reactivated from timer context only.
> 
> Patch 2 moves initial timer schedule from _probe() time to right before
> the port is actually started as the corresponding del_timer_sync is at
> _stop() time. This fixes a regression, where unloading the driver from a
> non-started eth device can cause the timer to access deallocated mem.
> 
> Patch 3 adds an assignment of the ports device_node to the corresponding
> self-created platform_device. This is required to allow fixups based on
> the device_node's compatible string later. Actually, it is also a potential
> regression because we already check compatible string for Kirkwood, but
> does not (yet) rely on the fixup.
> 
> All patches are based on v3.12-rc3 and have been tested on Kirkwood-based
> Seagate Dockstar.
> 
> Patches 1 and 2 can also possibly queued up for -stable.

Series applied, patch #1 and #2 queued up for -stable, thanks!
