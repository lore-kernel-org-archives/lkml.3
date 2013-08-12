Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab3HLSRv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 14:17:51 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:39142 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab3HLSRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 14:17:48 -0400
Message-ID: <520926CB.4020500@cogentembedded.com>
Date: Mon, 12 Aug 2013 22:17:47 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Libo Chen <clbchenlibo.chen@huawei.com>
CC: David Miller <davem@davemloft.net>, mugunthanvnm@ti.com,
        bigeasy@linutronix.de, prabhakar.csengg@gmail.com, b-liu@ti.com,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH 8/8] net: davinci_mdio: use platform_{get,set}_drvdata()
References: <5208E231.60104@huawei.com>
In-Reply-To: <5208E231.60104@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2013 05:25 PM, Libo Chen wrote:

> Use the wrapper functions for getting and setting the driver data using
> platform_device instead of using dev_{get,set}_drvdata() with &pdev->dev,
> so we can directly pass a struct platform_device.

> Signed-off-by: Libo Chen <libo.chen@huawei.com>
> ---
>   drivers/net/ethernet/ti/davinci_mdio.c |    4 +---
>   1 files changed, 1 insertions(+), 3 deletions(-)

> diff --git a/drivers/net/ethernet/ti/davinci_mdio.c b/drivers/net/ethernet/ti/davinci_mdio.c
> index 16ddfc3..2249b2c 100644
> --- a/drivers/net/ethernet/ti/davinci_mdio.c
> +++ b/drivers/net/ethernet/ti/davinci_mdio.c
[...]
> @@ -434,7 +433,6 @@ static int davinci_mdio_remove(struct platform_device *pdev)
>   	pm_runtime_put_sync(&pdev->dev);
>   	pm_runtime_disable(&pdev->dev);
>
> -	dev_set_drvdata(dev, NULL);

    Doesn't get described as well. I think you're mixing two types of changes 
in one patchset.

WBR, Sergei

