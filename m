Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577AbaBSQp5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 11:45:57 -0500
Received: from service87.mimecast.com ([91.220.42.44]:58838 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021AbaBSQpy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 11:45:54 -0500
Message-ID: <5304DFDB.6020202@arm.com>
Date: Wed, 19 Feb 2014 16:46:19 +0000
From: Sudeep Holla <Sudeep.Holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Sudeep.Holla@arm.com, Hanjun Guo <hanjun.guo@linaro.org>,
        Lan Tianyu <tianyu.lan@intel.com>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Linaro-acpi] [PATCH v4 5/5] ACPI: Replace printk with pr_* in
 tables.c
References: <1392731700-10992-1-git-send-email-hanjun.guo@linaro.org> <1392731700-10992-6-git-send-email-hanjun.guo@linaro.org> <5304DCA2.5080906@arm.com> <2341500.Z47JjkFCMP@vostro.rjw.lan>
In-Reply-To: <2341500.Z47JjkFCMP@vostro.rjw.lan>
X-OriginalArrivalTime: 19 Feb 2014 16:45:54.0993 (UTC) FILETIME=[0E919210:01CF2D92]
X-MC-Unique: 114021916455202101
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/02/14 16:49, Rafael J. Wysocki wrote:
> On Wednesday, February 19, 2014 04:32:34 PM Sudeep Holla wrote:
>> On 18/02/14 13:55, Hanjun Guo wrote:
>>> This patch just do some clean up to replace printk with pr_*,
>>> no functional change.
>>>
>> Any particular reason for choosing just this file in this series ?
>> It seems but off-topic in this series. The printk format is same in almost all
>> other acpi files and it's better to change all or none for consistency.
> 
> Well, it's fine, I can put it into a different branch in any case. :-)
> 
>>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
>>> ---
>>>  drivers/acpi/tables.c |   51 +++++++++++++++++++------------------------------
>>>  1 file changed, 20 insertions(+), 31 deletions(-)
>>>
>>> diff --git a/drivers/acpi/tables.c b/drivers/acpi/tables.c
>>> index 5837f85..97bc6df 100644
>>> --- a/drivers/acpi/tables.c
>>> +++ b/drivers/acpi/tables.c
>>> @@ -55,8 +55,7 @@ void acpi_table_print_madt_entry(struct acpi_subtable_header *header)
>>>  		{
>>>  			struct acpi_madt_local_apic *p =
>>>  			    (struct acpi_madt_local_apic *)header;
>>> -			printk(KERN_INFO PREFIX
>>> -			       "LAPIC (acpi_id[0x%02x] lapic_id[0x%02x] %s)\n",
>>> +			pr_info(PREFIX "LAPIC (acpi_id[0x%02x] lapic_id[0x%02x] %s)\n",
>>
>> You can even get rid of PREFIX by defining pr_fmt instead.
> 
> But this is a good point.
> 
>> If the intention is to move to pr_* format it's better to have this as separate
>> patch and convert all of them.
> 
> Well, not really.  One file at a time is OK too.
> 
No what I meant was to convert all for consistency, not in a single patch.
As I was playing with regex for few minutes, with few patterns was able to fix
most(not all) of them. It even compiles :) for x86. But turns out to be a big
churn :( [43 files changed, 253 insertions(+), 329 deletions(-)]

Regards,
Sudeep


