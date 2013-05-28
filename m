Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736Ab3E1UJW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 16:09:22 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51073 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755425Ab3E1UJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 16:09:21 -0400
Date: Tue, 28 May 2013 13:09:20 -0700 (PDT)
Message-Id: <20130528.130920.1604291112518863799.davem@davemloft.net>
To: alexandre.belloni@free-electrons.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        shawn.guo@linaro.org, kernel@pengutronix.de
Subject: Re: [PATCHv2 1/3] net: phy: prevent linking breakage
From: David Miller <davem@davemloft.net>
In-Reply-To: <1369741403-25315-2-git-send-email-alexandre.belloni@free-electrons.com>
References: <1369741403-25315-1-git-send-email-alexandre.belloni@free-electrons.com>
	<1369741403-25315-2-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Date: Tue, 28 May 2013 13:43:21 +0200

> phy_register_fixup{,_for_uid,_for_id} are called from arch/, quite
> often, there is no protection to check whether CONFIG_PHYLIB=y which is
> the only case where this would work. Having phylib as a module or not
> compiled at all will result in that kind of linking failure:
> 
> arch/arm/mach-at91/built-in.o: In function `ksz9021rn_phy_fixup':
> :(.text+0x1174): undefined reference to `mdiobus_write'
> :(.text+0x1188): undefined reference to `mdiobus_write'
> :(.text+0x119c): undefined reference to `mdiobus_write'
> :(.text+0x11b0): undefined reference to `mdiobus_write'
> arch/arm/mach-at91/built-in.o: In function `sama5_dt_device_init':
> :(.init.text+0x1e34): undefined reference to `phy_register_fixup_for_uid'
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

This is the wrong way to go about this.

If the arch code absolutely requires CONFIG_PHYLIB=y then express that
dependency in the arch Kconfig.  The arch code in question should not
be compiled at all if CONFIG_PHYLIB has an incompatible setting.
