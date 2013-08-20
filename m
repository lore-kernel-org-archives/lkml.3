Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161Ab3HTFwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 01:52:19 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:41055 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873Ab3HTFwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 01:52:16 -0400
Message-ID: <5213040B.8060406@ti.com>
Date: Tue, 20 Aug 2013 11:22:11 +0530
From: Mugunthan V N <mugunthanvnm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: <ujhelyi.m@gmail.com>
CC: <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v3] net: cpsw: Add support for wake-on-lan for
 cpsw
References: <1376977097-25296-1-git-send-email-ujhelyi.m@gmail.com>
In-Reply-To: <1376977097-25296-1-git-send-email-ujhelyi.m@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 August 2013 11:08 AM, ujhelyi.m@gmail.com wrote:
> From: Matus Ujhelyi <ujhelyi.m@gmail.com>
>
> Some phy's can be configured to enable wake on lan (e.g. at803x or marvell 88E1318S).
> There is no way how to enable wol on CPSW with such connected phys. This patch
> adds this support. It is provided by calling the phy's related code.
>
> Tested on board with at8030x connected phy. Wol interrupt line is
> connected to GPIO0 on am335x.
>
> Signed-off-by: Matus Ujhelyi <ujhelyi.m@gmail.com>
> ---
>  drivers/net/ethernet/ti/cpsw.c |   24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
>
> diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
> index 0fcf212..5d673bf 100644
> --- a/drivers/net/ethernet/ti/cpsw.c
> +++ b/drivers/net/ethernet/ti/cpsw.c
> @@ -1640,6 +1640,28 @@ static int cpsw_set_settings(struct net_device *ndev, struct ethtool_cmd *ecmd)
>  		return -EOPNOTSUPP;
>  }
>  
> +static void cpsw_get_wol(struct net_device *ndev, struct ethtool_wolinfo *wol)
> +{
> +	struct cpsw_priv *priv = netdev_priv(ndev);
> +	int slave_no = cpsw_slave_index(priv);
> +	wol->supported = 0;
> +	wol->wolopts = 0;

Please add a blank line after variable declaration before you start
updating wol structure as commented by Francois and Sergei.

Regards
Mugunthan V N
