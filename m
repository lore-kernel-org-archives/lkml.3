Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058AbaBRP3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 10:29:20 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:40901 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755606AbaBRP3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 10:29:17 -0500
Message-ID: <53037C2B.6070701@ti.com>
Date: Tue, 18 Feb 2014 17:28:43 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: <tony@atomide.com>, <bcousson@baylibre.com>, <balbi@ti.com>, <nm@ti.com>,
        <khilman@linaro.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH v7 03/12] mfd: omap-usb-host: Use clock names as per function
 for reference clocks
References: <1392200333-28397-1-git-send-email-rogerq@ti.com> <1392200333-28397-4-git-send-email-rogerq@ti.com> <20140214100915.GD7380@lee--X1> <52FE164F.80503@ti.com> <20140214133330.GC13293@lee--X1>
In-Reply-To: <20140214133330.GC13293@lee--X1>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2014 03:33 PM, Lee Jones wrote:
>>>> Use a meaningful name for the reference clocks so that it indicates the function.
>>>>
>>>> CC: Lee Jones <lee.jones@linaro.org>
>>>> CC: Samuel Ortiz <sameo@linux.intel.com>
>>>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>>>> ---
>>>>  drivers/mfd/omap-usb-host.c | 6 +++---
>>>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
>>>> index 60a3bed..ce620a8 100644
>>>> --- a/drivers/mfd/omap-usb-host.c
>>>> +++ b/drivers/mfd/omap-usb-host.c
>>>> @@ -714,21 +714,21 @@ static int usbhs_omap_probe(struct platform_device *pdev)
>>>>  		goto err_mem;
>>>>  	}
>>>>  
>>>> -	omap->xclk60mhsp1_ck = devm_clk_get(dev, "xclk60mhsp1_ck");
>>>> +	omap->xclk60mhsp1_ck = devm_clk_get(dev, "refclk_60m_ext_p1");
>>>
>>> You can't do that. These changes will have to be in the same patch as
>>> the core change i.e. where they are initialised.
>>
>> I'm not touching them anywhere in this series. When core changes are you
>> referring to?
> 
> The ones in:
>   arch/arm/mach-omap2/cclock3xxx_data.c

OK, right. They are now no longer needed so I'll get rid of them.
In fact that change should either be in a separate patch or combined with PATCH 2
in this series. What do you suggest?

cheers,
-roger
> 
>>>>  	if (IS_ERR(omap->xclk60mhsp1_ck)) {
>>>>  		ret = PTR_ERR(omap->xclk60mhsp1_ck);
>>>>  		dev_err(dev, "xclk60mhsp1_ck failed error:%d\n", ret);
>>>>  		goto err_mem;
>>>>  	}
>>>>  
>>>> -	omap->xclk60mhsp2_ck = devm_clk_get(dev, "xclk60mhsp2_ck");
>>>> +	omap->xclk60mhsp2_ck = devm_clk_get(dev, "refclk_60m_ext_p2");
>>>>  	if (IS_ERR(omap->xclk60mhsp2_ck)) {
>>>>  		ret = PTR_ERR(omap->xclk60mhsp2_ck);
>>>>  		dev_err(dev, "xclk60mhsp2_ck failed error:%d\n", ret);
>>>>  		goto err_mem;
>>>>  	}
>>>>  
>>>> -	omap->init_60m_fclk = devm_clk_get(dev, "init_60m_fclk");
>>>> +	omap->init_60m_fclk = devm_clk_get(dev, "refclk_60m_int");
>>>>  	if (IS_ERR(omap->init_60m_fclk)) {
>>>>  		ret = PTR_ERR(omap->init_60m_fclk);
>>>>  		dev_err(dev, "init_60m_fclk failed error:%d\n", ret);
>>>
>>
> 

