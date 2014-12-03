Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751390AbaLCCEO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 21:04:14 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:58895 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750886AbaLCCEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 21:04:12 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Aaron Lu <aaron.lu@intel.com>
Cc: Brian Norris <computersforpeace@gmail.com>, ntrrgc@gmail.com,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI / video: update the condition to check if a device is in _DOD list
Date: Wed, 03 Dec 2014 03:25:36 +0100
Message-ID: <2890155.GWLpTipCZ8@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <547A6F75.6050806@intel.com>
References: <542A4949.2020208@intel.com> <20141129173447.GA3608@norris-Latitude-E6410> <547A6F75.6050806@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, November 30, 2014 09:14:29 AM Aaron Lu wrote:
> On 11/30/2014 01:34 AM, Brian Norris wrote:
> > Tested-by: Brian Norris <computersforpeace@gmail.com>
> 
> Thanks for the test! Updated patch with changelog:
> 
> From 0b11bb529245ddceb69eb558477b9b4a81208f4b Mon Sep 17 00:00:00 2001
> From: Aaron Lu <aaron.lu@intel.com>
> Date: Sun, 30 Nov 2014 09:01:15 +0800
> Subject: [PATCH] ACPI / video: update the condition to check if a device is in _DOD list
> 
> Commit 0b8db271f159 ("ACPI / video: check _DOD list when creating
> backlight devices") checks if the video device is in the bind devices
> list to decide if we should create backlight device for it, that causes
> problem for one Dell Latitude E6410, where none of the video output
> devices are properly bound due to the way how we did the comparing
> between its _ADR and the _DOD's values. Solve this problem by comparing
> the lower 12 bits of both the device's _ADR and the _DOD's values instead
> of relying on bind result.
> 
> Fixes: 0b8db271f159 ("ACPI / video: check _DOD list when creating backlight devices")
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> Tested-by: Brian Norris <computersforpeace@gmail.com>

Queued up as a fix for 3.18.

> ---
>  drivers/acpi/video.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
> index 41e6b977ceb2..185a57d13723 100644
> --- a/drivers/acpi/video.c
> +++ b/drivers/acpi/video.c
> @@ -1164,7 +1164,8 @@ static bool acpi_video_device_in_dod(struct acpi_video_device *device)
>  		return true;
>  
>  	for (i = 0; i < video->attached_count; i++) {
> -		if (video->attached_array[i].bind_info == device)
> +		if ((video->attached_array[i].value.int_val & 0xfff) ==
> +		    (device->device_id & 0xfff))
>  			return true;
>  	}
>  
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
