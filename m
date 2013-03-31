Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039Ab3CaBtT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 21:49:19 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:48245 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755766Ab3CaBtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 21:49:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Artem Savkov <artem.savkov@gmail.com>
Cc: dannybaumann@web.de, aaron.lu@intel.com, rafael.j.wysocki@intel.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] acpi/video: lcd_get_level_current doen't return current level
Date: Sun, 31 Mar 2013 03:56:50 +0200
Message-ID: <5996696.NNHVTCA6T8@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1364648501-5127-1-git-send-email-artem.savkov@gmail.com>
References: <1364648501-5127-1-git-send-email-artem.savkov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, March 30, 2013 05:01:41 PM Artem Savkov wrote:
> acpi_video_device_lcd_get_level_current() called acpi_video_bqc_value_to_level()
> with "*level" as a second argument, resulting in level being returned based on
> initial input, not current brightness, breaking backlight controls.

This looks like a valid fix, but (1) is the problem being fixed a regression
and if so, which was the last working kernel and (2) do you have any pointers
to bug reports/BZ entries related to that?

Also, do I assume correctly that you've tested it?

Rafael


> Signed-off-by: Artem Savkov <artem.savkov@gmail.com>
> ---
>  drivers/acpi/video.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
> index 3cdd047..68a777b 100644
> --- a/drivers/acpi/video.c
> +++ b/drivers/acpi/video.c
> @@ -505,7 +505,8 @@ acpi_video_device_lcd_get_level_current(struct acpi_video_device *device,
>  				return 0;
>  			}
>  
> -			*level = acpi_video_bqc_value_to_level(device, *level);
> +			*level = acpi_video_bqc_value_to_level(device,
> +					device->brightness->curr);
>  
>  			for (i = 2; i < device->brightness->count; i++)
>  				if (device->brightness->levels[i] == *level) {
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
