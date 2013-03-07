Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759872Ab3CGVhH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 16:37:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7637 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752764Ab3CGVhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 16:37:04 -0500
Message-ID: <51390850.4080400@redhat.com>
Date: Thu, 07 Mar 2013 16:36:16 -0500
From: Don Dutile <ddutile@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120601 Thunderbird/10.0.5
MIME-Version: 1.0
To: "Li, Zhen-Hua" <zhen-hual@hp.com>, iommu@lists.linux-foundation.org
CC: Hannes Reinecke <hare@suse.de>, Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 1/1] iommu: add a dma remap fault reason.
References: <1362537797-6034-1-git-send-email-zhen-hual@hp.com> <5138DCE9.1010204@redhat.com>
In-Reply-To: <5138DCE9.1010204@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2013 01:31 PM, Don Dutile wrote:
> cc-ing the upstream iommu-list
>
> On 03/05/2013 09:43 PM, Li, Zhen-Hua wrote:
>> The number of dma fault reasons in intel's document are from 1 to 0xD, but in dmar.c I cannot find fault reason 0xD.
>>
>> In this document:
>> Intel Virtualization Technology for Directed I/O Architecture Specification
>> http://download.intel.com/technology/computing/vptech/Intel(r)_VT_for_Direct_IO.pdf
>>
>> Chapter 4. Support For Device-IOTLBs
>>
>> Table 6. Unsuccessful Translated Requests
>>
>> There is fault reason for 0xD not listed in kernel:
>> Present context-entry used to process translation request
>> specifies blocking of Translation Requests (Translation Type (T)
>> field value not equal to 01b).
>>
>> So I think 0xD should be added.
>>
>> Signed-off-by: Li, Zhen-Hua<zhen-hual@hp.com>
>> ---
>> drivers/iommu/dmar.c | 1 +
>> 1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
>> index dc7e478..e5cdaf8 100644
>> --- a/drivers/iommu/dmar.c
>> +++ b/drivers/iommu/dmar.c
>> @@ -1083,6 +1083,7 @@ static const char *dma_remap_fault_reasons[] =
>> "non-zero reserved fields in RTP",
>> "non-zero reserved fields in CTP",
>> "non-zero reserved fields in PTE",
>> + "PCE for translation request specifies blocking",
>> };
>>
>> static const char *irq_remap_fault_reasons[] =
>

Yes, the multiple tables, some short, some long, duplicating error codes,
and in this case, putting it out of order, helped this case!

btw -- Suresh not at intel any longer (email bounces)

So, patch looks good to me. Although, I don't know of any code that
actually sets a translation to 'block translation'.... but
for completeness, rest of code does range checking & sizing such
that it's doing the right thing.
The only other thing I can surmize from the dmar.c file is if one
of these faults occurred, an 'unknown error' would have been outputted.

cheers.. Don
> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/iommu

