Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab3G2UQB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 16:16:01 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:46434 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754837Ab3G2UP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 16:15:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Simon Guinot <simon.guinot@sequanux.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Subject: Re: [PATCH v3] gpio: add GPIO support for F71882FG and F71889F
Date: Mon, 29 Jul 2013 22:26:09 +0200
Message-ID: <10218498.b5WOCmgjXj@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CACRpkda2bH_TkFR6c0cXvjye4SmFWN5xuzQSO=NqBq8mNDgV0g@mail.gmail.com>
References: <1374486633-9737-1-git-send-email-simon.guinot@sequanux.org> <CACRpkda2bH_TkFR6c0cXvjye4SmFWN5xuzQSO=NqBq8mNDgV0g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 29, 2013 05:59:08 PM Linus Walleij wrote:
> On Mon, Jul 22, 2013 at 11:50 AM, Simon Guinot
> <simon.guinot@sequanux.org> wrote:
> 
> > This patch adds support for the GPIOs found on the Fintek super-I/O
> > chips F71882FG and F71889F.
> >
> > A super-I/O is a legacy I/O controller embedded on x86 motherboards. It
> > is used to connect the low-bandwidth devices. Among others functions the
> > F71882FG/F71889F provides: a parallel port, two serial ports, a keyboard
> > controller, an hardware monitoring controller and some GPIO pins.
> >
> > Note that this super-I/Os are embedded on some Atom-based LaCie NASes.
> > The GPIOs are used to control the LEDs and the hard drive power.
> >
> > Signed-off-by: Simon Guinot <simon.guinot@sequanux.org>
> > ---
> > Changes since v2:
> > - Remove useless NULL setters for driver data.
> 
> Given the recent discussion with Rafael I want to have an
> extended discussion of this patch.
> 
> It is my current understanding that:
> 
> - It is possible to define the whereabouts of the SuperIO
>   chips using ACPI
> - It is possible for developers to influence the source
>   AML for the DSDT tables of these systems.
> - It is the proper thing to do.
> - So we should atleast support ACPI probing with the
>   port-based detection as a final fallback if all else fails.
> 
> Why can I not get something like:
> 
> #include <linux/acpi.h>
> (...)
> static const struct acpi_device_id gpio_acpi_match[] = {
>         { "FOOBAR", 0 },
>         { }
> };
> MODULE_DEVICE_TABLE(acpi, gpio_acpi_match);
> 
> static struct platform_driver gpio_driver = {
>         (...)
>         .driver         = {
>                  (...)
>                 .acpi_match_table = ACPI_PTR(gpio_acpi_match),
>         },
> };
> 
> ?
> 
> If there is something wrong in my reasoning above, please
> share it!

In addition to that, the "FOOBAR" PNP ID needs to be added to the
acpi_platform_device_ids[] table in drivers/acpi/acpi_platform.c.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
