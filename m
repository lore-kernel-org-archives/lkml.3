Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920Ab3JIIxi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 04:53:38 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:58284 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078Ab3JIIxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 04:53:35 -0400
MIME-Version: 1.0
In-Reply-To: <1380846199-12829-3-git-send-email-syin@broadcom.com>
References: <1380846199-12829-1-git-send-email-syin@broadcom.com>
	<1380846199-12829-3-git-send-email-syin@broadcom.com>
Date: Wed, 9 Oct 2013 10:53:34 +0200
Message-ID: <CACRpkdZTKFtvc3vuNwuP9UuimXuEB2EsOQ3==mXrQw6CMDcxdA@mail.gmail.com>
Subject: Re: [PATCH 2/4] pinctrl: Add pinctrl binding for Broadcom Capri SoCs
From: Linus Walleij <linus.walleij@linaro.org>
To: Sherman Yin <syin@broadcom.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Christian Daudt <bcm@fixthebug.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Matt Porter <matt.porter@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bcm-kernel-feedback-list@broadcom.com,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 4, 2013 at 2:23 AM, Sherman Yin <syin@broadcom.com> wrote:

> +- brcm,hysteresis: Multiple integers, applicable to standard pins only.  Turns
> +               on hysteresis of input.
> +               0: TTL input, 1: Schmitt Trigger input
> +- brcm,pull:   Multiple integers, applicable to standard pins only.  Specifies
> +               pull-up or pull-down.
> +               0: neither, 1: pull-up, 2: pull-down, 3: both
> +- brcm,input_dis: Multiple integers, applicable to all pins.  Input disable
> +               control.
> +               0: off, 1: input disabled
> +- brcm,slew:   Multiple integers.  Slew rate of output.
> +               0: fast output, 1: normal output (most pins)
> +               0: normal output, 1: fast output (IC_DM and IC_DP)
> +               0: Fast mode, 1: High speed mode (I2C)

0,0,0? I don't get this.

> +- brcm,drive_str: Multiple integers.  Drive strength.
> +               0: 2 mA
> +               1: 4 mA
> +               2: 6 mA
> +               3: 8 mA
> +               4: 10 mA
> +               5: 12 mA
> +               6: 14 mA
> +               7: 16 mA
> +- brcm,pull_up_str: Multiple integers.  Pull Up strength.
> +               0: No pull-up
> +               1: 1.2 kOhm
> +               2: 1.8 kOhm
> +               3: 720 Ohm
> +               4: 2.7 kOhm
> +               5: 831 Ohm
> +               6: 1.08 kOhm
> +               7: 568 Ohm
> +- brcm,mode:   Multiple integers.  Mode select.
> +               0: Fast mode, 1: High Speed mode (I2C)

This should *all* be using generic pin config.

For the devicetree side of this, read:
Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt

Your driver should also be selecting GENERIC_PINCONF in
drivers/pinctrl/Kconfig so you use the generic pinconf
library.

Read
include/linux/pinctrl/pinconf-generic.h
for definitions of the generic config options.

Your driver should be calling
pinconf_generic_parse_dt_config() and
pinconf_generic_dt_subnode_to_map() to get the config
out of the device tree nodes.

I don't understand the brcm,mode. Can this be selected on
all pins or just for I2C? I would suspect it be related to
things like disabling the schmitt-trigger, but elaborate on this
so we understand what this is. It may need to be added to the
generic options if it turns out to be unique enough.

New options can be added but first we need to exactly understand
those to see that their definitions does not overlap with already
existing generic pin config terminology.

> +The following are valid pin names and their pin types:
> +
> +       "adcsync",              std

std? std what?

Sorry I don't get anything from this list... you need to be way
more specific in defining what is happening here.

Yours,
Linus Walleij
