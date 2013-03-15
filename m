Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab3COMy7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 08:54:59 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:47014 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535Ab3COMy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 08:54:57 -0400
Date: Fri, 15 Mar 2013 08:55:10 -0400 (EDT)
Message-Id: <20130315.085510.974056254781971889.davem@davemloft.net>
To: florian@openwrt.org
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        jason@lakedaemon.net, andrew@lunn.ch, linux@arm.linux.org.uk,
        benh@kernel.crashing.org, paulus@samba.org, buytenh@wantstofly.org,
        thomas.petazzoni@free-electrons.com, gregkh@linuxfoundation.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/4] mv643xx_eth: use mvmdio MDIO bus driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130315.085321.1047694772636447477.davem@davemloft.net>
References: <1359473048-26551-1-git-send-email-florian@openwrt.org>
	<1363284515-9865-1-git-send-email-florian@openwrt.org>
	<20130315.085321.1047694772636447477.davem@davemloft.net>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Fri, 15 Mar 2013 05:55:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r2FCswqE004249

From: David Miller <davem@davemloft.net>
Date: Fri, 15 Mar 2013 08:53:21 -0400 (EDT)

> From: Florian Fainelli <florian@openwrt.org>
> Date: Thu, 14 Mar 2013 19:08:31 +0100
> 
>> This patch converts the mv643xx_eth driver to use the mvmdio MDIO bus driver
>> instead of rolling its own implementation. As a result, all users of this
>> mv643xx_eth driver are converted to register an "orion-mdio" platform_device.
>> The mvmdio driver is also updated to support an interrupt line which reports
>> SMI error/completion, and to allow traditionnal platform device registration
>> instead of just device tree.
>> 
>> David, I think it makes sense for you to merge all of this, since we do
>> not want the architecture files to be desynchronized from the mv643xx_eth to
>> avoid runtime breakage. The potential for merge conflicts should be very small.
> 
> All applied to net-next, thanks.

Actually, reverted.  Please send me code which actually compiles:

drivers/net/ethernet/marvell/mvmdio.c: In function ¡orion_mdio_wait_ready¢:
drivers/net/ethernet/marvell/mvmdio.c:70:28: error: ¡NO_IRQ¢ undeclared (first use in this function)
drivers/net/ethernet/marvell/mvmdio.c:70:28: note: each undeclared identifier is reported only once for each function it appears in
drivers/net/ethernet/marvell/mvmdio.c: In function ¡orion_mdio_probe¢:
drivers/net/ethernet/marvell/mvmdio.c:242:24: error: ¡NO_IRQ¢ undeclared (first use in this function)
make[4]: *** [drivers/net/ethernet/marvell/mvmdio.o] Error 1

And don't use Kconfig dependencies to work around this, fix it properly.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
