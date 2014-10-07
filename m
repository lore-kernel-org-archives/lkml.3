Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747AbaJGKWi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 06:22:38 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:37118 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553AbaJGKWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 06:22:35 -0400
MIME-Version: 1.0
In-Reply-To: <2052507.JjE2hdgEYc@vostro.rjw.lan>
References: <2660541.BycO7TFnA2@vostro.rjw.lan> <2052507.JjE2hdgEYc@vostro.rjw.lan>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Tue, 7 Oct 2014 19:22:13 +0900
Message-ID: <CAAVeFuJwONbZ30jk6B1jPDdUUMSkh7Va4BZFt08+w60yoO=NBw@mail.gmail.com>
Subject: Re: [PATCH 11/13] gpio: Support for unified device properties interface
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Grant Likely <grant.likely@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Darren Hart <dvhart@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 7, 2014 at 9:18 AM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> From: Mika Westerberg <mika.westerberg@linux.intel.com>
>
> Some drivers need to deal with only firmware representation of its
> GPIOs. An example would be a GPIO button array driver where each button
> is described as a separate firmware node in device tree. Typically these
> child nodes do not have physical representation in the Linux device
> model.
>
> In order to help device drivers to handle such firmware child nodes we
> add dev[m]_get_named_gpiod_from_child() that takes a child firmware
> node pointer as its second argument (the first one is the parent device
> itself), finds the GPIO using whatever is the underlying firmware
> method, and requests the GPIO properly.
>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

...

> +/* Child properties interface */
> +struct gpio_desc *dev_get_named_gpiod_from_child(struct device *dev, void *child,
> +                                                const char *propname, int index);
> +struct gpio_desc *devm_get_named_gpiod_from_child(struct device *dev, void *child,
> +                                                 const char *propname, int index);

I see the reason for these functions and am not opposed to them.
However, I wonder if we could not replace propname by a con_id that
would be resolved to one of con_id-gpio for DT and whatever naming
convention ACPI is using?

This would prevent users to name GPIOs outside of the conventions
defined in the bindings and be generally safer. Is there a particular
reason (used by some old code?) for the current direct property
access? If not, maybe we could call a slightly-modified of_find_gpio()
to resolve the GPIO property for DT, and the equivalent function for
ACPI?
