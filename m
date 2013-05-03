Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545Ab3ECGA7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 02:00:59 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:50110 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759711Ab3ECGA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 02:00:58 -0400
Message-ID: <51835291.20400@linux.vnet.ibm.com>
Date: Fri, 03 May 2013 14:00:49 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
CC: mtosatti@redhat.com, gleb@redhat.com, avi.kivity@gmail.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v4 4/6] KVM: MMU: fast invalid all shadow pages
References: <1367032402-13729-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1367032402-13729-5-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130503112729.942a04b2ba2566b35328f49e@gmail.com>
In-Reply-To: <20130503112729.942a04b2ba2566b35328f49e@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050305-0260-0000-0000-000002E71BE1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2013 10:27 AM, Takuya Yoshikawa wrote:
> On Sat, 27 Apr 2013 11:13:20 +0800
> Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:
> 
>> +/*
>> + * Fast invalid all shadow pages belong to @slot.
>> + *
>> + * @slot != NULL means the invalidation is caused the memslot specified
>> + * by @slot is being deleted, in this case, we should ensure that rmap
>> + * and lpage-info of the @slot can not be used after calling the function.
>> + *
>> + * @slot == NULL means the invalidation due to other reasons, we need
> 
> The comment should explain what the "other reasons" are.
> But this API may better be split into two separate functions; it depends
> on the "other reasons".

NO.

> 
>> + * not care rmap and lpage-info since they are still valid after calling
>> + * the function.
>> + */
>> +void kvm_mmu_invalid_memslot_pages(struct kvm *kvm,
>> +				   struct kvm_memory_slot *slot)
> 
> You yourself is explaining this as "invalidation" in the comment.
> kvm_mmu_invalidate_shadow_pages_memslot() or something...

Umm, invalidate is a better name. Will update after collecting Marcelo, Gleb
and other guy's comments.

