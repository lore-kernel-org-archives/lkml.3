Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936Ab3KSJY0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 04:24:26 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:60083 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab3KSJYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 04:24:23 -0500
MIME-Version: 1.0
In-Reply-To: <1370440690-21898-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1370440690-21898-1-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Tue, 19 Nov 2013 10:24:22 +0100
Message-ID: <CACRpkdaP+tkJn8jcR_RaCz_c6hk66F8qde2KRiCzNyyLWUkgjw@mail.gmail.com>
Subject: Re: [PATCH v1.2] gpiolib: append SFI helpers for GPIO API
From: Linus Walleij <linus.walleij@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        David Cohen <david.a.cohen@intel.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Cc: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>,
        Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 5, 2013 at 3:58 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:

> To support some (legacy) firmwares and platforms let's make life easier for
> their customers.
>
> This patch extracts SFI GPIO API from arch/x86/platform/mrst/mrst.c.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

So since this patch was ACKed the world has changed a bit and now
I want new changes (or maybe I was tired and not paying enough
attention at the time).

(...)
> +int sfi_get_gpio_by_name(const char *name)
> +{
> +       struct sfi_gpio_table_entry *pentry = sfi_gpio_table;
> +       int i;
> +
> +       if (!pentry)
> +               return -EINVAL;
> +
> +       for (i = 0; i < sfi_gpio_num_entry; i++, pentry++) {
> +               if (!strncmp(name, pentry->pin_name, SFI_NAME_LEN))
> +                       return pentry->pin_no;
> +       }
> +
> +       return -ENODEV;
> +}
> +EXPORT_SYMBOL_GPL(sfi_get_gpio_by_name);

Last merge window we merged the GPIO descriptor API and this
is now the recommended way to handle GPIOs and it is also
deployed into the ACPI and DT implementations.

So I'd like the signature of this function changed to return
a GPIO descriptor rather than an int so we don't stockpile more
stuff to refactor.

i.e.:
struct gpio_desc *sfi_get_gpio_by_name(const char *name);

 --- /dev/null
> +++ b/include/linux/sfi_gpio.h

Maybe that header could move to <linux/gpio/sfi.h> instead.
Alexandre what do you think?

Yours,
Linus Walleij
