Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab3HPPAc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 11:00:32 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:58075 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826Ab3HPPA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 11:00:29 -0400
MIME-Version: 1.0
In-Reply-To: <1375123145-31648-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1375123145-31648-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
	<1375123145-31648-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Date: Fri, 16 Aug 2013 17:00:29 +0200
Message-ID: <CACRpkdarBoKge2Z5wFW46KAsd0N942TYzpoxCRt0AmcU8ad0Rw@mail.gmail.com>
Subject: Re: [PATCH 3/3] gpio: pcf857x: Add OF support
From: Linus Walleij <linus.walleij@linaro.org>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 8:39 PM, Laurent Pinchart
<laurent.pinchart+renesas@ideasonboard.com> wrote:

> Add DT bindings for the pcf857x-compatible chips and parse the device
> tree node in the driver.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
>  .../devicetree/bindings/gpio/gpio-pcf857x.txt      | 69 ++++++++++++++++++++++

Do you think you can get one of the DT bindings mainatiners to ACK
this part?

I am told we need to get more strict on binding review.

It will be subject to timeout if it takes to long and you made a reasonable
effort to get their consent though.

> +  - interrupt-controller: Identifies the node as an interrupt controller.
> +  - #interrupt-cells: Number of cells to encode an interrupt source, shall be 2.
> +  - interrupt-parent: phandle of the parent interrupt controller.
> +  - interrupts: Interrupt specifier for the controllers interrupt.

So this is another one of of those GPIO controller that are
also interrupt controllers.

So it will be subject to the same dilemma as the OMAP
expander that has caused so much stir :-(

Can you provide your input in the discussion regarding my
patch with the subject:
"RFC: interrupt consistency check for OF GPIO IRQs"

This patch will affect this driver also, in a very direct way, by just
stealing and setting as input any GPIO line used for an IRQ.

> +Please refer to gpio.txt in this directory for details of the common GPIO
> +bindings used by client devices.
> +
> +Example: PCF8575 I/O expander node
> +
> +       pcf8575: gpio@20 {
> +               compatible = "nxp,pcf8575";
> +               reg = <0x20>;
> +               interrupt-parent = <&irqpin2>;
> +               interrupts = <3 0>;
> +               interrupt-controller;
> +               #interrupt-cells = <2>;
> +       };

Not gpio-controller?

Apart from that it looks good, please help out with the
gpio-controller vs interrupt-controller dilemma if you can
because it's getting really frustrating...

Yours,
Linus Walleij
