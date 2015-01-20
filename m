Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852AbbATIls (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 03:41:48 -0500
Received: from mail-oi0-f44.google.com ([209.85.218.44]:62499 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbbATIlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 03:41:45 -0500
MIME-Version: 1.0
In-Reply-To: <CAAfSe-tAwURc_P+-0+m22ao9r+Fud6Ae89JF8FGsWgg_49Mdhg@mail.gmail.com>
References: <1421402411-3479-1-git-send-email-chunyan.zhang@spreadtrum.com>
	<1421402411-3479-6-git-send-email-chunyan.zhang@spreadtrum.com>
	<CAL_JsqJg=BtanmR_rhYthCUhKbErs8viZ7MMMXr-PmPjUV4BRQ@mail.gmail.com>
	<CAAfSe-vqqpvbYe0bEeD-3_QsLYz4r7pxMuA1-L4cYRw9TY=NgA@mail.gmail.com>
	<CAL_JsqLTArm1v8ka39_KLq2jMKkK2ZXQ6-an=JSWVgTK1LWmOg@mail.gmail.com>
	<CAAfSe-tAwURc_P+-0+m22ao9r+Fud6Ae89JF8FGsWgg_49Mdhg@mail.gmail.com>
Date: Tue, 20 Jan 2015 16:41:44 +0800
Message-ID: <CA+H2tpEFQjG0fFR-D+L2KYr0uLQqYYQM8wGut7ohzLSfotV3zA@mail.gmail.com>
Subject: Re: [PATCH v5 5/5] tty/serial: Add Spreadtrum sc9836-uart driver support
From: Orson Zhai <orsonzhai@gmail.com>
To: Lyra Zhang <zhang.lyra@gmail.com>
Cc: Rob Herring <robherring2@gmail.com>,
        Chunyan Zhang <chunyan.zhang@spreadtrum.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Rutland <mark.rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>, Jiri Slaby <jslaby@suse.cz>,
        Jason Cooper <jason@lakedaemon.net>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Florian Vaussard <florian.vaussard@epfl.ch>,
        Andrew Lunn <andrew@lunn.ch>, Robert Richter <rrichter@cavium.com>,
        Hayato Suzuki <hytszk@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Antony Pavlov <antonynpavlov@gmail.com>,
        Joel Schopp <Joel.Schopp@amd.com>,
        Suravee Suthikulanit <Suravee.Suthikulpanit@amd.com>,
        Shawn Guo <shawn.guo@linaro.org>, lea.yan@linaro.org,
        Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>,
        "geng.ren@spreadtrum.com" <geng.ren@spreadtrum.com>,
        "zhizhou.zhang" <zhizhou.zhang@spreadtrum.com>,
        "lanqing.liu@spreadtrum.com" <lanqing.liu@spreadtrum.com>,
        =?UTF-8?B?V2VpIFFpYW8gKOS5lOS8nyk=?= <wei.qiao@spreadtrum.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 3:37 PM, Lyra Zhang <zhang.lyra@gmail.com> wrote:
> Hi, Rob
>
> I still have a question to be conform, specific describes below:
>
> On Mon, Jan 19, 2015 at 10:11 PM, Rob Herring <robherring2@gmail.com> wrote:
>> On Mon, Jan 19, 2015 at 3:55 AM, Lyra Zhang <zhang.lyra@gmail.com> wrote:
>>> On Sat, Jan 17, 2015 at 12:41 AM, Rob Herring <robherring2@gmail.com> wrote:
>>>> On Fri, Jan 16, 2015 at 4:00 AM, Chunyan Zhang
>>>> <chunyan.zhang@spreadtrum.com> wrote:
>>>>> Add a full sc9836-uart driver for SC9836 SoC which is based on the
>>>>> spreadtrum sharkl64 platform.
>>>>> This driver also support earlycon.
>>>>> This patch also replaced the spaces between the macros and their
>>>>> values with the tabs in serial_core.h
>>
>> [...]
>>
>>>>> +static int __init sprd_serial_init(void)
>>>>> +{
>>>>> +       int ret = 0;
>>>>> +
>>>>> +       ret = uart_register_driver(&sprd_uart_driver);
>>>>
>>>> This can be done in probe now. Then you can use module_platform_driver().
>>>>
>>>
>>> Question:
>>> 1. there are 4 uart ports configured in dt for sprd_serial, so probe
>>> will be called 4 times, but uart_register_driver only needs to be
>>> called one time, so can we use uart_driver.state to check if
>>> uart_register_driver has already been called ?
>>
>> Yes.
>>
>>> 2. if I use module_platform_driver() instead of
>>> module_init(sprd_serial_init)  and  module_exit(sprd_serial_exit) , I
>>> must move uart_unregister_driver() which is now processed in
>>> sprd_serial_exit() to sprd_remove(), there is a similar problem with
>>> probe(), sprd_remove() will also be called 4 times, and actually it
>>> should be called only one time. How can we deal with this case?
>>
>> Look at pl01x or Samsung UART drivers which have done this conversion.
>
> Samsung UART does use module_platform_driver, but pl010/pl011 doesn't.
> In the Samsung UART driver, uart_unregister_driver is processed in
> remove(), like below:
>
> static int s3c24xx_serial_remove(struct platform_device *dev)
> {
>     struct uart_port *port = s3c24xx_dev_to_port(&dev->dev);
>
>     if (port) {
>         s3c24xx_serial_cpufreq_deregister(to_ourport(port));
>         uart_remove_one_port(&s3c24xx_uart_drv, port);
>     }
>
>     uart_unregister_driver(&s3c24xx_uart_drv);
> }
>
> if this serial has more than one ports, uart_unregister_driver() must
> be called multiple times when the device need to be removed.
> I think there may be a problem because that uart_unregister_driver()
> will do kfree(drv->state) every time when it's called.

I think it is no appropriate to call uart_unregister_driver() at first
port removing.
The drv->state buffer was shared with all uart ports.
If there are some cases that only 1 port is needed to be removed, that
will destroy all others, isn't it?

Regards,
Orson


>
> Thanks,
> Chunyan
>
>>
>>> 3. for the second question, we can check the platform_device->id, if
>>> it is equal to the index of last port (e.g. 4 for this case), then
>>> uart_unregister_driver() can be called. Does it work correctly? since
>>> for this case, we must keep the order of releasing ports.
>>
>> The id will not be the line index in the DT case. I don't think you
>> can guarantee the order either.
>>
>> It would be better to make uart_{un}register_driver deal with being
>> called multiple times so drivers don't have to deal with getting this
>> correct. I'm not sure if that is feasible though.
>>
>> Rob
