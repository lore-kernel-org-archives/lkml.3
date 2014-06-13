Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230AbaFMVnI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 17:43:08 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:39548 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbaFMVnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 17:43:06 -0400
Date: Fri, 13 Jun 2014 14:43:03 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Azael Avalos <coproscefalo@gmail.com>
cc: Nick <xerofoify@gmail.com>, Matthew Garrett <matthew.garrett@nebula.com>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] platform/x86/toshiba-apci.c possible bad if test?
In-Reply-To: <CAGdLNWEaVeWL4=fWY0hLUgq4ii_mHK9a_f8qP6N2cCOEEhtddQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1406131442310.31981@chino.kir.corp.google.com>
References: <1402628655-2904-1-git-send-email-nickkrause@sympatico.ca> <CAGdLNWEaVeWL4=fWY0hLUgq4ii_mHK9a_f8qP6N2cCOEEhtddQ@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jun 2014, Azael Avalos wrote:

> Intel test builder caught some warnings, one at the
> KBD backlight mode store while validating for
> correct parameters, and another one that might lead
> to not creating the sysfs group
> 
> Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
> ---
>  drivers/platform/x86/toshiba_acpi.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/platform/x86/toshiba_acpi.c
> b/drivers/platform/x86/toshiba_acpi.c
> index fbbe46d..f397594 100644
> --- a/drivers/platform/x86/toshiba_acpi.c
> +++ b/drivers/platform/x86/toshiba_acpi.c
> @@ -1218,7 +1218,7 @@ static ssize_t toshiba_kbd_bl_mode_store(struct
> device *dev,
>         int mode = -1;
>         int time = -1;
> 
> -       if (sscanf(buf, "%i", &mode) != 1 && (mode != 2 || mode != 1))
> +       if (sscanf(buf, "%i", &mode) != 1 || mode > 2 || mode < 1)
>                 return -EINVAL;
> 
>         /* Set the Keyboard Backlight Mode where:
> @@ -1741,7 +1741,7 @@ static int toshiba_acpi_add(struct acpi_device *acpi_dev)
> 
>         ret = sysfs_create_group(&dev->acpi_dev->dev.kobj,
>                                  &toshiba_attr_group);
> -       if (ret) {
> +       if (ret != 0) {
>                 dev->sysfs_created = 0;
>                 goto error;
>         }

It may not have been picked up because you've combined unrelated (and 
unnecessary) changes such as your change to toshiba_acpi_add().
