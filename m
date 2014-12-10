Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502AbaLJO3W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 09:29:22 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:58787 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757416AbaLJO3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 09:29:17 -0500
Message-ID: <548858B7.1020307@gmail.com>
Date: Wed, 10 Dec 2014 17:29:11 +0300
From: Dmitry Tunin <hanipouspilot@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: platform-driver-x86@vger.kernel.org
CC: linux-kernel <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH v2] acpi: Add "acpi_osi=" for ASUS X200MA to enable brightness
References: <54845180.4060206@gmail.com> <548465CA.8020905@gmail.com>
In-Reply-To: <548465CA.8020905@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is only a temporary hack. This issue should be fixed by other ways.
See https://bugzilla.kernel.org/show_bug.cgi?id=70241#c70

07.12.2014 17:35, Dmitry Tunin пишет:
> Add "acpi_osi=" quirk for ASUS X200MA
> More information can be found in UX302LA bugreport
> https://bugzilla.kernel.org/show_bug.cgi?id=70241
>
> I reported it to launchpad too
> https://bugs.launchpad.net/ubuntu/bug/1400068
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Dmitry Tunin <hanipouspilot@gmail.com>
> ---
>   drivers/acpi/blacklist.c | 20 ++++++++++++++++++++
>   1 file changed, 20 insertions(+)
>
> diff --git a/drivers/acpi/blacklist.c b/drivers/acpi/blacklist.c
> index 7556e7c..f78ed08 100644
> --- a/drivers/acpi/blacklist.c
> +++ b/drivers/acpi/blacklist.c
> @@ -162,6 +162,17 @@ static int __init dmi_disable_osi_win8(const struct dmi_system_id *d)
>       acpi_osi_setup("!Windows 2012");
>       return 0;
>   }
> +/*
> + * Some ASUS models firmware declares 16 devices instead of 8
> + * 'acpi_osi=' kernel parameter fixes it
> + * Without this parameters brightness keys Fn+F5 and F6 do not work
> + */
> +static int __init dmi_disable_osi_all(const struct dmi_system_id *d)
> +{
> +    printk(KERN_NOTICE PREFIX "DMI detected: %s\n", d->ident);
> +    acpi_osi_setup("");
> +    return 0;
> +}
>
>   static struct dmi_system_id acpi_osi_dmi_table[] __initdata = {
>       {
> @@ -371,6 +382,15 @@ static struct dmi_system_id acpi_osi_dmi_table[] __initdata = {
>                DMI_MATCH(DMI_PRODUCT_NAME, "1015PX"),
>           },
>       },
> +    /* Without this brightness keys do not work */
> +    {
> +    .callback = dmi_disable_osi_all,
> +    .ident = "ASUSTeK COMPUTER INC. X200MA",
> +    .matches = {
> +             DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
> +             DMI_MATCH(DMI_PRODUCT_NAME, "X200MA"),
> +        },
> +    },
>       {}
>   };
>
