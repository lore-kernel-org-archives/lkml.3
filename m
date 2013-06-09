Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab3FIJIn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 05:08:43 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:50814 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab3FIJIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 05:08:41 -0400
Message-ID: <51B44612.6080704@gmail.com>
Date: Sun, 09 Jun 2013 17:08:34 +0800
From: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: fix missed memory synchronization when patch
 hypercall
References: <51B2A1D9.6060306@gmail.com> <20130609084526.GH4725@redhat.com> <51B4434A.2010402@gmail.com> <20130609085937.GJ4725@redhat.com>
In-Reply-To: <20130609085937.GJ4725@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2013 04:59 PM, Gleb Natapov wrote:
> On Sun, Jun 09, 2013 at 04:56:42PM +0800, Xiao Guangrong wrote:
>> On 06/09/2013 04:45 PM, Gleb Natapov wrote:
>>> On Sat, Jun 08, 2013 at 11:15:37AM +0800, Xiao Guangrong wrote:
>>>> From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>>>>
>>>> Currently, memory synchronization is missed in emulator_fix_hypercall,
>>>> please see the commit 758ccc89b83
>>>> (KVM: x86: drop calling kvm_mmu_zap_all in emulator_fix_hypercall)
>>>>
>>>> This patch fixes it by introducing kvm_vcpus_hang_on_page_start() and
>>>> kvm_vcpus_hang_on_page_end which unmap the patched page from guest
>>>> and use kvm_flush_remote_tlbs() as the serializing instruction to
>>>> ensure the memory coherence
>>>> [ The SDM said that INVEPT, INVVPID and MOV (to control register, with
>>>>   the exception of MOV CR8) are the serializing instructions. ]
>>>>
>>>> The mmu-lock is held during host patches the page so that it stops vcpus
>>>> to fix its further page fault
>>>>
>>> I have a patch to implement is much simple and in generic way, not
>>> relying on MMU internals.
>>
>> I have considered this way but it seems not simple - it needs a new type of
>> request and it forces all vcpus to hang when host is patching the page.
>>
>> My approach is just reusing the mmu code and requires vcpus to hang only when
>> the patched page is bing accessed.
> 
> That's very rare, no point to optimize this code path.

Fine to me. I do not have strong opinion on that, please apply your patch instead. ;)



