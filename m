Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818Ab3A2QqW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 11:46:22 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:35917 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489Ab3A2QqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 11:46:16 -0500
Date: Tue, 29 Jan 2013 17:46:09 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Florian Fainelli <florian@openwrt.org>
Cc: davem@davemloft.net, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org
Subject: Re: [PATCH 5/5] mv643xx_eth: convert to use the Marvell Orion MDIO
 driver
Message-ID: <20130129174609.6ff6fe03@skate>
In-Reply-To: <5107F88C.8030002@openwrt.org>
References: <1359473048-26551-1-git-send-email-florian@openwrt.org>
	<1359473048-26551-6-git-send-email-florian@openwrt.org>
	<20130129170131.7964a110@skate>
	<5107F88C.8030002@openwrt.org>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Florian Fainelli,

On Tue, 29 Jan 2013 17:27:56 +0100, Florian Fainelli wrote:

> It looks like I introduced two redundant mvmdio instances as ge01
> refers to the ge00 smi bus (the same applies to ge11 and ge10).
> Thanks for spotting this.

Ok, good.

> If you take a closer look at mv643xx_eth you will see that the
> "shared" driver still handles the mconf bus window configuration,
> which is not abstracted yet.

Indeed, I've seen that. But I don't understand why it's done in the
mv643xx_eth_shared_probe(). The mbus window configuration registers are
per-network interface, so this call to mv643xx_eth_conf_mbus_windows()
could presumably be done in mv643xx_eth_probe().

At least in mvneta, we have the same registers, and we do their
initialization in the driver normal (and only) ->probe() routine.

> Besides that, I would rather do it step by step.

Yes, agreed. But I think it would be good to have followed patches that
progressively get rid of the shared driver thing, as it will help in
bringing a proper DT binding in the mv643xx_eth driver. But it
certainly doesn't need to be part of this specific patch.

Thanks,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
