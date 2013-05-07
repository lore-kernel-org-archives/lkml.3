Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759624Ab3EGRzu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 13:55:50 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:33601 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225Ab3EGRzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 13:55:47 -0400
Message-ID: <51894021.1070900@cogentembedded.com>
Date: Tue, 07 May 2013 21:55:45 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        David Miller <davem@davemloft.net>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: of_mdio: fix behavior on missing phy device
References: <1367920171-20264-1-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1367920171-20264-1-git-send-email-sebastian.hesselbarth@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 07-05-2013 13:49, Sebastian Hesselbarth wrote:

> of_mdiobus_register creates a phy_device even if get_phy_device failed
> to create it previously. This causes indefinite polling on non-existent
> PHYs. This fix makes of_mdio_register rely on get_phy_device to
> properly create the device or fail otherwise.

> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: David Miller <davem@davemloft.net>
> Cc: devicetree-discuss@lists.ozlabs.org
> Cc: linux-kernel@vger.kernel.org
> Cc: netdev@vger.kernel.org
> ---
>   drivers/of/of_mdio.c |   11 ++++-------
>   1 file changed, 4 insertions(+), 7 deletions(-)

> diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
> index 23049ae..d5a57a9 100644
> --- a/drivers/of/of_mdio.c
> +++ b/drivers/of/of_mdio.c
> @@ -84,13 +84,10 @@ int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
>   		phy = get_phy_device(mdio, addr, is_c45);
>

    This empty line is not needed -- would be good to drop it, while at 
this.

>   		if (!phy || IS_ERR(phy)) {
> -			phy = phy_device_create(mdio, addr, 0, false, NULL);
> -			if (!phy || IS_ERR(phy)) {
> -				dev_err(&mdio->dev,
> -					"error creating PHY at address %i\n",
> -					addr);
> -				continue;
> -			}
> +			dev_err(&mdio->dev,
> +				"cannot get PHY at address %i\n",
> +				addr);
> +			continue;
>   		}
>
>   		/* Associate the OF node with the device structure so it
>

