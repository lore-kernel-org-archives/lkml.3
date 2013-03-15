Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab3COLmR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 07:42:17 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:53907 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863Ab3COLmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 07:42:15 -0400
Date: Fri, 15 Mar 2013 12:42:10 +0100
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
Subject: Re: [PATCH 4/4 v2] mv643xx_eth: convert to use the Marvell Orion
 MDIO driver
Message-ID: <20130315124210.27d0794a@skate>
In-Reply-To: <514300E0.2030108@openwrt.org>
References: <1359473048-26551-1-git-send-email-florian@openwrt.org>
	<1363284515-9865-1-git-send-email-florian@openwrt.org>
	<1363284515-9865-5-git-send-email-florian@openwrt.org>
	<514300E0.2030108@openwrt.org>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Florian Fainelli,

On Fri, 15 Mar 2013 12:07:12 +0100, Florian Fainelli wrote:

> Thanks to the help of Andrew Lunn, there is at least two known issues 
> with this patch version:
> 
> - we need to move up the mvmdio line in 
> drivers/net/ethernet/marvell/Makefile to make sure that configs having 
> both mvmdio and mv643xx_eth built-in get the probing order right

I don't think it's the right way of fixing the problem. If there is no
dependency on the two devices through the device model (i.e they don't
have a parent->child relationship), then the mv643xx_eth driver should
probably return -EPROBE_DEFER when it can't find its PHY so that its
->probe() operation gets called once again by the kernel when other
drivers (including mvmdio) have been probed.

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
