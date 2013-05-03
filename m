Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762435Ab3ECF6F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 01:58:05 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:41210 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756473Ab3ECF6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 01:58:03 -0400
Message-ID: <518351D2.9050806@linux.vnet.ibm.com>
Date: Fri, 03 May 2013 13:57:38 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
CC: mtosatti@redhat.com, gleb@redhat.com, avi.kivity@gmail.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v4 3/6] KVM: MMU: introduce kvm_clear_all_lpage_info
References: <1367032402-13729-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1367032402-13729-4-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130503111531.b288fca3287c5f892436ade4@gmail.com>
In-Reply-To: <20130503111531.b288fca3287c5f892436ade4@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050305-7014-0000-0000-000002F1C188
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2013 10:15 AM, Takuya Yoshikawa wrote:
> On Sat, 27 Apr 2013 11:13:19 +0800
> Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:
> 
>> This function is used to reset the large page info of all guest pages
>> which will be used in later patch
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>> ---
>>  arch/x86/kvm/x86.c |   25 +++++++++++++++++++++++++
>>  arch/x86/kvm/x86.h |    2 ++
>>  2 files changed, 27 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 52b4e97..8e4494c 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -6951,6 +6951,31 @@ static void memslot_set_lpage_disallowed(struct kvm_memory_slot *slot,
>>  	}
>>  }
>>  
>> +static void clear_memslot_lpage_info(struct kvm_memory_slot *slot)
>> +{
>> +	int i;
>> +
>> +	for (i = 1; i < KVM_NR_PAGE_SIZES; ++i) {
>> +		int lpages;
>> +		int level = i + 1;
>> +
>> +		lpages = gfn_to_index(slot->base_gfn + slot->npages - 1,
>> +				      slot->base_gfn, level) + 1;
>> +
>> +		memset(slot->arch.lpage_info[i - 1], 0,
>> +		       sizeof(*slot->arch.lpage_info[i - 1]));
>> +		memslot_set_lpage_disallowed(slot, slot->npages, i, lpages);
> 
> This does something other than clearing.

Aha, this API *clears* the count set by kvm mmu. It is meaningful enough,
i think.



