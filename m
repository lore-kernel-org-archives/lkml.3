Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab3CRIal (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 04:30:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:32757 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752229Ab3CRIaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 04:30:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,863,1355126400"; 
   d="scan'208";a="304358332"
Message-ID: <5146D0E3.60401@intel.com>
Date: Mon, 18 Mar 2013 16:31:31 +0800
From: Aaron Lu <aaron.lu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Danny Baumann <dannybaumann@web.de>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH v2 1/3] ACPI video: Fix brightness control initialization
 for some laptops.
References: <1363342248-6496-1-git-send-email-dannybaumann@web.de> <5146C1B4.4050907@intel.com> <5146CEBE.3070909@web.de>
In-Reply-To: <5146CEBE.3070909@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2013 04:22 PM, Danny Baumann wrote:
> Hi,
> 
>>> diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
>>> index 313f959..9c33871 100644
>>> --- a/drivers/acpi/video.c
>>> +++ b/drivers/acpi/video.c
>>> @@ -222,7 +222,7 @@ static int acpi_video_device_lcd_set_level(struct acpi_video_device *device,
>>>   			int level);
>>>   static int acpi_video_device_lcd_get_level_current(
>>>   			struct acpi_video_device *device,
>>> -			unsigned long long *level, int init);
>>> +			unsigned long long *level, int raw);
>>
>> Why not bool?
> 
> For two reasons:
> - It previous was int ;-)

Right, but since we are doing something now, we can probably change it
for better :-)

> - It allowed the invocations of this function to fit within one 80-char 
> line.

the unsigned long long for level made me curious, do we really need that?
int would suffice I think.

> 
> Neither reason is terribly strong, so if you prefer, I can convert this 
> argument to bool.

It's OK, I can do the cleaup some time later.

Thanks,
Aaron

