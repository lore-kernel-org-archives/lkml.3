Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321Ab3JDM0n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 08:26:43 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41320 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287Ab3JDM0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 08:26:41 -0400
MIME-Version: 1.0
X-Originating-IP: [89.2.206.189]
In-Reply-To: <1378286856-6384-1-git-send-email-teg@jklm.no>
References: <20130903193547.GA8150@srcf.ucam.org> <1378286856-6384-1-git-send-email-teg@jklm.no>
From: Tom Gundersen <teg@jklm.no>
Date: Fri, 4 Oct 2013 14:26:20 +0200
Message-ID: <CAG-2HqUhZdYgYcDGJaFUJV-AqgbbFh55HMcw6nRppiUyeHGjcw@mail.gmail.com>
Subject: Re: [PATCH] input: i8042 - add PNP modaliases
To: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Tom Gundersen <teg@jklm.no>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 4, 2013 at 11:27 AM, Tom Gundersen <teg@jklm.no> wrote:
> This allows the module to be autoloaded in the common case.
>
> In order to work on non-PnP systems the module should be compiled in or loaded
> unconditionally at boot (c.f. modules-load.d(5)), as before.
>
> Cc: Matthew Garrett <mjg59@srcf.ucam.org>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Signed-off-by: Tom Gundersen <teg@jklm.no>
> --


Hi Dmitry,

Any comments on this? Any chance of having this (and the two patches
dropping EXPERT=y requirements) included for 3.13 (or even 3.12 if it
is not too late for this kind of stuff)? Let me know if I should
resend the three patches.

Cheers,

Tom

> This appears to work for me (though I don't have the real hardware to test), I get the following aliases:
> alias:          acpi*:CPQA0D7:*
> alias:          pnp:dCPQA0D7*
> alias:          acpi*:PNP0345:*
> alias:          pnp:dPNP0345*
> alias:          acpi*:PNP0344:*
> alias:          pnp:dPNP0344*
> alias:          acpi*:PNP0343:*
> alias:          pnp:dPNP0343*
> alias:          acpi*:PNP0320:*
> alias:          pnp:dPNP0320*
> alias:          acpi*:PNP030B:*
> alias:          pnp:dPNP030b*
> alias:          acpi*:PNP030A:*
> alias:          pnp:dPNP030a*
> alias:          acpi*:PNP0309:*
> alias:          pnp:dPNP0309*
> alias:          acpi*:PNP0306:*
> alias:          pnp:dPNP0306*
> alias:          acpi*:PNP0305:*
> alias:          pnp:dPNP0305*
> alias:          acpi*:PNP0304:*
> alias:          pnp:dPNP0304*
> alias:          acpi*:PNP0303:*
> alias:          pnp:dPNP0303*
> alias:          acpi*:PNP0302:*
> alias:          pnp:dPNP0302*
> alias:          acpi*:PNP0301:*
> alias:          pnp:dPNP0301*
> alias:          acpi*:PNP0300:*
> alias:          pnp:dPNP0300*
>
>  drivers/input/serio/i8042-x86ia64io.h | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
> index 5f306f7..0ec9abb 100644
> --- a/drivers/input/serio/i8042-x86ia64io.h
> +++ b/drivers/input/serio/i8042-x86ia64io.h
> @@ -765,6 +765,7 @@ static struct pnp_device_id pnp_kbd_devids[] = {
>         { .id = "CPQA0D7", .driver_data = 0 },
>         { .id = "", },
>  };
> +MODULE_DEVICE_TABLE(pnp, pnp_kbd_devids);
>
>  static struct pnp_driver i8042_pnp_kbd_driver = {
>         .name           = "i8042 kbd",
> @@ -786,6 +787,7 @@ static struct pnp_device_id pnp_aux_devids[] = {
>         { .id = "SYN0801", .driver_data = 0 },
>         { .id = "", },
>  };
> +MODULE_DEVICE_TABLE(pnp, pnp_aux_devids);
>
>  static struct pnp_driver i8042_pnp_aux_driver = {
>         .name           = "i8042 aux",
> --
> 1.8.4
>
