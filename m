Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910Ab3LKC46 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 21:56:58 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:53884 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab3LKC44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 21:56:56 -0500
Date: Tue, 10 Dec 2013 21:56:54 -0500 (EST)
Message-Id: <20131210.215654.1165181423931409066.davem@davemloft.net>
To: sebastian.hesselbarth@gmail.com
Cc: f.fainelli@gmail.com, mugunthanvnm@ti.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/6] net: mv643xx_eth: properly start/stop phy device
From: David Miller <davem@davemloft.net>
In-Reply-To: <20131210.215253.2121948728095674632.davem@davemloft.net>
References: <1386513631-11284-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1386513631-11284-2-git-send-email-sebastian.hesselbarth@gmail.com>
	<20131210.215253.2121948728095674632.davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 10 Dec 2013 18:56:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBB2v74U021443

From: David Miller <davem@davemloft.net>
Date: Tue, 10 Dec 2013 21:52:53 -0500 (EST)

> 
> This series looks good, applied to net-next, thanks.

Actually, I had to revert.

You cannot use late_initcall_sync() from code that is potentially
built modular, this caused my build to fail at the mdio_bus code.

drivers/net/phy/mdio_bus.c:344:1: warning: data definition has no type or storage class [enabled by default]
drivers/net/phy/mdio_bus.c:344:1: error: type defaults to ¡int¢ in declaration of ¡late_initcall_sync¢ [-Werror=implicit-int]
drivers/net/phy/mdio_bus.c:344:1: warning: parameter names (without types) in function declaration [enabled by default]
drivers/net/phy/mdio_bus.c:339:12: warning: ¡mdio_bus_class_suspend_unused¢ defined but not used [-Wunused-function]
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
