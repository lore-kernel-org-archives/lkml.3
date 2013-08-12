Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab3HLSKn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 14:10:43 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:56687 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357Ab3HLSKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 14:10:40 -0400
Message-ID: <5209251D.80902@cogentembedded.com>
Date: Mon, 12 Aug 2013 22:10:37 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Libo Chen <clbchenlibo.chen@huawei.com>
CC: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>,
        timur@freescale.com
Subject: Re: [PATCH 1/8] net: fsl_pq_mdio: use platform_{get,set}_drvdata()
References: <5208E215.6030007@huawei.com>
In-Reply-To: <5208E215.6030007@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 08/12/2013 05:24 PM, Libo Chen wrote:

> Use the wrapper functions for getting and setting the driver data using
> platform_device instead of using dev_{get,set}_drvdata() with &pdev->dev,
> so we can directly pass a struct platform_device.

> Signed-off-by: Libo Chen <libo.chen@huawei.com>
> ---
>   drivers/net/ethernet/freescale/fsl_pq_mdio.c |    3 +--
>   1 files changed, 1 insertions(+), 2 deletions(-)

> diff --git a/drivers/net/ethernet/freescale/fsl_pq_mdio.c b/drivers/net/ethernet/freescale/fsl_pq_mdio.c
> index c93a056..995a3ab 100644
> --- a/drivers/net/ethernet/freescale/fsl_pq_mdio.c
> +++ b/drivers/net/ethernet/freescale/fsl_pq_mdio.c
[...]
> @@ -468,7 +468,6 @@ static int fsl_pq_mdio_remove(struct platform_device *pdev)
>
>   	mdiobus_unregister(bus);
>
> -	dev_set_drvdata(device, NULL);

    You don't mention this in the changelog.

WBR, Sergei
