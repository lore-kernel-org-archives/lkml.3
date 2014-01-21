Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111AbaAUJGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 04:06:49 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:46579 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073AbaAUJGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 04:06:42 -0500
Message-ID: <52DE389B.3000702@atmel.com>
Date: Tue, 21 Jan 2014 10:06:35 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Bo Shen <voice.shen@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] USB: at91: fix the number of endpoint parameter
References: <1389927565-22477-1-git-send-email-voice.shen@atmel.com> <20140118052059.GL9558@ns203013.ovh.net> <52DC9A66.6080009@atmel.com> <20140121054932.GO9558@ns203013.ovh.net> <52DE2C05.9060800@atmel.com>
In-Reply-To: <52DE2C05.9060800@atmel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/01/2014 09:12, Bo Shen :
> Hi J,
> 
> On 01/21/2014 01:49 PM, Jean-Christophe PLAGNIOL-VILLARD wrote:
>> On 11:39 Mon 20 Jan     , Bo Shen wrote:
>>> Hi J,
>>>
>>> On 01/18/2014 01:20 PM, Jean-Christophe PLAGNIOL-VILLARD wrote:
>>>> On 10:59 Fri 17 Jan     , Bo Shen wrote:
>>>>> In sama5d3 SoC, there are 16 endpoints. As the USBA_NR_ENDPOINTS
>>>>> is only 7. So, fix it for sama5d3 SoC using the udc->num_ep.
>>>>>
>>>>> Signed-off-by: Bo Shen <voice.shen@atmel.com>
>>>>> ---
>>>>>
>>>>>   drivers/usb/gadget/atmel_usba_udc.c | 2 +-
>>>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/drivers/usb/gadget/atmel_usba_udc.c b/drivers/usb/gadget/atmel_usba_udc.c
>>>>> index 2cb52e0..7e67a81 100644
>>>>> --- a/drivers/usb/gadget/atmel_usba_udc.c
>>>>> +++ b/drivers/usb/gadget/atmel_usba_udc.c
>>>>> @@ -1670,7 +1670,7 @@ static irqreturn_t usba_udc_irq(int irq, void *devid)
>>>>>   	if (ep_status) {
>>>>>   		int i;
>>>>>
>>>>> -		for (i = 0; i < USBA_NR_ENDPOINTS; i++)
>>>>> +		for (i = 0; i < udc->num_ep; i++)
>>>>
>>>> no the limit need to specified in the driver as a checkpoint by the compatible
>>>> or platform driver id
>>>
>>> You mean, we should not trust the data passed from dt node or
>>> platform data? Or do you think we should do double confirm?
>>
>> no base on the driver name or the compatible you will known the MAX EP
>>
>> not based on the dt ep description
>>
>> as we do on pinctrl-at91
> 
> I am sorry, I am not fully get it after reading the code of 
> pinctrl-at91.c, can you give the example code in pinctrl-at91.c?
> 
> Btw, the udc->num_ep is get from the following code.
> for dt
> --->8---
> 	while ((pp = of_get_next_child(np, pp)))
> 		udc->num_ep++;
> ---<8---
> 
> for non-dt
> --->8---
> 	udc->num_ep = pdata->num_ep;
> ---8<---

It seems to me pretty valid to use num_ep in this driver and not have to
rely on another compatibility string just for this.
The information is here, it is retrieved pretty cleanly so I vote for a
simple use of it: if we introduce another information we will have to
double check the cross errors that would happen...

Bye,

>>>>>   			if (ep_status & (1 << i)) {
>>>>>   				if (ep_is_control(&udc->usba_ep[i]))
>>>>>   					usba_control_irq(udc, &udc->usba_ep[i]);
>>>>> --
>>>>> 1.8.5.2
>>>>>
>>>
>>> Best Regards,
>>> Bo Shen
> 
> Best Regards,
> Bo Shen
> 


-- 
Nicolas Ferre
