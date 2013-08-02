Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865Ab3HBNqe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 09:46:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47406 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067Ab3HBNqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 09:46:33 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Lan Tianyu" <tianyu.lan@intel.com>
Subject: Re: [53/84] ACPI / video: ignore BIOS initial backlight value for Fujitsu E753
References: <lsq.1375276989.822158812@decadent.org.uk>
Date: Fri, 02 Aug 2013 14:46:29 +0100
In-Reply-To: <lsq.1375276989.822158812@decadent.org.uk> (Ben Hutchings's
	message of "Wed, 31 Jul 2013 15:23:09 +0200")
Message-ID: <87ehac2oju.fsf@canonical.com>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Hutchings <ben@decadent.org.uk> writes:

> 3.2.50-rc1 review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Lan Tianyu <tianyu.lan@intel.com>
>
> commit 9657a565a476d517451c10b0bcc106e300785aff upstream.

For some reason, this commit has been tagged for stable 3.7+ (and this
is why I haven't queued for 3.5).  Is there any reason for this?

Cheers,
-- 
Luis


>
> The BIOS of FUjitsu E753 reports an incorrect initial backlight
>value
> for WIN8 compatible OS, causing backlight to be dark during startup.
> This change causes the incorrect initial value from BIOS to be ignored.
>
> References: https://bugzilla.kernel.org/show_bug.cgi?id=60161
> Reported-and-tested-by: Jan Hinnerk Stosch <janhinnerk.stosch@gmail.com>
> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  drivers/acpi/video.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> --- a/drivers/acpi/video.c
> +++ b/drivers/acpi/video.c
> @@ -449,6 +449,14 @@ static struct dmi_system_id video_dmi_ta
>  	},
>  	{
>  	 .callback = video_ignore_initial_backlight,
> +	 .ident = "Fujitsu E753",
> +	 .matches = {
> +		DMI_MATCH(DMI_BOARD_VENDOR, "FUJITSU"),
> +		DMI_MATCH(DMI_PRODUCT_NAME, "LIFEBOOK E753"),
> +		},
> +	},
> +	{
> +	 .callback = video_ignore_initial_backlight,
>  	 .ident = "HP Pavilion dm4",
>  	 .matches = {
>  		DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),
>
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
