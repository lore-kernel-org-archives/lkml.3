Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab3JQMWA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 08:22:00 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:45980 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052Ab3JQMV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 08:21:58 -0400
Message-ID: <525FD631.5080109@linux.vnet.ibm.com>
Date: Thu, 17 Oct 2013 17:51:05 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: tony.luck@intel.com, bp@alien8.de, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2/8] ACPI, CPER: Update cper info
References: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com> <1381473166-29303-3-git-send-email-gong.chen@linux.intel.com> <20131015181723.GC2777@naverao1-tp.ibm.com> <20131016013902.GB6898@gchen.bj.intel.com>
In-Reply-To: <20131016013902.GB6898@gchen.bj.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101712-7014-0000-0000-000003C8AFCA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2013 07:09 AM, Chen Gong wrote:
> On Tue, Oct 15, 2013 at 11:47:23PM +0530, Naveen N. Rao wrote:
>> Date: Tue, 15 Oct 2013 23:47:23 +0530
>> From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
>> To: "Chen, Gong" <gong.chen@linux.intel.com>
>> Cc: tony.luck@intel.com, bp@alien8.de, linux-kernel@vger.kernel.org,
>>   linux-acpi@vger.kernel.org
>> Subject: Re: [PATCH 2/8] ACPI, CPER: Update cper info
>> User-Agent: Mutt/1.5.21 (2010-09-15)
>>
>> On 2013/10/11 02:32AM, Chen Gong wrote:
>>> To satisfy the necessary of following patches and make related definition
>>> more clear, update some definitions about CPER. No functional changes.
>>>
>>> Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
>>> ---
>>>   drivers/acpi/apei/apei-internal.h | 12 ++++-----
>>>   drivers/acpi/apei/cper.c          | 46 ++++++++++++++++-----------------
>>>   drivers/acpi/apei/ghes.c          | 54 +++++++++++++++++++--------------------
>>>   include/acpi/actbl1.h             | 14 +++++-----
>>>   include/acpi/ghes.h               |  2 +-
>>>   5 files changed, 64 insertions(+), 64 deletions(-)
>>>
>>> diff --git a/drivers/acpi/apei/apei-internal.h b/drivers/acpi/apei/apei-internal.h
>>> index f220d64..21ba34a 100644
>>> --- a/drivers/acpi/apei/apei-internal.h
>>> +++ b/drivers/acpi/apei/apei-internal.h
>>> @@ -122,11 +122,11 @@ struct dentry;
>>>   struct dentry *apei_get_debugfs_dir(void);
>>>
>>>   #define apei_estatus_for_each_section(estatus, section)			\
>>> -	for (section = (struct acpi_hest_generic_data *)(estatus + 1);	\
>>> +	for (section = (struct acpi_generic_data *)(estatus + 1);	\
>>
>> This is a good one to rename, though I wonder if acpi_generic_error_data
>> is more appropriate?
>>
>>>   	     (void *)section - (void *)estatus < estatus->data_length;	\
>>>   	     section = (void *)(section+1) + section->error_data_length)
>>>
>>> -static inline u32 apei_estatus_len(struct acpi_hest_generic_status *estatus)
>>> +static inline u32 cper_estatus_len(struct acpi_generic_status *estatus)
>>
>> Not sure I understand the rationale for these changes - we are still
>> dealing with ACPI/APEI generic error status/data structures. So, why
>> the cper_ prefix?
>>
>
> Because CPER is not APEI specific, beside APEI, some others like eMCA
> needs this.

Right, but even the document you point to refers to these structures as 
what they are: ACPI Generic error status/data. Clearly, CPER is an 
incorrect prefix here since CPER/UEFI does *not* seem to have the same 
structure format.


Regards,
Naveen

