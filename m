Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291Ab3A2C6J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 21:58:09 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:47267 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008Ab3A2C6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 21:58:08 -0500
Message-ID: <51073AB7.3050207@linux.vnet.ibm.com>
Date: Tue, 29 Jan 2013 10:57:59 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi.kivity@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 01/12] KVM: MMU: lazily drop large spte
References: <50FFB5A1.5090708@linux.vnet.ibm.com> <20130127120657.GA21650@redhat.com>
In-Reply-To: <20130127120657.GA21650@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012902-5564-0000-0000-00000665EDF4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2013 08:06 PM, Gleb Natapov wrote:
> On Wed, Jan 23, 2013 at 06:04:17PM +0800, Xiao Guangrong wrote:
>> Do not drop large spte until it can be insteaded by small pages so that
>> the guest can happliy read memory through it
>>
>> The idea is from Avi:
>> | As I mentioned before, write-protecting a large spte is a good idea,
>> | since it moves some work from protect-time to fault-time, so it reduces
>> | jitter.  This removes the need for the return value.
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>> ---
>>  arch/x86/kvm/mmu.c |   21 ++++++---------------
>>  1 files changed, 6 insertions(+), 15 deletions(-)
>>
>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>> index 9f628f7..0f90269 100644
>> --- a/arch/x86/kvm/mmu.c
>> +++ b/arch/x86/kvm/mmu.c
>> @@ -1105,7 +1105,7 @@ static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)
>>
>>  /*
>>   * Write-protect on the specified @sptep, @pt_protect indicates whether
>> - * spte writ-protection is caused by protecting shadow page table.
>> + * spte write-protection is caused by protecting shadow page table.
>>   * @flush indicates whether tlb need be flushed.
>>   *
>>   * Note: write protection is difference between drity logging and spte
>> @@ -1114,31 +1114,23 @@ static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)
>>   *   its dirty bitmap is properly set.
>>   * - for spte protection, the spte can be writable only after unsync-ing
>>   *   shadow page.
>> - *
>> - * Return true if the spte is dropped.
>>   */
>> -static bool
>> +static void
>>  spte_write_protect(struct kvm *kvm, u64 *sptep, bool *flush, bool pt_protect)
> Since return value is not longer used make the function return true if flush is needed
> instead of returning it via pointer to a variable.

Right, i forgot to check it, will update it in the next version. Thanks for your pointing
it out.


