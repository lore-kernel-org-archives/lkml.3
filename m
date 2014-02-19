Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751236AbaBSFhY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 00:37:24 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:58383 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbaBSFhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 00:37:23 -0500
Message-ID: <5304430F.8000607@ti.com>
Date: Wed, 19 Feb 2014 11:07:19 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/8] usb: phy: bcm-kona-usb2: Use PTR_ERR_OR_ZERO
References: <1392627565-1829-1-git-send-email-kishon@ti.com> <1392627565-1829-4-git-send-email-kishon@ti.com> <20140218201153.GC21119@kroah.com>
In-Reply-To: <20140218201153.GC21119@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 February 2014 01:41 AM, Greg KH wrote:
> On Mon, Feb 17, 2014 at 02:29:20PM +0530, Kishon Vijay Abraham I wrote:
>> From: Sachin Kamat <sachin.kamat@linaro.org>
>>
>> PTR_ERR_OR_ZERO simplifies the code.
>>
>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>> Cc: Matt Porter <mporter@linaro.org>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>> ---
>>  drivers/phy/phy-bcm-kona-usb2.c |    4 +---
>>  1 file changed, 1 insertion(+), 3 deletions(-)
>>
>> diff --git a/drivers/phy/phy-bcm-kona-usb2.c b/drivers/phy/phy-bcm-kona-usb2.c
>> index efc5c1a..e94f5a6 100644
>> --- a/drivers/phy/phy-bcm-kona-usb2.c
>> +++ b/drivers/phy/phy-bcm-kona-usb2.c
>> @@ -128,10 +128,8 @@ static int bcm_kona_usb2_probe(struct platform_device *pdev)
>>  
>>  	phy_provider = devm_of_phy_provider_register(dev,
>>  			of_phy_simple_xlate);
>> -	if (IS_ERR(phy_provider))
>> -		return PTR_ERR(phy_provider);
>>  
>> -	return 0;
>> +	return PTR_ERR_OR_ZERO(phy_provider);
>>  }
> 
> Another patch here that isn't a bugfix, sorry, it's not for 3.14-final.

Ok. I'll have these patches for the next merge window.

Thanks
Kishon
> 

