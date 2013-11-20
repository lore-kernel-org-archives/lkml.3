Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab3KTUgs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 15:36:48 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:36869 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755164Ab3KTUgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 15:36:44 -0500
Date: Wed, 20 Nov 2013 15:36:42 -0500 (EST)
Message-Id: <20131120.153642.2045230991917379052.davem@davemloft.net>
To: sebastian.hesselbarth@gmail.com
Cc: netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v1 0/7] net: phy: Ethernet PHY powerdown
 optimization
From: David Miller <davem@davemloft.net>
In-Reply-To: <1384978913-8052-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1384978913-8052-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 20 Nov 2013 12:36:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Date: Wed, 20 Nov 2013 21:21:46 +0100

> Ethernet PHYs consume a significant amount of power when link is detected.
> Especially, for embedded systems it can be easily 20-40% of total system
> power. Now, currently most likely all ethernet drivers leave PHYs powered
> on, even if the device is taken down. Also, some stupid boot loaders power
> on all PHYs available.
> 
> This RFC deals with saving power consumed by ethernet PHYs, that have no
> corresponding ethernet device driver or are attached to ethernet devices
> which are taken down by user request, i.e. ifconfig ethN down. Ports with
> no link, i.e. cable removed, are already quite good at power saving due to
> PHY internal link detection.

The idea is sound and the goal is of course valuable, but it brings up
a chronically reoccurring issue as of late.

You cannot reset the PHY or take it down without somehow retaining the
settings the PHY had when you bring it back up.

If I ifdown/ifup a device, my ethtool link configuration better be
retained.

This means the PHY layer must have a way to reprogram the device when
it is brought back up, with whatever settings the software state
things are there.
