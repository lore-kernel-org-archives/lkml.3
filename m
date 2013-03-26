Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934223Ab3CZNUY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 09:20:24 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:43029 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933294Ab3CZNUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 09:20:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Fabio Valentini <fafatheone@gmail.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] acpi: fix suspend and resume on Sony Vaio VGN-FW21M
Date: Tue, 26 Mar 2013 14:27:48 +0100
Message-ID: <23942335.XujJYDvZZh@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1363029394.3138.3.camel@fafadora.lan>
References: <1363029394.3138.3.camel@fafadora.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, March 11, 2013 08:16:34 PM Fabio Valentini wrote:
>     From: Fabio Valentini <fafatheone@gmail.com>
> 
>     Add Sony Vaio VGN-FW21M to the device blacklist in drivers/acpi/sleep.c.
>     Fixes suspend/resume on this device (device no longer reboots instead of resuming).
>     Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=55001
> 
>     Signed-off-by: Fabio Valentini <fafatheone@gmail.com>

Applied to linux-pm.git/linux-next.

Thanks,
Rafael


> ---
>     Patch applies cleanly to latest master (3.9-rc2) and stable (3.8.2).
>      drivers/acpi/sleep.c | 8 ++++++++
>      1 file changed, 8 insertions(+)
> 
> --- linux/drivers/acpi/sleep.c.orig	2013-03-09 16:46:41.407984555 +0100
> +++ linux/drivers/acpi/sleep.c	2013-03-09 16:49:03.693005658 +0100
> @@ -193,6 +193,14 @@ static struct dmi_system_id __initdata a
>  	},
>  	{
>  	.callback = init_nvs_nosave,
> +	.ident = "Sony Vaio VGN-FW21M",
> +	.matches = {
> +		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
> +		DMI_MATCH(DMI_PRODUCT_NAME, "VGN-FW21M"),
> +		},
> +	},
> +	{
> +	.callback = init_nvs_nosave,
>  	.ident = "Sony Vaio VPCEB17FX",
>  	.matches = {
>  		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
