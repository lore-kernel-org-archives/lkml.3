Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233AbbANF1f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 00:27:35 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:39225 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbbANF1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 00:27:33 -0500
Date: Wed, 14 Jan 2015 00:27:30 -0500 (EST)
Message-Id: <20150114.002730.1449798194556067465.davem@davemloft.net>
To: stefan@agner.ch
Cc: shawn.guo@linaro.org, u.kleine-koenig@pengutronix.de,
        fugang.duan@freescale.com, fabio.estevam@freescale.com,
        mark.rutland@arm.com, robh+dt@kernel.org, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        B38611@freescale.com, LW@KARO-electronics.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH RESEND v2] net: fec: fix MDIO bus assignement for dual
 fec SoC's
From: David Miller <davem@davemloft.net>
In-Reply-To: <1421191221-23095-1-git-send-email-stefan@agner.ch>
References: <1421191221-23095-1-git-send-email-stefan@agner.ch>
X-Mailer: Mew version 6.6 on Emacs 24.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 13 Jan 2015 21:27:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Agner <stefan@agner.ch>
Date: Wed, 14 Jan 2015 00:20:21 +0100

> On i.MX28, the MDIO bus is shared between the two FEC instances.
> The driver makes sure that the second FEC uses the MDIO bus of the
> first FEC. This is done conditionally if FEC_QUIRK_ENET_MAC is set.
> However, in newer designs, such as Vybrid or i.MX6SX, each FEC MAC
> has its own MDIO bus. Simply removing the quirk FEC_QUIRK_ENET_MAC
> is not an option since other logic, triggered by this quirk, is
> still needed.
> 
> Furthermore, there are board designs which use the same MDIO bus
> for both PHY's even though the second bus would be available on the
> SoC side. Such layout are popular since it saves pins on SoC side.
> Due to the above quirk, those boards currently do work fine. The
> boards in the mainline tree with such a layout are:
> - Freescale Vybrid Tower with TWR-SER2 (vf610-twr.dts)
> - Freescale i.MX6 SoloX SDB Board (imx6sx-sdb.dts)
> 
> This patch adds a new quirk FEC_QUIRK_SINGLE_MDIO for i.MX28, which
> makes sure that the MDIO bus of the first FEC is used in any case.
> 
> However, the boards above do have a SoC with a MDIO bus for each FEC
> instance. But the PHY's are not connected in a 1:1 configuration. A
> proper device tree description is needed to allow the driver to
> figure out where to find its PHY. This patch fixes that shortcoming
> by adding a MDIO bus child node to the first FEC instance, along
> with the two PHY's on that bus, and making use of the phy-handle
> property to add a reference to the PHY's.
> 
> Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
> Signed-off-by: Stefan Agner <stefan@agner.ch>

Applied, thanks.
