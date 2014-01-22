Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814AbaAVI04 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 03:26:56 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:64497 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbaAVI0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 03:26:51 -0500
MIME-Version: 1.0
In-Reply-To: <1389961514-13562-19-git-send-email-hanjun.guo@linaro.org>
References: <1389961514-13562-1-git-send-email-hanjun.guo@linaro.org>
	<1389961514-13562-19-git-send-email-hanjun.guo@linaro.org>
Date: Wed, 22 Jan 2014 09:26:50 +0100
Message-ID: <CACRpkdYKwaH5DX27irzmcTDAMhQMUhuzz6N7mjKWv9tZchv0Ug@mail.gmail.com>
Subject: Re: [PATCH 18/20] clocksource / acpi: Add macro CLOCKSOURCE_ACPI_DECLARE
From: Linus Walleij <linus.walleij@linaro.org>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Olof Johansson <olof@lixom.net>,
        Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Patch Tracking <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 1:25 PM, Hanjun Guo <hanjun.guo@linaro.org> wrote:

> From: Amit Daniel Kachhap <amit.daniel@samsung.com>
>
> This macro does the same job as CLOCKSOURCE_OF_DECLARE. The device
> name from the ACPI timer table is matched with all the registered
> timer controllers and matching initialisation routine is invoked.
>
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>

Actually I have a fat patch renaming CLOCKSOURCE_OF_DECLARE()
to TIMER_OF_DECLARE() and I think this macro, if needed, should
be named TIMER_ACPI_DECLARE().

The reason is that "clocksource" is a Linux-internal name and this
macro pertains to the hardware name in respective system
description type.

> +#ifdef CONFIG_ACPI
> +#define CLOCKSOURCE_ACPI_DECLARE(name, compat, fn)                     \
> +       static const struct acpi_device_id __clksrc_acpi_table_##name   \
> +               __used __section(__clksrc_acpi_table)                   \
> +                = { .id = compat,                              \
> +                    .driver_data = (kernel_ulong_t)fn }
> +#else
> +#define CLOCKSOURCE_ACPI_DECLARE(name, compat, fn)
> +#endif

This hammers down the world to compile one binary for ACPI
and one binary for device tree. Maybe that's fine, I don't know.

Yours,
Linus Walleij
