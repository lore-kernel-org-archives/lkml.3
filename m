Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932867Ab3CVNxn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 09:53:43 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:59422 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932116Ab3CVNxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 09:53:41 -0400
Date: Fri, 22 Mar 2013 14:53:37 +0100
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
Subject: Re: [PATCH 0/4 v3] mv643xx_eth: use mvmdio MDIO bus driver
Message-ID: <20130322145337.3814fcc8@skate>
In-Reply-To: <1363959568-16976-1-git-send-email-florian@openwrt.org>
References: <1363284515-9865-1-git-send-email-florian@openwrt.org>
	<1363959568-16976-1-git-send-email-florian@openwrt.org>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, 22 Mar 2013 14:39:24 +0100, Florian Fainelli wrote:
> Hi all,
> 
> This patch converts the mv643xx_eth driver to use the mvmdio MDIO bus driver
> instead of rolling its own implementation. As a result, all users of this
> mv643xx_eth driver are converted to register an "orion-mdio" platform_device.
> The mvmdio driver is also updated to support an interrupt line which reports
> SMI error/completion, and to allow traditionnal platform device registration
> instead of just device tree.
> 
> David, I think it makes sense for you to merge all of this, since we do
> not want the architecture files to be desynchronized from the mv643xx_eth to
> avoid runtime breakage. The potential for merge conflicts should be very small.
> 
> Florian Fainelli (4):
>   net: mvmdio: allow platform device style registration
>   net: mvmdio: rename base register cookie from smireg to regs
>   net: mvmdio: enhance driver to support SMI error/done interrupts
>   mv643xx_eth: convert to use the Marvell Orion MDIO driver

For the entire series:

Tested-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

tested on:

 * Armada XP DB, DT-based, which uses the mvneta driver. It is affected
   by the 3 first commits since Armada XP also uses the mvmdio driver.

 * Kirkwood development board, non-DT, which uses the mv643xx_eth
   driver.

Thanks Florian for this work,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
