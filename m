Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932485Ab3HGStZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 14:49:25 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:61278 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757175Ab3HGStX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 14:49:23 -0400
MIME-Version: 1.0
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F82E849DF@DQHE06.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F82E849DF@DQHE06.ent.ti.com>
Date: Wed, 7 Aug 2013 20:49:22 +0200
Message-ID: <CACRpkdZmMh9MwFQKhZPUZ0dKXQ=8Ear_danBSgOD=PYQUk5QxA@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] gpio: add LP3943 I2C GPIO expander driver
From: Linus Walleij <linus.walleij@linaro.org>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "Samuel Ortiz (sameo@linux.intel.com)" <sameo@linux.intel.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 2:42 AM, Kim, Milo <Milo.Kim@ti.com> wrote:

> This is one of LP3943 MFD driver.
> LP3943 is configurable as a GPIO expander, up to 16 GPIOs.
>
> * Application note: how to configure LP3943 as a GPIO expander
>   http://www.ti.com/lit/an/snva287a/snva287a.pdf
>
> * Supported GPIO controller operations
>   request, free, direction_input, direction_output, get and set
>
> * GPIO direction register not supported
>   LP3943 doesn't have the GPIO direction register. It only provides input and
>   output status registers.
>   So, private data for the direction should be handled manually.
>   This variable is updated whenever the direction is changed and
>   used in 'get' operation.
>
> * Pin assignment
>   A driver data, 'pin_used' is checked when a GPIO is requested.
>   If the GPIO is already assigned, then returns as failure.
>   If the GPIO is available, 'pin_used' is set.
>   When the GPIO is not used anymore, then it is cleared.
>   It is defined as unsigned long type for atomic bit operation APIs,
>   but only LSB 16bits are used because LP3943 has 16 outputs.
>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Milo Kim <milo.kim@ti.com>
> ---
> * Patch v2
>   Use bitops macros for bit manipulations.
>   Support device tree structure for the GPIO controller.
>   Add request() and free() for the pin assignment.

This adresses all my concerns, nice driver.
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

I guess this will be merged through the MFD tree along
with the MFD core patch? That needs to go in first anyway.

Yours,
Linus Walleij
