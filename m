Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758599AbaLKTWZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 14:22:25 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:55718 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756097AbaLKTWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 14:22:23 -0500
Date: Thu, 11 Dec 2014 14:22:20 -0500 (EST)
Message-Id: <20141211.142220.610076934853342634.davem@davemloft.net>
To: jim.epost@gmail.com
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: randconfig build error with next-20141210, in
 drivers/net/ethernet/broadcom/genet
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+r1ZhjxtK8BtF16Mr9jXjqvFVV7KAAFjWqfVFUibNreZwZxTw@mail.gmail.com>
References: <CA+r1ZhjxtK8BtF16Mr9jXjqvFVV7KAAFjWqfVFUibNreZwZxTw@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 11 Dec 2014 11:22:22 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Davis <jim.epost@gmail.com>
Date: Wed, 10 Dec 2014 09:10:45 -0700

> Building with the attached random configuration file,
> 
> ERROR: "fixed_phy_register"
> [drivers/net/ethernet/broadcom/genet/genet.ko] undefined!

Florian, I don't understand why FIXED_PHY is only selected in Kconfig
if the driver is statically built into the kernel.

That makes no sense at all, you should need that module regardless of
how the driver itself is enabled.

Can't we just remove the "XXX=y" in all of those silly:

	select FIXED_PHY if XXX=y

expressions?

There are three such cases right now:

drivers/net/dsa/Kconfig:	select FIXED_PHY if NET_DSA_BCM_SF2=y
drivers/net/ethernet/broadcom/Kconfig:	select FIXED_PHY if BCMGENET=y
drivers/net/ethernet/broadcom/Kconfig:	select FIXED_PHY if SYSTEMPORT=y
