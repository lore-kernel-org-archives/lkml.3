Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759586AbaHHW0f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 18:26:35 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:36292 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbaHHW0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 18:26:31 -0400
Message-ID: <53E54E91.9060905@collabora.co.uk>
Date: Sat, 09 Aug 2014 00:26:25 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, Stephen Warren <swarren@nvidia.com>,
        Yufeng Shen <miletus@chromium.org>, Benson Leung <bleung@chromium.org>,
        Olof Johansson <olof@lixom.net>, Tomasz Figa <tomasz.figa@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Abraham <thomas.ab@samsung.com>
Subject: Re: [PATCH v2 1/1] Input: atmel_mxt_ts - Get IRQ edge/level flags
 on DT booting
References: <1407397492-17475-1-git-send-email-javier.martinez@collabora.co.uk>	<53E4D9A5.908@itdev.co.uk>	<20140808162146.GC26820@core.coreip.homeip.net>	<53E4FD1B.6060600@collabora.co.uk>	<53E5170C.10302@collabora.co.uk> <CAD=FV=WSNqjHLLbTh1LBF3RFrCnWnj498hivivcmx1SbuYp=Hw@mail.gmail.com>
In-Reply-To: <CAD=FV=WSNqjHLLbTh1LBF3RFrCnWnj498hivivcmx1SbuYp=Hw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Doug,

On 08/08/2014 10:54 PM, Doug Anderson wrote:
> Hi,
>>
>> To fix the issue a variation of patch [0] will be posted that moves the IRQ
>> pinmux setup from .irq_set_type to the .irq_request_resources function handler.
>> That way the pin will be setup as IRQ regardless of the the trigger type [1]
>> when someone calls request_[threaded]_irq().
>>
>> Only the mentioned patch fixes the issue but Tomasz said that even a call to
>> gpio_direction_{input,output} can change the pin configuration so he will post
>> another patch that will add a bit mask to samsung_pin_bank to prevent any pinmux
>> reconfiguration.
> 
> Would just making a device tree change fix this?  AKA for the pin, do:
> 
>   samsung,pin-function = <0xf>;
> 

Yes, when configuring the pin as 0xf (GPIO interrupt) instead of 0x0 (GPIO
input) the issue is not present indeed. So after Nick answer my question about
what I got wrong with the "linux,gpio-keymap" property, I will change the pin
function when re-posing the DTS changes for the atmel touchpad.

> I have some vague recollection that I set interrupts to pin-function
> "0" by default for some reason (assuming they would go to 0xf when
> interrupts were enabled).  ...but I can't for the life of me remember
> if it was a good reason or just seemed like the right thing to do.
> 

It would be great to know if there is a good reason. I see indeed that all
pinctrl setup in the Peach Pit/Pi and Snow DTS that involves interrupts are
using 0x0 as the pin function. Since as Tomasz explained Samsung SoC makes a
difference between GPIO-IRQ and GPIO input I guess that it's better to change
those to 0xf instead. What do you think?

Regardless of this though I think that both the patch to move the IRQ
pinmux setup from .irq_set_type to the .irq_request_resources and the patch to
to prevent any pinmux reconfiguration are good improvements to avoid future
issues like the one we found here.

> -Doug
> 

Best regards,
Javier
