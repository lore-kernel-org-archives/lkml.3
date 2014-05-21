Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbaEUVzy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 17:55:54 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:52682 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857AbaEUVzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 17:55:52 -0400
Message-ID: <537D20EA.1000305@cogentembedded.com>
Date: Thu, 22 May 2014 01:55:54 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
CC: davem@davemloft.net, Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        Vitaly Bordug <vbordug@ru.mvista.com>, Li Yang <leoli@freescale.com>,
        Grant Likely <grant.likely@linaro.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Aida Mynzhasova <aida.mynzhasova@skitlab.ru>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@freescale.com>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:LINUX FOR POWERPC..." <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH RESEND net-next 4/9] net: systemport: use the new fixed
 PHY helpers
References: <1400708331-18088-1-git-send-email-f.fainelli@gmail.com> <1400708331-18088-5-git-send-email-f.fainelli@gmail.com>
In-Reply-To: <1400708331-18088-5-git-send-email-f.fainelli@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2014 01:38 AM, Florian Fainelli wrote:

> of_phy_connect_fixed_link() is becoming obsolete, and also required
> platform code to register the fixed PHYs at the specified addresses for
> those to be usable. Get rid of it and use the new of_phy_is_fixed_link()
> plus of_phy_register_fixed_link() helpers to transition over the new
> scheme.

> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>   drivers/net/ethernet/broadcom/bcmsysport.c | 17 +++++++++++++++--
>   drivers/net/ethernet/broadcom/bcmsysport.h |  1 +
>   2 files changed, 16 insertions(+), 2 deletions(-)

> diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
> index d40c5b969e9e..dc708a888f80 100644
> --- a/drivers/net/ethernet/broadcom/bcmsysport.c
> +++ b/drivers/net/ethernet/broadcom/bcmsysport.c
> @@ -1327,8 +1327,8 @@ static int bcm_sysport_open(struct net_device *dev)
>   	/* Read CRC forward */
>   	priv->crc_fwd = !!(umac_readl(priv, UMAC_CMD) & CMD_CRC_FWD);
>
> -	priv->phydev = of_phy_connect_fixed_link(dev, bcm_sysport_adj_link,
> -							priv->phy_interface);
> +	priv->phydev = of_phy_connect(dev, priv->phy_dn, bcm_sysport_adj_link,
> +					0, priv->phy_interface);

    The continuation line should start on the next character after ( on the 
above line, according to the networking coding style.

[...]

WBR, Sergei

