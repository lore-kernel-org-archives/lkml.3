Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab3HBCDT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 22:03:19 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:47929 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622Ab3HBCDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 22:03:18 -0400
Message-ID: <51FB137D.7070000@gmail.com>
Date: Fri, 02 Aug 2013 10:03:41 +0800
From: Aaron Lu <aaron.lwe@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Felipe Contreras <felipe.contreras@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH] acpi: video: fix reversed indexed BQC
References: <1375400042-989-1-git-send-email-felipe.contreras@gmail.com>
In-Reply-To: <1375400042-989-1-git-send-email-felipe.contreras@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2013 07:34 AM, Felipe Contreras wrote:
> Commit 1a7c618 (ACPI video: support _BQC/_BCL/_BCM methods that use
> index values) assumed that bl->levels were not reverted, but at this
> point they already are, so there's no need to revert them yet again.

When acpi_video_bqc_value_to_level is called, bl->levels is not
reverted. Can you please point me the code path when it is called and
bl->levels were still reverted? I think we will need to fix that then.

-Aaron

> 
> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
> ---
>  drivers/acpi/video.c | 13 ++-----------
>  1 file changed, 2 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
> index 0ec434d..b27c049 100644
> --- a/drivers/acpi/video.c
> +++ b/drivers/acpi/video.c
> @@ -499,19 +499,10 @@ acpi_video_bqc_value_to_level(struct acpi_video_device *device,
>  {
>  	unsigned long long level;
>  
> -	if (device->brightness->flags._BQC_use_index) {
> -		/*
> -		 * _BQC returns an index that doesn't account for
> -		 * the first 2 items with special meaning, so we need
> -		 * to compensate for that by offsetting ourselves
> -		 */
> -		if (device->brightness->flags._BCL_reversed)
> -			bqc_value = device->brightness->count - 3 - bqc_value;
> -
> +	if (device->brightness->flags._BQC_use_index)
>  		level = device->brightness->levels[bqc_value + 2];
> -	} else {
> +	else
>  		level = bqc_value;
> -	}
>  
>  	level += bqc_offset_aml_bug_workaround;
>  
> 

