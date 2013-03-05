Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092Ab3CEPCP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 10:02:15 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:55594 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756051Ab3CEPCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 10:02:12 -0500
Message-ID: <513608E6.3010502@ti.com>
Date: Tue, 5 Mar 2013 20:31:58 +0530
From: kishon <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <gregkh@linuxfoundation.org>, <s-guiriec@ti.com>, <gg@slimlogic.co.uk>,
        <sameo@linux.intel.com>, <broonie@opensource.wolfsonmicro.com>,
        <ldewangan@nvidia.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 2/4] usb: dwc3: dwc3-omap: return -EPROBE_DEFER if probe
 has not yet executed
References: <1362493320-13913-1-git-send-email-kishon@ti.com> <1362493320-13913-3-git-send-email-kishon@ti.com> <20130305145645.GG12123@arwen.pp.htv.fi>
In-Reply-To: <20130305145645.GG12123@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 05 March 2013 08:26 PM, Felipe Balbi wrote:
> On Tue, Mar 05, 2013 at 07:51:58PM +0530, Kishon Vijay Abraham I wrote:
>> return -EPROBE_DEFER from dwc3_omap_mailbox in dwc3-omap.c, if the probe of
>> dwc3-omap has not yet been executed or failed.
>>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>> ---
>>   drivers/usb/dwc3/dwc3-omap.c  |    7 +++++--
>>   include/linux/usb/dwc3-omap.h |    6 +++---
>>   2 files changed, 8 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
>> index 19c6e72..9428f4e 100644
>> --- a/drivers/usb/dwc3/dwc3-omap.c
>> +++ b/drivers/usb/dwc3/dwc3-omap.c
>> @@ -138,11 +138,14 @@ static inline void dwc3_omap_writel(void __iomem *base, u32 offset, u32 value)
>>   	writel(value, base + offset);
>>   }
>>
>> -void dwc3_omap_mailbox(enum omap_dwc3_vbus_id_status status)
>> +int dwc3_omap_mailbox(enum omap_dwc3_vbus_id_status status)
>>   {
>>   	u32			val;
>>   	struct dwc3_omap	*omap = _omap;
>>
>> +	if (!omap)
>> +		return -EPROBE_DEFER;
>> +
>>   	switch (status) {
>>   	case OMAP_DWC3_ID_GROUND:
>>   		dev_dbg(omap->dev, "ID GND\n");
>> @@ -185,7 +188,7 @@ void dwc3_omap_mailbox(enum omap_dwc3_vbus_id_status status)
>>   		dev_dbg(omap->dev, "ID float\n");
>>   	}
>>
>> -	return;
>> +	return IRQ_HANDLED;
>
> IRQ_HANDLED ????

Actually I did it that way since palmas_vbus_wakeup_irq can directly 
return the return value from dwc3_omap_mailbox. If this seems hacky to 
you, I'll change it.

Thanks
Kishon
