Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757053Ab3ENIrF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 04:47:05 -0400
Received: from mail-ia0-f180.google.com ([209.85.210.180]:60161 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757025Ab3ENIq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 04:46:59 -0400
MIME-Version: 1.0
In-Reply-To: <1368019749-19455-10-git-send-email-lee.jones@linaro.org>
References: <1368019749-19455-1-git-send-email-lee.jones@linaro.org>
	<1368019749-19455-10-git-send-email-lee.jones@linaro.org>
Date: Tue, 14 May 2013 10:46:58 +0200
Message-ID: <CACRpkdY8SLRR0HQvD5AFUeNeeHRVt3XM-MOkwJs_h_EfeRctKw@mail.gmail.com>
Subject: Re: [PATCH 9/9] mfd: ab8500-core: Pass GPADC compatible string to MFD core
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 8, 2013 at 3:29 PM, Lee Jones <lee.jones@linaro.org> wrote:

> When booting with Device Tree enabled the MFD core uses each device's
> compatible string to find and allocate its associated of_node pointer,
> which in turn is passed to the driver via the platform_device struct.
> Without it, the driver won't be able to interrogate the Device Tree or
> locate suitable regulators and will most likely fail to probe.
>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Can you explain what regression this is causing since the GPADC
driver (drivers/mfd/ab8500-gpadc.c) does not support device tree
probing and does not have an .of_match_table defined in it's
driver struct? I mean, what could possibly match that
compatible string? The .name field will take care of naming
the device does it not?

For non-emergency merging though:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Since it matches the example in
Documentation/devicetree/bindings/mfd/ab8500.txt

But for this to make sense the AB8500 ADC driver needs
to be augmented for DT probing and preferrably also moved
to drivers/adc and made to utilize that subsystem.

Yours,
Linus Walleij
