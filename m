Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155Ab3KEJFE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 04:05:04 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:56148 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab3KEJEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 04:04:54 -0500
Message-ID: <5278B4AE.3050100@gmail.com>
Date: Tue, 05 Nov 2013 10:04:46 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: David Miller <davem@davemloft.net>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: mv643xx_eth: Add missing phy_addr_set in DT mode
References: <1383611239-14556-1-git-send-email-jgunthorpe@obsidianresearch.com>
In-Reply-To: <1383611239-14556-1-git-send-email-jgunthorpe@obsidianresearch.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2013 01:27 AM, Jason Gunthorpe wrote:
> Commit cc9d4598 'net: mv643xx_eth: use of_phy_connect if phy_node
> present' made the call to phy_scan optional, if the DT has a link to
> the phy node.
>
> However phy_scan has the side effect of calling phy_addr_set, which
> writes the phy MDIO address to the ethernet controller. If phy_addr_set
> is not called, and the bootloader has not set the correct address then
> the driver will fail to function.
>
> Tested on Kirkwood.
>
> Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> ---

Jason,

thanks for catching this! I do my kirkwood testing on Dockstar,
which has PHY addr 0x0 - also the reset default, which may be
why it slipped through.

Acked-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

> ---
>   drivers/net/ethernet/marvell/mv643xx_eth.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
> index 2c210ec..00e43b5 100644
> --- a/drivers/net/ethernet/marvell/mv643xx_eth.c
> +++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
> @@ -2890,6 +2890,7 @@ static int mv643xx_eth_probe(struct platform_device *pdev)
>   					 PHY_INTERFACE_MODE_GMII);
>   		if (!mp->phy)
>   			err = -ENODEV;
> +		phy_addr_set(mp, mp->phy->addr);
>   	} else if (pd->phy_addr != MV643XX_ETH_PHY_NONE) {
>   		mp->phy = phy_scan(mp, pd->phy_addr);
>
>

