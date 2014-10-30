Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760634AbaJ3PUq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 11:20:46 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:57457 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583AbaJ3PUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 11:20:45 -0400
MIME-Version: 1.0
In-Reply-To: <1414404914-163837-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1414404914-163837-1-git-send-email-mika.westerberg@linux.intel.com>
Date: Thu, 30 Oct 2014 16:20:44 +0100
Message-ID: <CACRpkdag38GawJEZ+m+P-qcRQk24asSaP8GCmu6ssvDPHud4eg@mail.gmail.com>
Subject: Re: [PATCH] net: rfkill: gpio: Add default GPIO driver mappings for ACPI
From: Linus Walleij <linus.walleij@linaro.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alexandre Courbot <gnurou@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@linaro.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 11:15 AM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:

> The driver uses devm_gpiod_get_index(..., index) so that the index refers
> directly to the GpioIo resource under the ACPI device. The problem with
> this is that if the ordering changes we get wrong GPIOs.
>
> With ACPI 5.1 _DSD we can now use names instead to reference GPIOs
> analogous to Device Tree. However, we still have systems out there that do
> not provide _DSD at all. These systems must be supported as well.
>
> Luckily we now have acpi_dev_add_driver_gpios() that can be used to provide
> mappings for systems where _DSD is not provided and still take advantage of
> _DSD if it exists.
>
> This patch changes the driver to create default GPIO mappings if we are
> running on ACPI system.
>
> While there we can drop the indices completely and use devm_gpiod_get()
> with name instead.
>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> ---
> Hi,
>
> This patch is based on top of linux-pm/device-properties [1] and following
> patch from Rafael [2].
>
> Johannes, John,
>
> If you are happy with the patch, can you ACK it so that we can merge it
> with the rest of the device-properties patches. Thanks.
>
> [1] git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git
> [2] https://lkml.org/lkml/2014/10/24/690
(...)
> +static const struct acpi_gpio_params reset_gpios = { 0, 0, false };
> +static const struct acpi_gpio_params shutdown_gpios = { 1, 0, false };
> +
> +static const struct acpi_gpio_mapping acpi_rfkill_default_gpios[] = {
> +       { "reset-gpios", &reset_gpios, 1 },
> +       { "shutdown-gpios", &shutdown_gpios, 1 },
> +       { },
> +};

Jaysis, it could use a comment above the map telling the poor code
reader what is actually going on.

Other than that, this is what we have to live with I guess so:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
