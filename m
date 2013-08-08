Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934146Ab3HHJEG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 05:04:06 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:58290 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934100Ab3HHJEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 05:04:01 -0400
Date: Thu, 8 Aug 2013 10:03:55 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "Kim, Milo" <Milo.Kim@ti.com>,
        "Samuel Ortiz (sameo@linux.intel.com)" <sameo@linux.intel.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>
Subject: Re: [PATCH v2 2/4] gpio: add LP3943 I2C GPIO expander driver
Message-ID: <20130808090355.GA14515@lee--X1>
References: <A874F61F95741C4A9BA573A70FE3998F82E849DF@DQHE06.ent.ti.com>
 <CACRpkdZmMh9MwFQKhZPUZ0dKXQ=8Ear_danBSgOD=PYQUk5QxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdZmMh9MwFQKhZPUZ0dKXQ=8Ear_danBSgOD=PYQUk5QxA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Aug 2013, Linus Walleij wrote:

> On Tue, Jul 30, 2013 at 2:42 AM, Kim, Milo <Milo.Kim@ti.com> wrote:
> 
> > This is one of LP3943 MFD driver.
> > LP3943 is configurable as a GPIO expander, up to 16 GPIOs.
> >
> > * Application note: how to configure LP3943 as a GPIO expander
> >   http://www.ti.com/lit/an/snva287a/snva287a.pdf
> >
> > * Supported GPIO controller operations
> >   request, free, direction_input, direction_output, get and set
> >
> > * GPIO direction register not supported
> >   LP3943 doesn't have the GPIO direction register. It only provides input and
> >   output status registers.
> >   So, private data for the direction should be handled manually.
> >   This variable is updated whenever the direction is changed and
> >   used in 'get' operation.
> >
> > * Pin assignment
> >   A driver data, 'pin_used' is checked when a GPIO is requested.
> >   If the GPIO is already assigned, then returns as failure.
> >   If the GPIO is available, 'pin_used' is set.
> >   When the GPIO is not used anymore, then it is cleared.
> >   It is defined as unsigned long type for atomic bit operation APIs,
> >   but only LSB 16bits are used because LP3943 has 16 outputs.
> >
> > Cc: Linus Walleij <linus.walleij@linaro.org>
> > Signed-off-by: Milo Kim <milo.kim@ti.com>
> > ---
> > * Patch v2
> >   Use bitops macros for bit manipulations.
> >   Support device tree structure for the GPIO controller.
> >   Add request() and free() for the pin assignment.
> 
> This adresses all my concerns, nice driver.
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> 
> I guess this will be merged through the MFD tree along
> with the MFD core patch? That needs to go in first anyway.

That's fine, but first:

1/4 Needs Linus to review
4/4 Needs Thierry's PWM Ack

After that please send v3 with Linus' Rev-By on this patch.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
