Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014AbaGHJeg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 05:34:36 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:61052 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166AbaGHJed convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 05:34:33 -0400
MIME-Version: 1.0
In-Reply-To: <d1af864d-bf78-48bb-a545-8de3f9def75f@BL2FFO11FD037.protection.gbl>
References: <1403091577-10232-1-git-send-email-harinik@xilinx.com>
	<5cc8b89b-20ff-4fa9-92dd-bb2f6d3512d8@BY2FFO11FD030.protection.gbl>
	<CACRpkdb1M3-hrSKLKWz21LCJ1sMvsq5E-aqkpmVhy0NwOS5HhA@mail.gmail.com>
	<d1af864d-bf78-48bb-a545-8de3f9def75f@BL2FFO11FD037.protection.gbl>
Date: Tue, 8 Jul 2014 11:34:32 +0200
Message-ID: <CACRpkdYSU6NdFuab6rJS7eADSqORNDBzbFfJ65nFoJj3EZVd-g@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] gpio: Add driver for Zynq GPIO controller
From: Linus Walleij <linus.walleij@linaro.org>
To: =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>
Cc: Harini Katakam <harini.katakam@xilinx.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Michal Simek <michal.simek@xilinx.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Harini Katakam <harinikatakamlinux@gmail.com>,
        Harini Katakam <harinik@xilinx.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 7, 2014 at 6:08 PM, Sören Brinkmann
<soren.brinkmann@xilinx.com> wrote:

>> So: what is the usecase for these GPIOs?
>
> Yea, in this case it was a button. I have to look at these drivers. It's
> very likely that they cover what I want. But this case is trivial. I
> really don't do anything but enabling the IRQ by writing to the edge
> attribute and press the push-button connected to that GPIO line.

In case of a system using device tree it is very trivial to add a gpio
key binding. After compiling in the gpio keys driver this small
snipper type is all that is really needed in most cases:

        /* User key mapped in as "escape" */
        gpio-keys {
                compatible = "gpio-keys";
                user-button {
                        label = "user_button";
                        gpios = <&gpio0 3 0x1>;
                        linux,code = <1>; /* KEY_ESC */
                        gpio-key,wakeup;
                };
        };


> But as a general note: I think we have quite some customers trying to do
> GPIO in userspace.

For what? I mean the use cases. Usually it is a bad idea, and
as shown above, just using the right existing device driver with
device tree is much easier, also for an end user, given they know
how to alter DTs and compile in kernel modules.

> With Zynq's FPGA portion, a lot of things come down
> to make signals accessible in Linux and a lot of people do not want or
> need a full blown kernel driver and use GPIO. The request for 'how to
> handle GPIO IRQs in userspace' is pretty common. Often this gets passed
> on to UIO though.

The short answer is don't handle GPIO IRQs in userspace.

Userspace drivers is generally a bad idea and should not be written.
The kernel is intended to handle hardware.

The above is doubly true for anything involving IRQs. Just think
of what IRQs are. They are one of the reasons why we have a
kernel and not just write all software on a system from scratch
ourselves.

Yours,
Linus Walleij
