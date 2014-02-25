Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490AbaBYJ01 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 04:26:27 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:51606 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbaBYJ0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 04:26:24 -0500
Message-ID: <530C619C.9050303@ti.com>
Date: Tue, 25 Feb 2014 11:25:48 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: <tony@atomide.com>, <bcousson@baylibre.com>, <balbi@ti.com>, <nm@ti.com>,
        <khilman@linaro.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH v8 03/14] mfd: omap-usb-host: Use clock names as per function
 for reference clocks
References: <1392896409-5101-1-git-send-email-rogerq@ti.com> <1392896409-5101-4-git-send-email-rogerq@ti.com> <20140225085234.GB19099@lee--X1> <530C5C29.1090503@ti.com> <20140225091839.GE19099@lee--X1>
In-Reply-To: <20140225091839.GE19099@lee--X1>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2014 11:18 AM, Lee Jones wrote:
>>>> Use a meaningful name for the reference clocks so that it indicates the function.
>>>>
>>>> CC: Lee Jones <lee.jones@linaro.org>
>>>> CC: Samuel Ortiz <sameo@linux.intel.com>
>>>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>>>> ---
>>>>  drivers/mfd/omap-usb-host.c | 12 ++++++------
>>>>  1 file changed, 6 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
>>>> index 865c276..651e249 100644
>>>> --- a/drivers/mfd/omap-usb-host.c
>>>> +++ b/drivers/mfd/omap-usb-host.c
>>>> @@ -718,24 +718,24 @@ static int usbhs_omap_probe(struct platform_device *pdev)
>>>>  		goto err_mem;
>>>>  	}
>>>>  
>>>> -	omap->xclk60mhsp1_ck = devm_clk_get(dev, "xclk60mhsp1_ck");
>>>> +	omap->xclk60mhsp1_ck = devm_clk_get(dev, "refclk_60m_ext_p1");
>>>>  	if (IS_ERR(omap->xclk60mhsp1_ck)) {
>>>>  		ret = PTR_ERR(omap->xclk60mhsp1_ck);
>>>> -		dev_err(dev, "xclk60mhsp1_ck failed error:%d\n", ret);
>>>> +		dev_err(dev, "refclk_60m_ext_p1 failed error:%d\n", ret);
>>>>  		goto err_mem;
>>>>  	}
>>>
>>> Will anything break if I were to apply the MFD patches seperately?
>>>
>>
>> Nothing will break for OMAP3, but OMAP4 USB host will break (e.g. Panda board).
>> OMAP5 USB host was never working so it doesn't matter there.
>>
>> To make sure nothing breaks, we need at least these 2 patches to go in together with mfd changes.
>>
>> [PATCH v8 08/14] ARM: dts: omap4: Update omap-usb-host node
>> [PATCH v8 09/14] ARM: dts: omap5: Update omap-usb-host node
>>
>> Any suggestions about how we can proceed?
> 
> Yes, unfortunately you have to squash each of the patches into one
> patch. Applying a patch which breaks a build, then applying another one
> immediately after which subsequently fixes the break is not an acceptable
> way of working I'm afraid. What would happen if we were to fall into
> the middle of the two patches when bisecting?
> 

OK, I'll squash patches 8 and 9 into patch 3.

cheers,
-roger
