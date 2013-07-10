Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082Ab3GJHHm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 03:07:42 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2258 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab3GJHHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 03:07:41 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 10 Jul 2013 00:08:37 -0700
Message-ID: <51DD0A3F.4080206@nvidia.com>
Date: Wed, 10 Jul 2013 12:46:15 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
CC: "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "rob@landley.net" <rob@landley.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kishon@ti.com" <kishon@ti.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>
Subject: Re: [PATCH V2 2/4] extcon: palmas: enable ID_GND and ID_FLOAT detection
 always
References: <1373436959-32444-1-git-send-email-ldewangan@nvidia.com> <1373436959-32444-3-git-send-email-ldewangan@nvidia.com> <51DD0707.8010400@samsung.com>
In-Reply-To: <51DD0707.8010400@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 July 2013 12:32 PM, Chanwoo Choi wrote:
> Hi Laxman,
>
>> @@ -84,28 +86,23 @@ static irqreturn_t palmas_id_irq_handler(int irq, void *_palmas_usb)
>>   
>>   	if (set & PALMAS_USB_ID_INT_SRC_ID_GND) {
>>   		palmas_write(palmas_usb->palmas, PALMAS_USB_OTG_BASE,
>> -			PALMAS_USB_ID_INT_EN_HI_SET,
>> -			PALMAS_USB_ID_INT_EN_HI_SET_ID_FLOAT);
>> -		palmas_write(palmas_usb->palmas, PALMAS_USB_OTG_BASE,
>> -			PALMAS_USB_ID_INT_EN_HI_CLR,
>> -			PALMAS_USB_ID_INT_EN_HI_CLR_ID_GND);
>> -		palmas_write(palmas_usb->palmas, PALMAS_USB_OTG_BASE,
>>   			PALMAS_USB_ID_INT_LATCH_CLR,
>>   			PALMAS_USB_ID_INT_EN_HI_CLR_ID_GND);
>>   		palmas_usb->linkstat = PALMAS_USB_STATE_ID;
>>   		extcon_set_cable_state(&palmas_usb->edev, "USB-HOST", true);
>> +		dev_info(palmas_usb->dev, "HOST cable is attached\n");
>>   	} else if (set & PALMAS_USB_ID_INT_SRC_ID_FLOAT) {
>>   		palmas_write(palmas_usb->palmas, PALMAS_USB_OTG_BASE,
>> -			PALMAS_USB_ID_INT_EN_HI_SET,
>> -			PALMAS_USB_ID_INT_EN_HI_SET_ID_GND);
>> -		palmas_write(palmas_usb->palmas, PALMAS_USB_OTG_BASE,
>> -			PALMAS_USB_ID_INT_EN_HI_CLR,
>> -			PALMAS_USB_ID_INT_EN_HI_CLR_ID_FLOAT);
>> -		palmas_write(palmas_usb->palmas, PALMAS_USB_OTG_BASE,
>>   			PALMAS_USB_ID_INT_LATCH_CLR,
>>   			PALMAS_USB_ID_INT_EN_HI_CLR_ID_FLOAT);
>>   		palmas_usb->linkstat = PALMAS_USB_STATE_DISCONNECT;
>>   		extcon_set_cable_state(&palmas_usb->edev, "USB-HOST", false);
>> +		dev_info(palmas_usb->dev, "HOST cable is detached\n");
>> +	} else if ((palmas_usb->linkstat == PALMAS_USB_STATE_ID) &&
>> +				(!(set & PALMAS_USB_ID_INT_SRC_ID_GND))) {
>> +		palmas_usb->linkstat = PALMAS_USB_STATE_DISCONNECT;
>> +		extcon_set_cable_state(&palmas_usb->edev, "USB-HOST", false);
>> +		dev_info(palmas_usb->dev, "HOST cable is detached\n");
>>   	}
> After I modify info message when USB-HOST cable is attached or detached
> as following mesesage, I applied this patch.
>
> "HOST cable is ..." -> "USB-HOST cable is"

Thank you very much for correction and more meaningful message.

Thanks,
Laxman

