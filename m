Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260AbaCYKWX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 06:22:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414AbaCYKWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 06:22:21 -0400
Message-ID: <533158CF.9040303@redhat.com>
Date: Tue, 25 Mar 2014 11:22:07 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>, gleb@kernel.org
CC: avi.kivity@gmail.com, mtosatti@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v4 0/5] KVM: x86: flush tlb out of mmu-lock after write
 protection
References: <1394460109-3150-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <5330F82D.4070601@linux.vnet.ibm.com>
In-Reply-To: <5330F82D.4070601@linux.vnet.ibm.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 25/03/2014 04:29, Xiao Guangrong ha scritto:
> Ping......

Hi Xiao, I'll look at these patches soon.  I plan to merge them for 3.16.

Paolo

> On 03/10/2014 10:01 PM, Xiao Guangrong wrote:
>> This patchset is splited from my previous patchset:
>> [PATCH v3 00/15] KVM: MMU: locklessly write-protect
>> that can be found at:
>> https://lkml.org/lkml/2013/10/23/265
>>
>> Changelog v4 :
>> - add more comments for patch 5 and thank for Marcelo's review
>>
>> Xiao Guangrong (5):
>>   Revert "KVM: Simplify kvm->tlbs_dirty handling"
>>   KVM: MMU: properly check last spte in fast_page_fault()
>>   KVM: MMU: lazily drop large spte
>>   KVM: MMU: flush tlb if the spte can be locklessly modified
>>   KVM: MMU: flush tlb out of mmu lock when write-protect the sptes
>>
>>  arch/x86/kvm/mmu.c         | 72 ++++++++++++++++++++++++++++++----------------
>>  arch/x86/kvm/mmu.h         | 14 +++++++++
>>  arch/x86/kvm/paging_tmpl.h |  7 ++---
>>  arch/x86/kvm/x86.c         | 20 ++++++++++---
>>  include/linux/kvm_host.h   |  4 +--
>>  virt/kvm/kvm_main.c        |  5 +++-
>>  6 files changed, 85 insertions(+), 37 deletions(-)
>>
>

