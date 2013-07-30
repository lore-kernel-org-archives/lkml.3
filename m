Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259Ab3G3Exb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 00:53:31 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:48971 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021Ab3G3Ex2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 00:53:28 -0400
Message-ID: <51F746BA.9010408@ti.com>
Date: Tue, 30 Jul 2013 10:23:14 +0530
From: George Cherian <george.cherian@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: <linux-usb@vger.kernel.org>, <balbi@ti.com>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <linux-omap@vger.kernel.org>, <kishon@ti.com>
Subject: Re: [PATCH v2 1/4] usb: phy: phy-omap-control: Add API to power and
 wakeup
References: <1374237277-17769-1-git-send-email-george.cherian@ti.com> <1374237277-17769-2-git-send-email-george.cherian@ti.com> <20130729142517.GA827@linutronix.de>
In-Reply-To: <20130729142517.GA827@linutronix.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/29/2013 7:55 PM, Sebastian Andrzej Siewior wrote:
> * George Cherian | 2013-07-19 18:04:34 [+0530]:
>
>> diff --git a/drivers/usb/phy/phy-omap-control.c b/drivers/usb/phy/phy-omap-control.c
>> index 1419ced..4f2502c 100644
>> --- a/drivers/usb/phy/phy-omap-control.c
>> +++ b/drivers/usb/phy/phy-omap-control.c
>> @@ -46,6 +46,73 @@ struct device *omap_get_control_dev(void)
>> EXPORT_SYMBOL_GPL(omap_get_control_dev);
>>
>> /**
>> + * omap_control_am335x_phy_wkup - PHY wakeup on/off  using control
>> + *	module
>> + * @dev: the control module device
>> + * @on: 0 to off and 1 to on PHY wakeup feature
>> + * @id: phy id 0 or 1 for phy instance 0 and 1 repectively
>> + *
>> + * AMXXXX PHY driver should call this API to enable or disable PHY wakeup.
>> + */
>> +void omap_control_am335x_phy_wkup(struct device *dev, bool on, u8 id)
>> +{
>> +	u32 val;
>> +	u32 *phy_wkup_reg;
>> +	struct omap_control_usb	*control_usb = dev_get_drvdata(dev);
>> +
>> +	if (control_usb->type != OMAP_CTRL_DEV_TYPE3 || id < 0 || id > 1)
>> +		return;
>> +
>> +	phy_wkup_reg = control_usb->dev_conf + AM335X_USB_WKUP_OFFSET;
>> +	val = readl(phy_wkup_reg);
> Where do you get the memory from? In the DT patches I've made I export
> one memory space of 8 bytes for each phy. This memory space applies
> directly to the on/off register.

Control module have 2 separate registers for phy on/off per instance 
(offset 0x620 and 0x628), where as
wkup_ctrl is a shared control module register (offset 0x648). Currently 
the  control module driver maps
  memory from 0x620 till beyond 0x648 and uses the same mapping for 
writing to wkup_reg.
> I didn't export the register for wakeup
> so far since I had no idea how this will be used.
> So how do you get your re-mapped memory here?

Mapping it per instance is not possible since its the same register (if 
we use devm_* calls).



-- 
-George

