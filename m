Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064AbaFMPV0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 11:21:26 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:37177 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818AbaFMPVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 11:21:24 -0400
MIME-Version: 1.0
In-Reply-To: <1402628655-2904-1-git-send-email-nickkrause@sympatico.ca>
References: <1402628655-2904-1-git-send-email-nickkrause@sympatico.ca>
Date: Fri, 13 Jun 2014 09:21:23 -0600
Message-ID: <CAGdLNWEaVeWL4=fWY0hLUgq4ii_mHK9a_f8qP6N2cCOEEhtddQ@mail.gmail.com>
Subject: Re: [PATCH] platform/x86/toshiba-apci.c possible bad if test?
From: Azael Avalos <coproscefalo@gmail.com>
To: Nick <xerofoify@gmail.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've sent this patch a few weeks ago, but somehow it didn't managed to
get through :-(

If it's still possible, please pick it up Matthew.


Cheers.
Azael


8<------------------------------------------------------------------------------------------------------------------------->8
Intel test builder caught some warnings, one at the
KBD backlight mode store while validating for
correct parameters, and another one that might lead
to not creating the sysfs group

Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
---
 drivers/platform/x86/toshiba_acpi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/toshiba_acpi.c
b/drivers/platform/x86/toshiba_acpi.c
index fbbe46d..f397594 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -1218,7 +1218,7 @@ static ssize_t toshiba_kbd_bl_mode_store(struct
device *dev,
        int mode = -1;
        int time = -1;

-       if (sscanf(buf, "%i", &mode) != 1 && (mode != 2 || mode != 1))
+       if (sscanf(buf, "%i", &mode) != 1 || mode > 2 || mode < 1)
                return -EINVAL;

        /* Set the Keyboard Backlight Mode where:
@@ -1741,7 +1741,7 @@ static int toshiba_acpi_add(struct acpi_device *acpi_dev)

        ret = sysfs_create_group(&dev->acpi_dev->dev.kobj,
                                 &toshiba_attr_group);
-       if (ret) {
+       if (ret != 0) {
                dev->sysfs_created = 0;
                goto error;
        }


--
1.9.1

2014-06-12 21:04 GMT-06:00 Nick <xerofoify@gmail.com>:
> diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
> index 76441dc..dfd2243 100644
> --- a/drivers/platform/x86/toshiba_acpi.c
> +++ b/drivers/platform/x86/toshiba_acpi.c
> @@ -1238,7 +1238,7 @@ static ssize_t toshiba_kbd_bl_mode_store(struct device *dev,
>         int mode = -1;
>         int time = -1;
>
> -       if (sscanf(buf, "%i", &mode) != 1 && (mode != 2 || mode != 1))
> +       if (sscanf(buf, "%i", &mode) != 1  || (mode != 2 || mode != 1))
>                 return -EINVAL;
>
>         /* Set the Keyboard Backlight Mode where:
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe platform-driver-x86" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
-- El mundo apesta y vosotros apestais tambien --
