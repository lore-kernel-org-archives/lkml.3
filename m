Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751418Ab3IJL6I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 07:58:08 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:46198 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090Ab3IJL6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 07:58:06 -0400
Message-ID: <522F0946.9040104@ti.com>
Date: Tue, 10 Sep 2013 17:27:58 +0530
From: George Cherian <george.cherian@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        "cw00.choi@samsung.com" <cw00.choi@samsung.com>,
        "kishon@ti.com" <kishon@ti.com>
Subject: Re: [PATCH] extcon: palmas: Dont set USB state if ID pin is grounded
References: <1378799369-15803-1-git-send-email-george.cherian@ti.com> <522EE3B9.4020807@nvidia.com>
In-Reply-To: <522EE3B9.4020807@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/10/2013 2:47 PM, Laxman Dewangan wrote:
> On Tuesday 10 September 2013 01:19 PM, George Cherian wrote:
>> In OMAP5 when USB-HOST is set true, the VBUS regulator  is turned ON.
>> This causes a VBUS interrupt, ignore the same if we are already in
>> USB-HOST.
>>
>> Signed-off-by: George Cherian <george.cherian@ti.com>
>> ---
>>   drivers/extcon/extcon-palmas.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/extcon/extcon-palmas.c 
>> b/drivers/extcon/extcon-palmas.c
>> index 9672f31..91b31af 100644
>> --- a/drivers/extcon/extcon-palmas.c
>> +++ b/drivers/extcon/extcon-palmas.c
>> @@ -50,6 +50,9 @@ static irqreturn_t palmas_vbus_irq_handler(int irq, 
>> void *_palmas_usb)
>>       struct palmas_usb *palmas_usb = _palmas_usb;
>>       unsigned int vbus_line_state;
>>   +    if (palmas_usb->linkstat == PALMAS_USB_STATE_ID)
>> +        return IRQ_HANDLED;
>> +
>
> Should we really handle this on this extcon driver? I think it should 
> be handled in the USB driver. If port is OTG type and if usb driver 
> enable the VBUS then it can expect the VBUS available notification but 
> based on the USB driver state, it should ignore this notification.
>
Correct extcon should just notify and the consumer should take 
appropriate decision.
> Otherwise, Palmas pin find that there is VBUS state true but the SW 
> status will show as the VBUS not there.
>


-- 
-George

