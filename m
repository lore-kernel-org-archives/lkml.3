Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934179AbaGXRT7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 13:19:59 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:62387 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbaGXRT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 13:19:57 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdYY_a_9G-VLBbv2a22Cg4j0t3Wv4W1h0n6-ccCXgVJXsA@mail.gmail.com>
References: <1405507426-18992-1-git-send-email-grygorii.strashko@ti.com>
	<CACRpkdYY_a_9G-VLBbv2a22Cg4j0t3Wv4W1h0n6-ccCXgVJXsA@mail.gmail.com>
Date: Thu, 24 Jul 2014 22:49:56 +0530
Message-ID: <CAJe_ZhdnjyjvEsvK2u7SgS1hJ2fpsXh+=ViGhzakRd+c4ReBaw@mail.gmail.com>
Subject: Re: [PATCH v1] gpio: keystone: add dsp gpio controller driver
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>, Suman Anna <s-anna@ti.com>,
        Alexander Shiyan <shc_work@mail.ru>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        ivan.khoronzhuk@ti.com, Muralidharan Karicheri <m-karicheri2@ti.com>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 July 2014 20:40, Linus Walleij <linus.walleij@linaro.org> wrote:
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
> I'd like Suman and Jassi to have a look at this to see if it's
> actually a mailbox before we proceed.
>
The controller seems like most others, only incapable of reading
signals (output only).
 The userspace driving those signals to communicate with a DSP isn't
enough to call it a mailbox usecase, because on a different board the
userspace may drive those signals to control LEDs :)

Cheers,
Jassi
