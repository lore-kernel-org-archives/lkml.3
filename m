Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631AbaH2Ofy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 10:35:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642AbaH2Ofx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 10:35:53 -0400
Message-ID: <54008FC5.2060408@redhat.com>
Date: Fri, 29 Aug 2014 16:35:49 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: forward declare structs in kvm_types.h
References: <1409313707-7791-1-git-send-email-pbonzini@redhat.com> <20140829124657.GA8674@potion.brq.redhat.com>
In-Reply-To: <20140829124657.GA8674@potion.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 29/08/2014 14:46, Radim Krčmář ha scritto:
> 2014-08-29 14:01+0200, Paolo Bonzini:
>> Opaque KVM structs are useful for prototypes in asm/kvm_host.h, to avoid
>> "'struct foo' declared inside parameter list" warnings (and consequent
>> breakage due to conflicting types).
>>
>> Move them from individual files to a generic place in linux/kvm_types.h.
>>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
> 
> Reviewed-by: Radim Krčmář <rkrcmar@redhat.com>
> 
> (Inclusion of <linux/types.h> seems to be piggybacking, but is a nice
>  thing to do :)

I just wasn't sure if including linux/kvm_types.h was enough alone.

> And I'd apply these changes:  (Definitely the first hunk.)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 33d8d0a..e098dce 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -140,8 +140,6 @@ static inline bool is_error_page(struct page *page)
>  #define KVM_USERSPACE_IRQ_SOURCE_ID		0
>  #define KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID	1
>  
> -struct kvm;
> -struct kvm_vcpu;
>  extern struct kmem_cache *kvm_vcpu_cache;
>  
>  extern spinlock_t kvm_lock;
> @@ -325,8 +323,6 @@ struct kvm_kernel_irq_routing_entry {
>  	struct hlist_node link;
>  };
>  
> -struct kvm_irq_routing_table;
> -
>  #ifndef KVM_PRIVATE_MEM_SLOTS
>  #define KVM_PRIVATE_MEM_SLOTS 0
>  #endif
> @@ -1036,8 +1032,6 @@ static inline bool kvm_check_request(int req, struct kvm_vcpu *vcpu)
>  
>  extern bool kvm_rebooting;
>  
> -struct kvm_device_ops;
> -
>  struct kvm_device {
>  	struct kvm_device_ops *ops;
>  	struct kvm *kvm;
> diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> index 1d6daca..53c4f20 100644
> --- a/include/linux/kvm_types.h
> +++ b/include/linux/kvm_types.h
> @@ -19,7 +19,9 @@
>  
>  struct kvm;
>  struct kvm_async_pf;
> +struct kvm_device_ops;
>  struct kvm_interrupt;
> +struct kvm_irq_routing_table;
>  struct kvm_memory_slot;
>  struct kvm_one_reg;
>  struct kvm_run;
> 

Good idea, thanks.

Paolo
