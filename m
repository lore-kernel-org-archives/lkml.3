Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758935Ab3E3SoY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 14:44:24 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:47733 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671Ab3E3SoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 14:44:17 -0400
MIME-Version: 1.0
In-Reply-To: <1369881923-27067-13-git-send-email-sathyanarayanan.kuppuswamy@intel.com>
References: <1369881923-27067-1-git-send-email-sathyanarayanan.kuppuswamy@intel.com>
	<1369881923-27067-13-git-send-email-sathyanarayanan.kuppuswamy@intel.com>
Date: Thu, 30 May 2013 20:44:17 +0200
Message-ID: <CACRpkdZbCytqaWTK7HvfU2aMpPQVZWX2uf-NXL-rUPGJ6DQ-mQ@mail.gmail.com>
Subject: Re: [PATCH v1 12/13] gpiolib: append SFI helpers for GPIO API
From: Linus Walleij <linus.walleij@linaro.org>
To: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        mark.gross@intel.com, len.brown@intel.com,
        David Cohen <david.a.cohen@intel.com>, fei.yang@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 4:45 AM, Sathyanarayanan Kuppuswamy
<sathyanarayanan.kuppuswamy@intel.com> wrote:

> From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>
> To support some (legacy) firmwares and platforms let's make life easier for
> their customers.

I'd like Grant to have a look at this too, if possible.

> Change-Id: I39a0e3e0ed4e04a0d733801f59d46d76189195e8

We don't put Google Gerrit change-IDs into the kernel log.
But fun to know you're using it...

(...)
> +++ b/drivers/gpio/gpiolib-sfi.c
> @@ -0,0 +1,76 @@
> +/*
> + * SFI helpers for GPIO API

Spell out "Simple Firmware Interface helpers..." it's not like
everyone knows.

> +static struct sfi_gpio_table_entry *sfi_gpio_table;
> +static int sfi_gpio_num_entry;
> +
> +int sfi_get_gpio_by_name(const char *name)
> +{
> +       struct sfi_gpio_table_entry *pentry = sfi_gpio_table;
> +       int i;
> +
> +       if (!pentry)
> +               return -1;

Don't you want to return a serious error code?

> +
> +       for (i = 0; i < sfi_gpio_num_entry; i++, pentry++) {
> +               if (!strncmp(name, pentry->pin_name, SFI_NAME_LEN))
> +                       return pentry->pin_no;
> +       }
> +
> +       return -1;

Dito.

> +}
> +EXPORT_SYMBOL_GPL(sfi_get_gpio_by_name);

(...)
> diff --git a/include/linux/sfi_gpio.h b/include/linux/sfi_gpio.h
> new file mode 100644
> index 0000000..ef7e497
> --- /dev/null
> +++ b/include/linux/sfi_gpio.h
> @@ -0,0 +1,27 @@
> +#ifndef _LINUX_SFI_GPIO_H_
> +#define _LINUX_SFI_GPIO_H_
> +
> +#include <linux/errno.h>
> +#include <linux/gpio.h>
> +#include <linux/sfi.h>
> +
> +#ifdef CONFIG_GPIO_SFI
> +
> +int sfi_get_gpio_by_name(const char *name);
> +int __init sfi_gpio_init(void);

IIRC you do not need to tag things with __init in header files.

> +
> +#else /* CONFIG_GPIO_SFI */
> +
> +static inline int sfi_get_gpio_by_name(const char *name);
> +{
> +       return -1;

Why -1? -ENOTSUPP? Or some other error code?

> +}
> +
> +static inline int __init sfi_gpio_init(void)

Do not tag inline functions with __init.

Yours,
Linus Walleij
