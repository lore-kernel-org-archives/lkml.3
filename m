Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260AbaBSBrR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 20:47:17 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:55981 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbaBSBrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 20:47:15 -0500
Message-ID: <53040CF7.7060204@atmel.com>
Date: Wed, 19 Feb 2014 09:46:31 +0800
From: Bo Shen <voice.shen@atmel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <nicolas.ferre@atmel.com>, <plagnioj@jcrosoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] USB: at91: using USBA_NR_DMAS for DMA channels
References: <1389927565-22477-1-git-send-email-voice.shen@atmel.com> <1389927565-22477-2-git-send-email-voice.shen@atmel.com> <20140218161839.GD9878@saruman.home> <53040592.2000707@atmel.com> <20140219012252.GA30027@saruman.home>
In-Reply-To: <20140219012252.GA30027@saruman.home>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2014 09:22 AM, Felipe Balbi wrote:
> On Wed, Feb 19, 2014 at 09:14:58AM +0800, Bo Shen wrote:
>> Hi Felipe Balbi,
>>
>> On 02/19/2014 12:19 AM, Felipe Balbi wrote:
>>> On Fri, Jan 17, 2014 at 10:59:25AM +0800, Bo Shen wrote:
>>>> When the SoC is earlier than sama5d3 SoC, which have the same number
>>>> endpoints and DMAs. However for sama5d3 SoC, it has different number
>>>> for endpoints and DMAs. So, define USBA_NR_DMAs for DMA channels
>>>>
>>>> Signed-off-by: Bo Shen <voice.shen@atmel.com>
>>>> ---
>>>>
>>>>   drivers/usb/gadget/atmel_usba_udc.c | 2 +-
>>>>   drivers/usb/gadget/atmel_usba_udc.h | 2 +-
>>>>   2 files changed, 2 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/usb/gadget/atmel_usba_udc.c b/drivers/usb/gadget/atmel_usba_udc.c
>>>> index 7e67a81..5cded1c 100644
>>>> --- a/drivers/usb/gadget/atmel_usba_udc.c
>>>> +++ b/drivers/usb/gadget/atmel_usba_udc.c
>>>> @@ -1661,7 +1661,7 @@ static irqreturn_t usba_udc_irq(int irq, void *devid)
>>>>   	if (dma_status) {
>>>>   		int i;
>>>>
>>>> -		for (i = 1; i < USBA_NR_ENDPOINTS; i++)
>>>> +		for (i = 1; i < USBA_NR_DMAS; i++)
>>>>   			if (dma_status & (1 << i))
>>>>   				usba_dma_irq(udc, &udc->usba_ep[i]);
>>>>   	}
>>>> diff --git a/drivers/usb/gadget/atmel_usba_udc.h b/drivers/usb/gadget/atmel_usba_udc.h
>>>> index 2922db5..a70706e 100644
>>>> --- a/drivers/usb/gadget/atmel_usba_udc.h
>>>> +++ b/drivers/usb/gadget/atmel_usba_udc.h
>>>> @@ -210,7 +210,7 @@
>>>>   #define USBA_FIFO_BASE(x)	((x) << 16)
>>>>
>>>>   /* Synth parameters */
>>>> -#define USBA_NR_ENDPOINTS	7
>>>> +#define USBA_NR_DMAS		7
>>>
>>> what's the difference ? You just renamed this macro. Also, please
>>> clarify a bit your commit log.
>>
>> As commit message said, the SoC before sama5d3, the endpoint number
>> is the same as DMA channel number, so use endpoints definition for
>> DMA channel number, however after sama5d3, the endpoints is not the
>> same as DMA channel, so use DMA micro for DMA channels.
>
> which means you're just renaming the macro for the sake of clarity.
> That's fine, just needs to be clearer in commit message.

Thanks, I will send v2 to make the commit message more clearer.

Best Regards,
Bo Shen
