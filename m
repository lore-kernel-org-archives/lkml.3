Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab3LPNDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 08:03:18 -0500
Received: from mxout7.netvision.net.il ([194.90.6.2]:62331 "EHLO
	mxout7.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097Ab3LPNDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 08:03:17 -0500
X-Greylist: delayed 900 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Dec 2013 08:03:17 EST
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII; format=flowed
Message-id: <52AEF670.6060108@gmail.com>
Date: Mon, 16 Dec 2013 14:47:44 +0200
From: Eli Billauer <eli.billauer@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12)
 Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Wei Yongjun'" <weiyj.lk@gmail.com>, gregkh@linuxfoundation.org,
        yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] staging: xillybus: fix error return code in
 xilly_probe()
References: <CAPgLHd_jJ-gR0CWZKuWUVALXhE9c9a3b+-GspKE_AXKvFW6qPQ@mail.gmail.com>
 <000601cefa46$780f81e0$682e85a0$%han@samsung.com>
In-reply-to: <000601cefa46$780f81e0$682e85a0$%han@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for reporting this bug. The same bug exists in the driver for OF 
(xillybus_of.c).

As for the choice of -EIO, I've surveyed several drivers calling 
of_iomap() and pci_iomap(), and it turns out that some fail on -ENOMEM, 
some on -EIO and some on -EBUSY.

Personally, I'm inclined towards -ENOMEM, since the problem is a memory 
mapping failure.

I'll submit a patch fixing both files soon.

Thanks again,
    Eli

On 16/12/13 12:06, Jingoo Han wrote:
> On Monday, December 16, 2013 2:51 PM, Wei Yongjun wrote:
>    
>> From: Wei Yongjun<yongjun_wei@trendmicro.com.cn>
>>
>> Fix to return negative error code -EIO from the error handling
>> case instead of 0.
>>
>> Signed-off-by: Wei Yongjun<yongjun_wei@trendmicro.com.cn>
>> ---
>>   drivers/staging/xillybus/xillybus_pcie.c | 2 +-
>>      
> It looks good.
> Reviewed-by: Jingoo Han<jg1.han@samsung.com>
>
> Best regards,
> Jingoo Han
>
>    
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/staging/xillybus/xillybus_pcie.c b/drivers/staging/xillybus/xillybus_pcie.c
>> index 0564f97..51426d8 100644
>> --- a/drivers/staging/xillybus/xillybus_pcie.c
>> +++ b/drivers/staging/xillybus/xillybus_pcie.c
>> @@ -168,9 +168,9 @@ static int xilly_probe(struct pci_dev *pdev,
>>   	}
>>
>>   	endpoint->registers = pci_iomap(pdev, 0, 128);
>> -
>>   	if (!endpoint->registers) {
>>   		dev_err(endpoint->dev, "Failed to map BAR 0. Aborting.\n");
>> +		rc = -EIO;
>>   		goto failed_iomap0;
>>   	}
>>
>>      
>    


