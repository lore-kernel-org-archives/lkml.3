Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491AbaAFELw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 23:11:52 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:38378 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbaAFELu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 23:11:50 -0500
MIME-Version: 1.0
In-Reply-To: <CAGHPBZogJzOUTM=WooJmNd92=QCivWa9W+c9Co1NJd-sgRTB1A@mail.gmail.com>
References: <CAGHPBZogJzOUTM=WooJmNd92=QCivWa9W+c9Co1NJd-sgRTB1A@mail.gmail.com>
Date: Mon, 6 Jan 2014 12:11:49 +0800
Message-ID: <CAGHPBZpaObWyif7nzitZSQYfvLegFiH0O9S9PCWaWNNQTUqi+Q@mail.gmail.com>
Subject: Re: Confusion about Pinctrl and GPIO
From: Rongrong Cao <caorr1980@gmail.com>
To: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus and Stephen,
Can you help on my question?
Thanks a lot in advance!

2013/12/26 曹荣荣 <caorr1980@gmail.com>:
> Hi Linus and Stephen,
>
> I'm learning the pinctrl subsystem codes these days, and have a
> confusion about it, I'm very appreciated if you can help.
>
> I noticed that Stephen<swarren@nvidia.com> submitted a patch for pinctrl:
> http://www.gossamer-threads.com/lists/linux/kernel/1500890?do=post_view_threaded
>
> In this patch, Stephen said, "When an SoC muxes pins in a group, it's
> quite possible for the group to contain e.g. 6 pins, but only 4 of
> them actually be needed by the HW module that's mux'd to them. In this
> case, the other 2 pins could be used as GPIOs. However, pinctrl marks
> all the pins within the group as in-use by the selected mux function.
> To allow the expected gpiolib interaction, separate the concepts of
> pin ownership into two parts: One for the mux function and one for
> GPIO usage. Finally, allow those two ownerships to exist in parallel.
> "
>
> I agree that gpiolib should be able to use the two idle pins as GPIO,
> but after apply this patch, gpiolib can also request the 4 pins used
> by HW module succesfully, and this will override the settings of the 4
> pins for HW module.
>
> I have read the latest Documentation/pinctrl.txt, and there is two
> examples about muxing logic in "GPIO mode pitfalls" section, let me
> take example A for instance:
>
>                        pin config
>                        logic regs
>                        |               +- SPI
>      Physical pins --- pad --- pinmux -+- I2C
>                                |       +- mmc
>                                |       +- GPIO
>                                pin
>                                multiplex
>                                logic regs
>
> Assuming that the pin has been configured as SPI mode, undoubtedly we
> can't use it as GPIO any longer. However, if we call gpio_request()
> (gpiolib API) to requet this pin for GPIO purpose, gpio_request()
> still can return successfully. I think this is unreasonable,
> gpio_request() should return an "error code" if the pin is in-use by
> PINMUX.
>
> I read the codes of pin_request() in pinmux.c, and guess
> pinmux_ops->gpio_request_enable() may be responsible to handle this
> use case, that is, to return an "error code" if the pin has been owned
> by pinmux. However, no drivers in drivers/pinctrl/ implements such
> codes in pinmux_ops->gpio_request_enable().
> Or, pinctrl subsystem is just resposible to set the pin in GPIO mode,
> and gpio subsystem (gpiolib) is responsible for other things like set
> direction, get value if input, or set high/low if output. Is my
> understanding right?
>
>
> ********************
>
> Let me talk again about the example described by Stephen. If actually
> only 4 pins of the group which contains 6 pins are needed by HW
> module, then why does the group be defined to contain 6 pins? I think
> the group should be defined only containing 4 pins rather than 6 pins,
> then the other 2 idle pins can be used for any other purpose.
>
> Thank you very much in advance!
