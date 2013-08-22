Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343Ab3HVV13 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 17:27:29 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:55815 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753084Ab3HVV12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 17:27:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Len Brown <lenb@kernel.org>, Zhang Rui <rui.zhang@intel.com>
Subject: Re: [RESEND/PATCH] acpi: video: remove unused code
Date: Thu, 22 Aug 2013 23:38:01 +0200
Message-ID: <1808554.Og9bqVFP8Z@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1377196271-20427-1-git-send-email-felipe.contreras@gmail.com>
References: <1377196271-20427-1-git-send-email-felipe.contreras@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 22, 2013 01:31:11 PM Felipe Contreras wrote:
> _BCM_use_index and _BCL_use_index are never used and probably never will.
> 
> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>

I have this patch in the linux-next branch, although under a different subject.

Thanks,
Rafael


> ---
>  drivers/acpi/video.c | 12 ------------
>  1 file changed, 12 deletions(-)
> 
> diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
> index e1284b8..e6be27e 100644
> --- a/drivers/acpi/video.c
> +++ b/drivers/acpi/video.c
> @@ -185,8 +185,6 @@ struct acpi_video_device_cap {
>  struct acpi_video_brightness_flags {
>  	u8 _BCL_no_ac_battery_levels:1;	/* no AC/Battery levels in _BCL */
>  	u8 _BCL_reversed:1;		/* _BCL package is in a reversed order*/
> -	u8 _BCL_use_index:1;		/* levels in _BCL are index values */
> -	u8 _BCM_use_index:1;		/* input of _BCM is an index value */
>  	u8 _BQC_use_index:1;		/* _BQC returns an index value */
>  };
>  
> @@ -806,16 +804,6 @@ acpi_video_init_brightness(struct acpi_video_device *device)
>  	br->count = count;
>  	device->brightness = br;
>  
> -	/* Check the input/output of _BQC/_BCL/_BCM */
> -	if ((max_level < 100) && (max_level <= (count - 2)))
> -		br->flags._BCL_use_index = 1;
> -
> -	/*
> -	 * _BCM is always consistent with _BCL,
> -	 * at least for all the laptops we have ever seen.
> -	 */
> -	br->flags._BCM_use_index = br->flags._BCL_use_index;
> -
>  	/* _BQC uses INDEX while _BCL uses VALUE in some laptops */
>  	br->curr = level = max_level;
>  
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
