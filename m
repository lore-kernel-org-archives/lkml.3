Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810AbaATDjT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 22:39:19 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:19457 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710AbaATDjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 22:39:15 -0500
Message-ID: <52DC9A66.6080009@atmel.com>
Date: Mon, 20 Jan 2014 11:39:18 +0800
From: Bo Shen <voice.shen@atmel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: Felipe Balbi <balbi@ti.com>, <nicolas.ferre@atmel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] USB: at91: fix the number of endpoint parameter
References: <1389927565-22477-1-git-send-email-voice.shen@atmel.com> <20140118052059.GL9558@ns203013.ovh.net>
In-Reply-To: <20140118052059.GL9558@ns203013.ovh.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi J,

On 01/18/2014 01:20 PM, Jean-Christophe PLAGNIOL-VILLARD wrote:
> On 10:59 Fri 17 Jan     , Bo Shen wrote:
>> In sama5d3 SoC, there are 16 endpoints. As the USBA_NR_ENDPOINTS
>> is only 7. So, fix it for sama5d3 SoC using the udc->num_ep.
>>
>> Signed-off-by: Bo Shen <voice.shen@atmel.com>
>> ---
>>
>>   drivers/usb/gadget/atmel_usba_udc.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/usb/gadget/atmel_usba_udc.c b/drivers/usb/gadget/atmel_usba_udc.c
>> index 2cb52e0..7e67a81 100644
>> --- a/drivers/usb/gadget/atmel_usba_udc.c
>> +++ b/drivers/usb/gadget/atmel_usba_udc.c
>> @@ -1670,7 +1670,7 @@ static irqreturn_t usba_udc_irq(int irq, void *devid)
>>   	if (ep_status) {
>>   		int i;
>>
>> -		for (i = 0; i < USBA_NR_ENDPOINTS; i++)
>> +		for (i = 0; i < udc->num_ep; i++)
>
> no the limit need to specified in the driver as a checkpoint by the compatible
> or platform driver id

You mean, we should not trust the data passed from dt node or platform 
data? Or do you think we should do double confirm?

> Best Regards,
> J.
>>   			if (ep_status & (1 << i)) {
>>   				if (ep_is_control(&udc->usba_ep[i]))
>>   					usba_control_irq(udc, &udc->usba_ep[i]);
>> --
>> 1.8.5.2
>>

Best Regards,
Bo Shen
