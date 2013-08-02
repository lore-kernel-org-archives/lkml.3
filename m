Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210Ab3HBB5u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 21:57:50 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:64199 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037Ab3HBB5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 21:57:48 -0400
Message-ID: <51FB1248.8040107@gmail.com>
Date: Fri, 02 Aug 2013 09:58:32 +0800
From: Aaron Lu <aaron.lwe@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Felipe Contreras <felipe.contreras@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, Jiri Kosina <trivial@kernel.org>
Subject: Re: [PATCH 3/3] acpi: video: remove unnecessary casting
References: <1375400641-1694-1-git-send-email-felipe.contreras@gmail.com> <1375400641-1694-4-git-send-email-felipe.contreras@gmail.com>
In-Reply-To: <1375400641-1694-4-git-send-email-felipe.contreras@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2013 07:44 AM, Felipe Contreras wrote:
> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>

Looks good to me, except that no change log feels a little weird.

Reviewed-by: Aaron Lu <aaron.lu@intel.com>

Thanks,
Aaron

> ---
>  drivers/acpi/video.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
> index b07573f..11bafbe 100644
> --- a/drivers/acpi/video.c
> +++ b/drivers/acpi/video.c
> @@ -236,8 +236,7 @@ static int acpi_video_get_brightness(struct backlight_device *bd)
>  {
>  	unsigned long long cur_level;
>  	int i;
> -	struct acpi_video_device *vd =
> -		(struct acpi_video_device *)bl_get_data(bd);
> +	struct acpi_video_device *vd = bl_get_data(bd);
>  
>  	if (acpi_video_device_lcd_get_level_current(vd, &cur_level, false))
>  		return -EINVAL;
> @@ -255,8 +254,7 @@ static int acpi_video_get_brightness(struct backlight_device *bd)
>  static int acpi_video_set_brightness(struct backlight_device *bd)
>  {
>  	int request_level = bd->props.brightness + 2;
> -	struct acpi_video_device *vd =
> -		(struct acpi_video_device *)bl_get_data(bd);
> +	struct acpi_video_device *vd = bl_get_data(bd);
>  
>  	return acpi_video_device_lcd_set_level(vd,
>  				vd->brightness->levels[request_level]);
> 

