Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbaAOPGr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 10:06:47 -0500
Received: from mga01.intel.com ([192.55.52.88]:44282 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037AbaAOPGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 10:06:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,663,1384329600"; 
   d="scan'208";a="465570359"
Message-ID: <52D6A3FF.8070100@intel.com>
Date: Wed, 15 Jan 2014 23:06:39 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>, lenb@kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        fcr@adinet.com.uy, l@dorileo.org, "Zheng, Lv" <lv.zheng@intel.com>,
        robert.moore@intel.com
Subject: Re: [PATCH V2] ACPI/Battery: Add a _BIX quirk for NEC LZ750/LS
References: <1389019837-13619-1-git-send-email-tianyu.lan@intel.com> <5255063.SeYbBZqxVQ@vostro.rjw.lan> <20140114212406.GA25438@srcf.ucam.org> <4100200.O09E65sAKi@vostro.rjw.lan> <52D69E57.5020208@intel.com> <20140115144720.GA23218@srcf.ucam.org>
In-Reply-To: <20140115144720.GA23218@srcf.ucam.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2014 10:47 PM, Matthew Garrett wrote:
> On Wed, Jan 15, 2014 at 10:42:31PM +0800, Lan Tianyu wrote:
>> diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
>> index fbf1ace..e98fa83 100644
>> --- a/drivers/acpi/battery.c
>> +++ b/drivers/acpi/battery.c
>> @@ -770,7 +770,7 @@ static int acpi_battery_add(struct acpi_device *device)
>>          device->driver_data = battery;
>>          mutex_init(&battery->lock);
>>          mutex_init(&battery->sysfs_lock);
>> -       if (acpi_has_method(battery->device->handle, "_BIX"))
>> +       if (acpi_evaluate_object(device->handle, "_BIX", NULL, &buffer);)
>>                  set_bit(ACPI_BATTERY_XINFO_PRESENT, &battery->flags);
>
> Doesn't acpi_evaluate_object() return 0 on success? I think:
>
> if (ACPI_SUCESS(acpi_evaluate_object(device->handle, "_BIX", NULL,
> &buffer))
>

Yes, Sorry for oops.

> But maybe we should check for existence first and give an FW_BUG message
> to indicate an invalid _BIX?

Yes, this is a good idea.

Another point, the acpi_evaluate_object should return different error 
code for these two cases(no _BIX and wrong size.). I wonder whether we 
can use the error code to determine it belong which case?
>


-- 
Best Regards
Tianyu Lan
