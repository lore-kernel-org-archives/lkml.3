Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751617Ab3KNFPk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 00:15:40 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:55758 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab3KNFPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 00:15:35 -0500
Message-ID: <52845C6C.6060708@linux.vnet.ibm.com>
Date: Thu, 14 Nov 2013 13:15:24 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: gleb@redhat.com, avi.kivity@gmail.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 04/15] KVM: MMU: flush tlb out of mmu lock when write-protect
 the sptes
References: <1382534973-13197-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1382534973-13197-5-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20131114003609.GA15692@amt.cnet>
In-Reply-To: <20131114003609.GA15692@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111405-1396-0000-0000-000003DF5001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Marcelo,

On 11/14/2013 08:36 AM, Marcelo Tosatti wrote:

> 
> Any code location which reads the writable bit in the spte and assumes if its not
> set, that the translation which the spte refers to is not cached in a
> remote CPU's TLB can become buggy. (*)
> 
> It might be the case that now its not an issue, but its so subtle that
> it should be improved.
> 
> Can you add a fat comment on top of is_writeable_bit describing this?
> (and explain why is_writable_pte users do not make an assumption
> about (*). 
> 
> "Writeable bit of locklessly modifiable sptes might be cleared
> but TLBs not flushed: so whenever reading locklessly modifiable sptes
> you cannot assume TLBs are flushed".
> 
> For example this one is unclear:
> 
>                 if (!can_unsync && is_writable_pte(*sptep))
>                         goto set_pte;
> And:
> 
>         if (!is_writable_pte(spte) &&
>               !(pt_protect && spte_is_locklessly_modifiable(spte)))
>                 return false;
> 
> This is safe because get_dirty_log/kvm_mmu_slot_remove_write_access are
> serialized by a single mutex (if there were two mutexes, it would not be
> safe). Can you add an assert to both
> kvm_mmu_slot_remove_write_access/kvm_vm_ioctl_get_dirty_log 
> for (slots_lock) is locked, and explain?
> 
> So just improve the comments please, thanks (no need to resend whole
> series).

Thank you very much for your time to review it and really appreciate
for you detailed the issue so clearly to me.

I will do it on the top of this patchset or after it is merged
(if it's possiable).




