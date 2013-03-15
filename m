Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab3COM4s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 08:56:48 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:34734 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754268Ab3COM4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 08:56:46 -0400
Message-ID: <514319B6.7030307@openwrt.org>
Date: Fri, 15 Mar 2013 13:53:10 +0100
From: Florian Fainelli <florian@openwrt.org>
Organization: OpenWrt
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        jason@lakedaemon.net, andrew@lunn.ch, linux@arm.linux.org.uk,
        benh@kernel.crashing.org, paulus@samba.org, buytenh@wantstofly.org,
        thomas.petazzoni@free-electrons.com, gregkh@linuxfoundation.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/4] mv643xx_eth: use mvmdio MDIO bus driver
References: <1359473048-26551-1-git-send-email-florian@openwrt.org> <1363284515-9865-1-git-send-email-florian@openwrt.org> <20130315.085321.1047694772636447477.davem@davemloft.net> <20130315.085510.974056254781971889.davem@davemloft.net>
In-Reply-To: <20130315.085510.974056254781971889.davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 03/15/13 13:55, David Miller a écrit :
> From: David Miller <davem@davemloft.net>
> Date: Fri, 15 Mar 2013 08:53:21 -0400 (EDT)
>
>> From: Florian Fainelli <florian@openwrt.org>
>> Date: Thu, 14 Mar 2013 19:08:31 +0100
>>
>>> This patch converts the mv643xx_eth driver to use the mvmdio MDIO bus driver
>>> instead of rolling its own implementation. As a result, all users of this
>>> mv643xx_eth driver are converted to register an "orion-mdio" platform_device.
>>> The mvmdio driver is also updated to support an interrupt line which reports
>>> SMI error/completion, and to allow traditionnal platform device registration
>>> instead of just device tree.
>>>
>>> David, I think it makes sense for you to merge all of this, since we do
>>> not want the architecture files to be desynchronized from the mv643xx_eth to
>>> avoid runtime breakage. The potential for merge conflicts should be very small.
>>
>> All applied to net-next, thanks.
>
> Actually, reverted.  Please send me code which actually compiles:
>
> drivers/net/ethernet/marvell/mvmdio.c: In function ‘orion_mdio_wait_ready’:
> drivers/net/ethernet/marvell/mvmdio.c:70:28: error: ‘NO_IRQ’ undeclared (first use in this function)
> drivers/net/ethernet/marvell/mvmdio.c:70:28: note: each undeclared identifier is reported only once for each function it appears in
> drivers/net/ethernet/marvell/mvmdio.c: In function ‘orion_mdio_probe’:
> drivers/net/ethernet/marvell/mvmdio.c:242:24: error: ‘NO_IRQ’ undeclared (first use in this function)
> make[4]: *** [drivers/net/ethernet/marvell/mvmdio.o] Error 1
>
> And don't use Kconfig dependencies to work around this, fix it properly.

Is there any platform out there for which we do not have a NO_IRQ 
definition by now? If so, what is it?
--
Florian
