Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab3HLSQH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 14:16:07 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:37413 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab3HLSQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 14:16:04 -0400
Message-ID: <52092662.6040507@cogentembedded.com>
Date: Mon, 12 Aug 2013 22:16:02 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Libo Chen <clbchenlibo.chen@huawei.com>
CC: pantelis.antoniou@gmail.com, vbordug@ru.mvista.com,
        David Miller <davem@davemloft.net>, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH 4/8] net: fs_enet: use platform_{get,set}_drvdata()
References: <5208E222.60300@huawei.com>
In-Reply-To: <5208E222.60300@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2013 05:24 PM, Libo Chen wrote:

> Use the wrapper functions for getting and setting the driver data using
> platform_device instead of using dev_{get,set}_drvdata() with &pdev->dev,
> so we can directly pass a struct platform_device.

> Signed-off-by: Libo Chen <libo.chen@huawei.com>
> ---
>   .../net/ethernet/freescale/fs_enet/fs_enet-main.c  |    1 -
>   1 files changed, 0 insertions(+), 1 deletions(-)

> diff --git a/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c b/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
> index 8de53a1..7e3de10 100644
> --- a/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
> +++ b/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
> @@ -1122,7 +1122,6 @@ static int fs_enet_remove(struct platform_device *ofdev)
>
>   	fep->ops->free_bd(ndev);
>   	fep->ops->cleanup_data(ndev);
> -	dev_set_drvdata(fep->dev, NULL);
>   	of_node_put(fep->fpi->phy_node);
>   	free_netdev(ndev);
>   	return 0;

    Changelog simply doesn't match the patch.

WBR, Sergei

