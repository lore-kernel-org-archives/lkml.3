Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758175AbaGWP0N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 11:26:13 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:35107 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758070AbaGWP0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 11:26:11 -0400
Message-ID: <53CFD404.7070704@ti.com>
Date: Wed, 23 Jul 2014 11:25:56 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Suman Anna <s-anna@ti.com>,
        Jaswinder Singh <jaswinder.singh@linaro.org>,
        Alexander Shiyan <shc_work@mail.ru>
CC: Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        <ivan.khoronzhuk@ti.com>, Muralidharan Karicheri <m-karicheri2@ti.com>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] gpio: keystone: add dsp gpio controller driver
References: <1405507426-18992-1-git-send-email-grygorii.strashko@ti.com> <CACRpkdYY_a_9G-VLBbv2a22Cg4j0t3Wv4W1h0n6-ccCXgVJXsA@mail.gmail.com>
In-Reply-To: <CACRpkdYY_a_9G-VLBbv2a22Cg4j0t3Wv4W1h0n6-ccCXgVJXsA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 July 2014 11:10 AM, Linus Walleij wrote:
> On Wed, Jul 16, 2014 at 12:43 PM, Grygorii Strashko
> <grygorii.strashko@ti.com> wrote:
> 
>> From: Murali Karicheri <m-karicheri2@ti.com>
>>
>> On Keystone SOCs, ARM host can send interrupts to DSP cores using the
>> DSP GPIO controller IP. Each DSP GPIO controller provides 28 IRQ signals for
>> each DSP core. This is one of the component used by the IPC mechanism used
>> on Keystone SOCs.
>>
>> Keystone 2 DSP GPIO controller has specific features:
>> - each GPIO can be configured only as output pin;
>> - setting GPIO value to 1 causes IRQ generation on target DSP core;
>> - reading pin value returns 0 - if IRQ was handled or 1 - IRQ is still
>>   pending.
>>
>> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> 
> Pardon me. How is this GENERAL PURPOSE Input/Output?
> 
> It seems very very much SPECIAL PURPOSE to me, it's like
> you're just shoehorning some IPC mechanism into the GPIO
> subsystem, and this may be because the datasheet calls it
> GPIO when it's not.
>
> What other stuff than DSP is connected to these lines, and is it
> really even external lines? Aren't these just polysilicon rails
> pretty much hammered to be used by the DSP and nothing else.
>
> What is the difference between this and a mailbox IRQ line
> and the kind of stuff handled by drivers/mailbox?
>
I will try to answer this. This IP is indeed a GPIO block
but the IO's are used just OUTPUT lines from Linux
HOST perspective. These IOs are connected to the DSPs
as input/IRQ lines. The DSP-ARM host IPC mechanism used on
Keystone is Linux user-space based and it does as one of the
component.

Its not mailbox since there is no payload etc attached to it.
GPIO lib does expose the IO's to userspace and thats what is
being the case here. I think it is a legitimate usecase.

Sometimes the sending signals to another co-processor might
appear like shoehorning or odd but it just uses standard
GPIO library and its capabilities as is.

Regards,
Santosh






