Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751301Ab3HSS4w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 14:56:52 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:54789 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab3HSS4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 14:56:50 -0400
Message-ID: <52126A71.5050306@cogentembedded.com>
Date: Mon, 19 Aug 2013 22:56:49 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: ujhelyi.m@gmail.com
CC: davem@davemloft.net, mugunthanvnm@ti.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: cpsw: Add support for wake-on-lan for cpsw
References: <1376907191-25491-1-git-send-email-ujhelyi.m@gmail.com>
In-Reply-To: <1376907191-25491-1-git-send-email-ujhelyi.m@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 08/19/2013 02:13 PM, ujhelyi.m@gmail.com wrote:

> From: Matus Ujhelyi <ujhelyi.m@gmail.com>

> Signed-off-by: Matus Ujhelyi <ujhelyi.m@gmail.com>
> ---
>   drivers/net/ethernet/ti/cpsw.c |   25 +++++++++++++++++++++++++
>   1 file changed, 25 insertions(+)

> diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
> index 22a7a43..f59302e 100644
> --- a/drivers/net/ethernet/ti/cpsw.c
> +++ b/drivers/net/ethernet/ti/cpsw.c
> @@ -1416,6 +1416,29 @@ static int cpsw_set_settings(struct net_device *ndev, struct ethtool_cmd *ecmd)
>   		return -EOPNOTSUPP;
>   }
>
> +static void
> +cpsw_get_wol(struct net_device *ndev, struct ethtool_wolinfo *wol)
> +{
> +	struct cpsw_priv *priv = netdev_priv(ndev);
> +	int slave_no = cpsw_slave_index(priv);

    Empty line wouldn't hurt here, after declaration.

> +	wol->supported = 0;
> +	wol->wolopts = 0;
> +	if (priv->slaves[slave_no].phy)
> +		phy_ethtool_get_wol(priv->slaves[slave_no].phy, wol);
> +
> +}
> +
> +static int
> +cpsw_set_wol(struct net_device *ndev, struct ethtool_wolinfo *wol)
> +{
> +	struct cpsw_priv *priv = netdev_priv(ndev);
> +	int slave_no = cpsw_slave_index(priv);

    Here too...

> +	if (priv->slaves[slave_no].phy)
> +		return phy_ethtool_set_wol(priv->slaves[slave_no].phy, wol);
> +	else
> +		return -EOPNOTSUPP;
> +}
> +
>   static const struct ethtool_ops cpsw_ethtool_ops = {
>   	.get_drvinfo	= cpsw_get_drvinfo,
>   	.get_msglevel	= cpsw_get_msglevel,

WBR, Sergei

