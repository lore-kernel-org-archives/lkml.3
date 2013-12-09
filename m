Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760224Ab3LIBpj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 20:45:39 -0500
Received: from mail.fpasia.hk ([202.130.89.98]:47193 "EHLO fpa01n0.fpasia.hk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760148Ab3LIBph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 20:45:37 -0500
Message-ID: <52A520BA.1000603@gtsys.com.hk>
Date: Mon, 09 Dec 2013 09:45:30 +0800
From: Chris Ruehl <chris.ruehl@gtsys.com.hk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Icedove/3.0.11 ThunderBrowse/3.8
MIME-Version: 1.0
To: balbi@ti.com
CC: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] usb: phy-generic: Add GPIO based ChipSelect
References: <1385967919-13258-1-git-send-email-chris.ruehl@gtsys.com.hk> <1385967919-13258-2-git-send-email-chris.ruehl@gtsys.com.hk> <20131206202453.GF21086@saruman.home>
In-Reply-To: <20131206202453.GF21086@saruman.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, December 07, 2013 04:24 AM, Felipe Balbi wrote:
> Hi,
>
> On Mon, Dec 02, 2013 at 03:05:17PM +0800, Chris Ruehl wrote:
>> @@ -231,27 +249,40 @@ static int usb_phy_gen_xceiv_probe(struct platform_device *pdev)
>>   		return -ENOMEM;
>>
>>   	nop->reset_active_low = true;	/* default behaviour */
>> +	nop->cs_active_low = true;
>>
>>   	if (dev->of_node) {
>>   		struct device_node *node = dev->of_node;
>>   		enum of_gpio_flags flags;
>> +		enum of_gpio_flags csflags;
>>
>>   		if (of_property_read_u32(node, "clock-frequency",&clk_rate))
>>   			clk_rate = 0;
>>
>>   		needs_vcc = of_property_read_bool(node, "vcc-supply");
>> +
>>   		nop->gpio_reset = of_get_named_gpio_flags(node, "reset-gpios",
>>   								0,&flags);
>> +
>
> two unrelated changes
>
>>   		if (nop->gpio_reset == -EPROBE_DEFER)
>>   			return -EPROBE_DEFER;
>>
>>   		nop->reset_active_low = flags&  OF_GPIO_ACTIVE_LOW;
>>
>> +		nop->gpio_chipselect = of_get_named_gpio_flags(node, "cs-gpios",
>> +								0,&csflags);
>> +		if (gpio_is_valid(nop->gpio_chipselect))
>> +			nop->cs_active_low = csflags&  OF_GPIO_ACTIVE_LOW;
>> +
>>   	} else if (pdata) {
>>   		type = pdata->type;
>>   		clk_rate = pdata->clk_rate;
>>   		needs_vcc = pdata->needs_vcc;
>>   		nop->gpio_reset = pdata->gpio_reset;
>> +		nop->gpio_chipselect = pdata->gpio_chipselect;
>> +	} else {
>> +		nop->gpio_reset = -1;
>
> This line is already going upstream, please remove it, i'll handle the
> conflict later.
>

Beause the rest of the patch set is not ready to make it in the upstream, I will 
checkout latest linux-next and send the patch again as a single patch.

thanks
Chris
