Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbaF3IBa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 04:01:30 -0400
Received: from mx02.posteo.de ([89.146.194.165]:48164 "EHLO posteo.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751125AbaF3IB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 04:01:28 -0400
Message-ID: <53B1192B.7020904@posteo.de>
Date: Mon, 30 Jun 2014 10:00:43 +0200
From: Martin Kepplinger <martink@posteo.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Icedove/24.6.0
MIME-Version: 1.0
To: Aaron Lu <aaron.lu@intel.com>, rui.zhang@intel.com
CC: rjw@rjwysocki.net, lenb@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix backlight control for Acer TravelMate B113
References: <1403555446-16863-1-git-send-email-martink@posteo.de> <53AFD16D.10209@posteo.de> <53B0BD92.8090209@intel.com>
In-Reply-To: <53B0BD92.8090209@intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2014-06-30 03:29, schrieb Aaron Lu:
> On 06/29/2014 04:42 PM, Martin Kepplinger wrote:
>> Am 2014-06-23 22:30, schrieb Martin Kepplinger:
>>> Fix backlight control for Acer TravelMate B113 Laptop by adding
>>> it to the video_dmi_table.
>>>
>>> A workaround before that was to use acpi_osi=Linux or
>>> acpi_backlight=vendor on boot but even then, only the function-
>>> keys worked.
>>>
>>> With this change there is no need for boot parameters and DE's
>>> controls work as well.
>>>
>>> Signed-off-by: Martin Kepplinger <martink@posteo.de>
>>> Tested-by: Martin Kepplinger <martink@posteo.de>
>>> ---
>>>  drivers/acpi/video.c |    8 ++++++++
>>>  1 file changed, 8 insertions(+)
>>>
>>> diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
>>> index f8bc5a7..acb0670 100644
>>> --- a/drivers/acpi/video.c
>>> +++ b/drivers/acpi/video.c
>>> @@ -528,6 +528,14 @@ static struct dmi_system_id video_dmi_table[] __initdata = {
>>>  		},
>>>  	},
>>>  	{
>>> +	 .callback = video_set_use_native_backlight,
>>> +	 .ident = "Acer TravelMate B113",
>>> +	 .matches = {
>>> +		DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
>>> +		DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate B113"),
>>> +		},
>>> +	},
>>> +	{
>>>  	.callback = video_set_use_native_backlight,
>>>  	.ident = "HP ProBook 4340s",
>>>  	.matches = {
>>>
>>
>> are there objections or advice on this? this would be really good to
>> have, even if for 3.17.
> 
> For v3.16, we already have this commit to make use_native_backlight
> equal to 1 by default:
> 
> commit 751109aad5834375ca9ed0dcfcd85a00cbf872b5
> Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Date:   Thu Jun 5 22:47:35 2014 +0200
> 
>     ACPI / video: Change the default for video.use_native_backlight to 1
> 
> 
> Thanks,
> Aaron
> 
thanks! That should do it and would be a better solution. I can't test
it on 3.16 though, as rc3 is still broken for me, see
https://lkml.org/lkml/2014/6/30/66

>>
>> thanks.
>>                                 martin
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

