Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669Ab3EPSlI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 14:41:08 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:46130 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab3EPSlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 14:41:06 -0400
Message-ID: <51952839.1090902@linux.vnet.ibm.com>
Date: Fri, 17 May 2013 02:40:57 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v5 3/8] KVM: MMU: fast invalidate all pages
References: <1368706673-8530-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1368706673-8530-4-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130516161816.GG14597@redhat.com>
In-Reply-To: <20130516161816.GG14597@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051618-6102-0000-0000-00000389A0F3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2013 12:18 AM, Gleb Natapov wrote:

>> +
>> +/*
>> + * Fast invalidate all shadow pages belong to @slot.
>> + *
>> + * @slot != NULL means the invalidation is caused the memslot specified
>> + * by @slot is being deleted, in this case, we should ensure that rmap
>> + * and lpage-info of the @slot can not be used after calling the function.
>> + *
>> + * @slot == NULL means the invalidation due to other reasons, we need
>> + * not care rmap and lpage-info since they are still valid after calling
>> + * the function.
>> + */
>> +void kvm_mmu_invalidate_memslot_pages(struct kvm *kvm,
>> +				      struct kvm_memory_slot *slot)
> 
> Why pass "slot" here? If we want the function to sometimes wait for purge
> and sometimes not the more straightforward way is to have a "bool wait"
> parameter instead.
> 

That's my fault, i forgot to update it. Will use 'bool zap_invalid_pages'
instead.

