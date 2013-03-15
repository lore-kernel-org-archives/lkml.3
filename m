Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab3COIhw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 04:37:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:26636 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752429Ab3COIhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 04:37:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,849,1355126400"; 
   d="scan'208";a="302646260"
Message-ID: <5142DE26.7020404@intel.com>
Date: Fri, 15 Mar 2013 16:39:02 +0800
From: Aaron Lu <aaron.lu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Danny Baumann <dannybaumann@web.de>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 2/3] ACPI video: Make logic a little easier to understand.
References: <1363257264-15984-1-git-send-email-dannybaumann@web.de> <1363257264-15984-3-git-send-email-dannybaumann@web.de>
In-Reply-To: <1363257264-15984-3-git-send-email-dannybaumann@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2013 06:34 PM, Danny Baumann wrote:
> Make code paths a little easier to follow, and don't needlessly continue
> list iteration.

Same here, please add Signed-off-by tag.
Reviewed-by: Aaron Lu <aaron.lu@intel.com>

Thanks,
Aaron

> ---
>  drivers/acpi/video.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
> index ef85574..d0fade7 100644
> --- a/drivers/acpi/video.c
> +++ b/drivers/acpi/video.c
> @@ -736,16 +736,17 @@ acpi_video_init_brightness(struct acpi_video_device *device)
>  		 */
>  		if (use_bios_initial_backlight) {
>  			for (i = 2; i < br->count; i++)
> -				if (level_old == br->levels[i])
> +				if (level_old == br->levels[i]) {
>  					level = level_old;
> +					break;
> +				}
>  		}
> -		goto set_level;
> +	} else {
> +		if (br->flags._BCL_reversed)
> +			level_old = (br->count - 1) - level_old;
> +		level = br->levels[level_old];
>  	}
>  
> -	if (br->flags._BCL_reversed)
> -		level_old = (br->count - 1) - level_old;
> -	level = br->levels[level_old];
> -
>  set_level:
>  	result = acpi_video_device_lcd_set_level(device, level);
>  	if (result)
> 

