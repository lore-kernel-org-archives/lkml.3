Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbaF3B37 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 21:29:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:50108 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753379AbaF3B35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 21:29:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,572,1400050800"; 
   d="scan'208";a="555036994"
Message-ID: <53B0BD92.8090209@intel.com>
Date: Mon, 30 Jun 2014 09:29:54 +0800
From: Aaron Lu <aaron.lu@intel.com>
MIME-Version: 1.0
To: Martin Kepplinger <martink@posteo.de>, rui.zhang@intel.com
CC: rjw@rjwysocki.net, lenb@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix backlight control for Acer TravelMate B113
References: <1403555446-16863-1-git-send-email-martink@posteo.de> <53AFD16D.10209@posteo.de>
In-Reply-To: <53AFD16D.10209@posteo.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2014 04:42 PM, Martin Kepplinger wrote:
> Am 2014-06-23 22:30, schrieb Martin Kepplinger:
>> Fix backlight control for Acer TravelMate B113 Laptop by adding
>> it to the video_dmi_table.
>>
>> A workaround before that was to use acpi_osi=Linux or
>> acpi_backlight=vendor on boot but even then, only the function-
>> keys worked.
>>
>> With this change there is no need for boot parameters and DE's
>> controls work as well.
>>
>> Signed-off-by: Martin Kepplinger <martink@posteo.de>
>> Tested-by: Martin Kepplinger <martink@posteo.de>
>> ---
>>  drivers/acpi/video.c |    8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
>> index f8bc5a7..acb0670 100644
>> --- a/drivers/acpi/video.c
>> +++ b/drivers/acpi/video.c
>> @@ -528,6 +528,14 @@ static struct dmi_system_id video_dmi_table[] __initdata = {
>>  		},
>>  	},
>>  	{
>> +	 .callback = video_set_use_native_backlight,
>> +	 .ident = "Acer TravelMate B113",
>> +	 .matches = {
>> +		DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
>> +		DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate B113"),
>> +		},
>> +	},
>> +	{
>>  	.callback = video_set_use_native_backlight,
>>  	.ident = "HP ProBook 4340s",
>>  	.matches = {
>>
> 
> are there objections or advice on this? this would be really good to
> have, even if for 3.17.

For v3.16, we already have this commit to make use_native_backlight
equal to 1 by default:

commit 751109aad5834375ca9ed0dcfcd85a00cbf872b5
Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Date:   Thu Jun 5 22:47:35 2014 +0200

    ACPI / video: Change the default for video.use_native_backlight to 1


Thanks,
Aaron

> 
> thanks.
>                                 martin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

