Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214Ab3DWEEV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 00:04:21 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:40496 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148Ab3DWEEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 00:04:16 -0400
Date: Mon, 22 Apr 2013 21:04:13 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Chun-Yi Lee <joeyli.kernel@gmail.com>
Cc: mjg@redhat.com, rjw@sisk.pl, platform-driver-x86@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Lee, Chun-Yi" <jlee@suse.com>,
        Carlos Corbacho <carlos@strangeworlds.co.uk>,
        Corentin Chary <corentincj@iksaif.net>, Aaron Lu <aaron.lu@intel.com>,
        Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH 2/2] acer-wmi: add Acer Aspire 5750G to video vendor list
 but keep acpi video driver
Message-ID: <20130423040413.GA2435@core.coreip.homeip.net>
References: <1366634355-26482-1-git-send-email-jlee@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366634355-26482-1-git-send-email-jlee@suse.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 22, 2013 at 08:39:14PM +0800, Chun-Yi Lee wrote:
> From: Lee, Chun-Yi <jlee@suse.com>
> 
> After Andrzej's testing, we found the acpi backlight methods broken on Acer
> Aspire 5750G but the i915 backlight control works when we set to vendor mode.
> And, we still want to keep the acpi/video driver for transfer acpi event to key
> event but not unregister whole acpi/video driver.
> 
> This patch introduced a new capability flag is ACER_CAP_KEEP_VIDEO_KEY, it
> indicates the machine works fine with acpi/video driver for key event but want
> to unregister the backlight interface of acpi/video.
> 
> Reference: bko#35622
>         https://bugzilla.kernel.org/show_bug.cgi?id=35622
> 
> Tested-by: Andrzej Krentosz <endrjux@gmail.com>
> Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>
> Cc: Matthew Garrett <mjg@redhat.com>
> Cc: Dmitry Torokhov <dtor@mail.ru>
> Cc: Corentin Chary <corentincj@iksaif.net>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: Aaron Lu <aaron.lu@intel.com>
> Cc: Thomas Renninger <trenn@suse.de>
> Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
> ---
>  drivers/platform/x86/acer-wmi.c |   20 ++++++++++++++++++++
>  1 files changed, 20 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
> index c9076bd..2a02409 100644
> --- a/drivers/platform/x86/acer-wmi.c
> +++ b/drivers/platform/x86/acer-wmi.c
> @@ -207,6 +207,7 @@ struct hotkey_function_type_aa {
>  #define ACER_CAP_BRIGHTNESS		(1<<3)
>  #define ACER_CAP_THREEG			(1<<4)
>  #define ACER_CAP_ACCEL			(1<<5)
> +#define ACER_CAP_KEEP_VIDEO_KEY		(1<<6)
>  #define ACER_CAP_ANY			(0xFFFFFFFF)
>  
>  /*
> @@ -539,6 +540,15 @@ static int video_set_backlight_video_vendor(const struct dmi_system_id *d)
>  	return 0;
>  }
>  
> +static int video_set_backlight_video_vendor_keep_acpi_video(
> +		const struct dmi_system_id *d)
> +{
> +	video_set_backlight_video_vendor(d);
> +	interface->capability |= ACER_CAP_KEEP_VIDEO_KEY;
> +	pr_info("Keep acpi video driver for emit keycode against backlight change\n");

Huh?

"Keeping acpi video driver active to emit backlight brightness change
key events"?

Thanks.

-- 
Dmitry
