Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149AbaGCICS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 04:02:18 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:54978 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755598AbaGCICP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 04:02:15 -0400
Message-ID: <53B50E02.9070809@ti.com>
Date: Thu, 3 Jul 2014 11:02:10 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>, <tony@atomide.com>,
        <kishon@ti.com>, <balbi@ti.com>
CC: <nsekhar@ti.com>, <nm@ti.com>, <george.cherian@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/6] phy: core: Support regulator supply for PHY power
References: <1404302638-3003-1-git-send-email-rogerq@ti.com> <1404302638-3003-4-git-send-email-rogerq@ti.com> <53B3FBD2.3090003@cogentembedded.com>
In-Reply-To: <53B3FBD2.3090003@cogentembedded.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2014 03:32 PM, Sergei Shtylyov wrote:
> Hello.
> 
> On 07/02/2014 04:03 PM, Roger Quadros wrote:
> 
>> Some PHYs can be powered by an external power regulator.
>> e.g. USB_HS PHY on DRA7 SoC. Make the PHY core support a
>> power regulator.
> 
>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>> ---
>>   drivers/phy/phy-core.c  | 32 ++++++++++++++++++++++++++++++++
>>   include/linux/phy/phy.h |  2 ++
>>   2 files changed, 34 insertions(+)
> 
>> diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
>> index 49c4465..d817107 100644
>> --- a/drivers/phy/phy-core.c
>> +++ b/drivers/phy/phy-core.c
> [...]
>> @@ -664,6 +689,10 @@ EXPORT_SYMBOL_GPL(devm_phy_create);
>>   void phy_destroy(struct phy *phy)
>>   {
>>       pm_runtime_disable(&phy->dev);
>> +
>> +    if (phy->pwr)
>> +        regulator_put(phy->pwr);
> 
>    regulator_put() already handles NULL pointer.

Good to know that. I'll remove the 'if' then.

cheers,
-roger

> 
>> +
>>       device_unregister(&phy->dev);
>>   }
>>   EXPORT_SYMBOL_GPL(phy_destroy);
>> @@ -800,6 +829,9 @@ static void phy_release(struct device *dev)
>>
>>       phy = to_phy(dev);
>>       dev_vdbg(dev, "releasing '%s'\n", dev_name(dev));
>> +    if (phy->pwr)
>> +        regulator_put(phy->pwr);
> 
>    Same comment here.
> 
>> +
>>       ida_simple_remove(&phy_ida, phy->id);
>>       kfree(phy);
>>   }
> 
> WBR, Sergei
> 

