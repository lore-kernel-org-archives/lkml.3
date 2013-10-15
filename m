Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933938Ab3JOXay (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 19:30:54 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:51305 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933597Ab3JOXax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 19:30:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Lennart Poettering <lennart@poettering.net>
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] acpi/video: Add Lenovo IdeaPad Yoga 13 to acpi video detect blacklist
Date: Wed, 16 Oct 2013 01:42:42 +0200
Message-ID: <2179447.s8536zuTL5@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20131014005505.GA30503@tango.0pointer.de>
References: <20131014005505.GA30503@tango.0pointer.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 14, 2013 02:55:05 AM Lennart Poettering wrote:
> On the Yoga 13 the backlight control doesn't work via ACPI. (And doesn't
> work either with the low-level platform driver ideapad_laptop; but
> works correctly via the intel video driver).  This patch hence adds the
> Yoga 13 to the ACPI video detect blacklist, to make sure the broken ACPI
> backlight device is never exposed to userspace.
> 
> Note that this appears unrelated to the Windows 8 backlight issues tracked
> here:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=51231
> https://bugzilla.kernel.org/show_bug.cgi?id=60682
> 
> The Yoga's ACPI backlight controls work neither with nor without
> acpi_osi="!Windows 2012" on the kernel command line. It appears that
> backlight control via the EC simply is not available at all, regardless
> whether done via ACPI or via the vendor driver.
> 
> Signed-off-by: Lennart Poettering <lennart@poettering.net>

I've added this to my queue for 3.13.

Thanks!

> ---
>  drivers/acpi/video_detect.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
> index 940edbf..a88e8f7 100644
> --- a/drivers/acpi/video_detect.c
> +++ b/drivers/acpi/video_detect.c
> @@ -168,6 +168,14 @@ static struct dmi_system_id video_detect_dmi_table[] = {
>  		DMI_MATCH(DMI_PRODUCT_NAME, "UL30A"),
>  		},
>  	},
> +	{
> +	.callback = video_detect_force_vendor,
> +	.ident = "Lenovo Yoga 13",
> +	.matches = {
> +		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
> +		DMI_MATCH(DMI_PRODUCT_VERSION, "Lenovo IdeaPad Yoga 13"),
> +		},
> +	},
>  	{ },
>  };
>  
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
