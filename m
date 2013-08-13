Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566Ab3HMBXm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 21:23:42 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:8352 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756266Ab3HMBXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 21:23:41 -0400
Message-ID: <52098A87.3090703@huawei.com>
Date: Tue, 13 Aug 2013 09:23:19 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: David Miller <davem@davemloft.net>, <mugunthanvnm@ti.com>,
        <bigeasy@linutronix.de>, <prabhakar.csengg@gmail.com>, <b-liu@ti.com>,
        <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH 8/8] net: davinci_mdio: use platform_{get,set}_drvdata()
References: <5208E231.60104@huawei.com> <520926CB.4020500@cogentembedded.com>
In-Reply-To: <520926CB.4020500@cogentembedded.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/8/13 2:17, Sergei Shtylyov wrote:
> On 08/12/2013 05:25 PM, Libo Chen wrote:
> 
>> Use the wrapper functions for getting and setting the driver data using
>> platform_device instead of using dev_{get,set}_drvdata() with &pdev->dev,
>> so we can directly pass a struct platform_device.
> 
>> Signed-off-by: Libo Chen <libo.chen@huawei.com>
>> ---
>>   drivers/net/ethernet/ti/davinci_mdio.c |    4 +---
>>   1 files changed, 1 insertions(+), 3 deletions(-)
> 
>> diff --git a/drivers/net/ethernet/ti/davinci_mdio.c b/drivers/net/ethernet/ti/davinci_mdio.c
>> index 16ddfc3..2249b2c 100644
>> --- a/drivers/net/ethernet/ti/davinci_mdio.c
>> +++ b/drivers/net/ethernet/ti/davinci_mdio.c
> [...]
>> @@ -434,7 +433,6 @@ static int davinci_mdio_remove(struct platform_device *pdev)
>>       pm_runtime_put_sync(&pdev->dev);
>>       pm_runtime_disable(&pdev->dev);
>>
>> -    dev_set_drvdata(dev, NULL);
> 
>    Doesn't get described as well. I think you're mixing two types of changes in one patchset.
> 
> WBR, Sergei
> 

thanks for your attention!


Libo

> 
> 


