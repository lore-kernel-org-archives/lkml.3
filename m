Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbaBTCK6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 21:10:58 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:54666 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbaBTCK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 21:10:56 -0500
Message-ID: <53056429.8030705@linaro.org>
Date: Thu, 20 Feb 2014 10:10:49 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Sudeep Holla <Sudeep.Holla@arm.com>, Lan Tianyu <tianyu.lan@intel.com>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Linaro-acpi] [PATCH v4 5/5] ACPI: Replace printk with pr_* in
 tables.c
References: <1392731700-10992-1-git-send-email-hanjun.guo@linaro.org> <2341500.Z47JjkFCMP@vostro.rjw.lan> <5304DFDB.6020202@arm.com> <1624648.FYgVXnCCsW@vostro.rjw.lan>
In-Reply-To: <1624648.FYgVXnCCsW@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年02月20日 08:37, Rafael J. Wysocki wrote:
> On Wednesday, February 19, 2014 04:46:19 PM Sudeep Holla wrote:
>> On 19/02/14 16:49, Rafael J. Wysocki wrote:
>>> On Wednesday, February 19, 2014 04:32:34 PM Sudeep Holla wrote:
>>>> On 18/02/14 13:55, Hanjun Guo wrote:
>>>>> This patch just do some clean up to replace printk with pr_*,
>>>>> no functional change.
>>>>>
>>>> Any particular reason for choosing just this file in this series ?

Yes, the reason is that I will update this file in my next patch set 
(ARM64 ACPI core) with
pr_*, in order to keep  consistency, I updated them all in this file first.

>>>> It seems but off-topic in this series. The printk format is same in almost all
>>>> other acpi files and it's better to change all or none for consistency.
>>> Well, it's fine, I can put it into a different branch in any case. :-)
>>>
>>>>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
>>>>> ---
>>>>>   drivers/acpi/tables.c |   51 +++++++++++++++++++------------------------------
>>>>>   1 file changed, 20 insertions(+), 31 deletions(-)
>>>>>
>>>>> diff --git a/drivers/acpi/tables.c b/drivers/acpi/tables.c
>>>>> index 5837f85..97bc6df 100644
>>>>> --- a/drivers/acpi/tables.c
>>>>> +++ b/drivers/acpi/tables.c
>>>>> @@ -55,8 +55,7 @@ void acpi_table_print_madt_entry(struct acpi_subtable_header *header)
>>>>>   		{
>>>>>   			struct acpi_madt_local_apic *p =
>>>>>   			    (struct acpi_madt_local_apic *)header;
>>>>> -			printk(KERN_INFO PREFIX
>>>>> -			       "LAPIC (acpi_id[0x%02x] lapic_id[0x%02x] %s)\n",
>>>>> +			pr_info(PREFIX "LAPIC (acpi_id[0x%02x] lapic_id[0x%02x] %s)\n",
>>>> You can even get rid of PREFIX by defining pr_fmt instead.
>>> But this is a good point.
>>>
>>>> If the intention is to move to pr_* format it's better to have this as separate
>>>> patch and convert all of them.
>>> Well, not really.  One file at a time is OK too.
>>>
>> No what I meant was to convert all for consistency, not in a single patch.
>> As I was playing with regex for few minutes, with few patterns was able to fix
>> most(not all) of them. It even compiles :) for x86. But turns out to be a big
>> churn :( [43 files changed, 253 insertions(+), 329 deletions(-)]
> Well, precisely.  That's why I'd prefer doing that gradually.
>
> That said I'll just drop the patch for now due to the PREFIX thing.

I will update this patch accordingly and send it out soon.

Thanks
Hanjun
