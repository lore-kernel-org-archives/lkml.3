Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab3EVGiU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 02:38:20 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:19034 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174Ab3EVGiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 02:38:17 -0400
Message-ID: <519C673F.1090705@huawei.com>
Date: Wed, 22 May 2013 14:35:43 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: <vinod.koul@intel.com>, <grant.likely@linaro.org>,
        <rob.herring@calxeda.com>, Andrew Morton <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        Libo Chen <libo.chen@huawei.com>, <agust@denx.de>, <phdm@macqel.be>,
        Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH] bestcomm: no need to free when kzalloc fail
References: <1367743104-3448-1-git-send-email-libo.chen@huawei.com>  <519C4E4D.1060101@huawei.com> <1369202788.3870.3.camel@pasglop>
In-Reply-To: <1369202788.3870.3.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/5/22 14:06, Benjamin Herrenschmidt wrote:
> On Wed, 2013-05-22 at 12:49 +0800, Libo Chen wrote:
>> ping...
> 
> This is pointless. We routinely avoid adding such crap by having
> the various free(...) routines cope with NULL. You just need to make
> sure you are indeed NULL in the error case.
> 
> Ben.

thanks,

Libo

> 
>> On 2013/5/5 16:38, chenlibo.3@gmail.com wrote:
>>> From: Libo Chen <libo.chen@huawei.com>
>>>
>>> There is no need to free bcom_eng if kzalloc fail
>>>
>>> Signed-off-by: Libo Chen <libo.chen@huawei.com>
>>> ---
>>>  drivers/dma/bestcomm/bestcomm.c | 3 ++-
>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/dma/bestcomm/bestcomm.c b/drivers/dma/bestcomm/bestcomm.c
>>> index a8c2e29..300ee2d 100644
>>> --- a/drivers/dma/bestcomm/bestcomm.c
>>> +++ b/drivers/dma/bestcomm/bestcomm.c
>>> @@ -400,7 +400,7 @@ static int mpc52xx_bcom_probe(struct platform_device *op)
>>>  		printk(KERN_ERR DRIVER_NAME ": "
>>>  			"Can't allocate state structure\n");
>>>  		rv = -ENOMEM;
>>> -		goto error_sramclean;
>>> +		goto error_kzalloc;
>>>  	}
>>>  
>>>  	/* Save the node */
>>> @@ -449,6 +449,7 @@ error_release:
>>>  	release_mem_region(res_bcom.start, sizeof(struct mpc52xx_sdma));
>>>  error_sramclean:
>>>  	kfree(bcom_eng);
>>> +error_kzalloc:
>>>  	bcom_sram_cleanup();
>>>  error_ofput:
>>>  	of_node_put(op->dev.of_node);
>>>
>>
> 
> 
> 
> .
> 


