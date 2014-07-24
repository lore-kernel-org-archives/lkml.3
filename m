Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935013AbaGXXlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 19:41:17 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44725 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934696AbaGXXlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 19:41:15 -0400
Message-ID: <53D1998D.2050804@ti.com>
Date: Thu, 24 Jul 2014 19:41:01 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Suman Anna <s-anna@ti.com>, Jassi Brar <jaswinder.singh@linaro.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Alexander Shiyan <shc_work@mail.ru>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        <ivan.khoronzhuk@ti.com>, Muralidharan Karicheri <m-karicheri2@ti.com>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] gpio: keystone: add dsp gpio controller driver
References: <1405507426-18992-1-git-send-email-grygorii.strashko@ti.com>	<CACRpkdYY_a_9G-VLBbv2a22Cg4j0t3Wv4W1h0n6-ccCXgVJXsA@mail.gmail.com>	<CAJe_ZhdnjyjvEsvK2u7SgS1hJ2fpsXh+=ViGhzakRd+c4ReBaw@mail.gmail.com>	<53D140EC.9020609@ti.com> <CAJe_ZhfCdrgaVEZ5h=+Ko7U3RW2M9QRd3T4=_JzYxKxv+brZFg@mail.gmail.com> <53D15603.5030001@ti.com>
In-Reply-To: <53D15603.5030001@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 July 2014 02:52 PM, Suman Anna wrote:
> Hi,
> 
> On 07/24/2014 01:12 PM, Jassi Brar wrote:
>> On 24 July 2014 22:52, Santosh Shilimkar <santosh.shilimkar@ti.com> wrote:
>>> On Thursday 24 July 2014 01:19 PM, Jassi Brar wrote:
>>>> On 23 July 2014 20:40, Linus Walleij <linus.walleij@linaro.org> wrote:
>>>>> On Wed, Jul 16, 2014 at 12:43 PM, Grygorii Strashko
>>>>> <grygorii.strashko@ti.com> wrote:
>>>>>
>>>>>> From: Murali Karicheri <m-karicheri2@ti.com>
>>>>>>
>>>>>> On Keystone SOCs, ARM host can send interrupts to DSP cores using the
>>>>>> DSP GPIO controller IP. Each DSP GPIO controller provides 28 IRQ signals for
>>>>>> each DSP core. This is one of the component used by the IPC mechanism used
>>>>>> on Keystone SOCs.
>>>>>>
>>>>>> Keystone 2 DSP GPIO controller has specific features:
>>>>>> - each GPIO can be configured only as output pin;
>>>>>> - setting GPIO value to 1 causes IRQ generation on target DSP core;
>>>>>> - reading pin value returns 0 - if IRQ was handled or 1 - IRQ is still
>>>>>>   pending.
>>>>>>
>>>>>> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
>>>>>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>>>>>
>>>>> Pardon me. How is this GENERAL PURPOSE Input/Output?
>>>>>
>>>>> It seems very very much SPECIAL PURPOSE to me, it's like
>>>>> you're just shoehorning some IPC mechanism into the GPIO
>>>>> subsystem, and this may be because the datasheet calls it
>>>>> GPIO when it's not.
>>>>>
>>>>> What other stuff than DSP is connected to these lines, and is it
>>>>> really even external lines? Aren't these just polysilicon rails
>>>>> pretty much hammered to be used by the DSP and nothing else.
>>>>>
>>>>> What is the difference between this and a mailbox IRQ line
>>>>> and the kind of stuff handled by drivers/mailbox?
>>>>>
>>>>> I'd like Suman and Jassi to have a look at this to see if it's
>>>>> actually a mailbox before we proceed.
>>>>>
>>>> The controller seems like most others, only incapable of reading
>>>> signals (output only).
>>>>  The userspace driving those signals to communicate with a DSP isn't
>>>> enough to call it a mailbox usecase, because on a different board the
>>>> userspace may drive those signals to control LEDs :)
>>>>
>>> Exactly !!
>>> And that was my point. Thanks for echo.
>>>
>> Yeah but if the AP and DSP are within the same package (i.e, the
>> 'pins' can't be used for any other purpose on any board), one might
>> sell it as a mailbox. However, since the mailbox protocol driver would
>> be in userspace, I think it is justified to expose that as GPIO
>> otherwise we'll have to add another interface for userspace to control
>> the DSP.
> 
> If all these pins or a group of pins are collectively being used to
> denote a message to the DSP, then I can see the argument for this being
> a mailbox platform driver. It then probably would need to be
> supplemented by some other protocol driver to expose the necessary
> functionality to userspace. Otherwise, I agree with Jassi in general.
>
Just 1 line is used as I mentioned to you off-list already.
 
> That said, having two different drivers for different GPIO IP instances
> within the same SoC doesn't make sense. There should be a single driver
> for all the GPIO IPs in keystone, output/input only are properties of
> the instance and the driver should handle that IMHO.
> 
I wish the hardware integration was the way you said. The one GPIO
controller supports only 32 IO's and thats used for IO's. The IP
block was carried over from Legacy SOCs. The $subject IP block 
has sligtly different programming model, address space, clock domains
etc so there is no question of handling that in 1 driver where the
two hardware IPs are different. Hope its clear why they are in
two separate drivers.

Regards,
Santosh

