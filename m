Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185AbaLEH1M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 02:27:12 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:65132 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbaLEH1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 02:27:10 -0500
Message-ID: <54815E48.3000008@redhat.com>
Date: Fri, 05 Dec 2014 08:27:04 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.comp.emulators.kvm.devel
To: Wanpeng Li <wanpeng.li@linux.intel.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, rkrcmar@redhat.com
Subject: Re: [PATCH 0/9] Final set of XSAVES patches
References: <1417708634-24333-1-git-send-email-pbonzini@redhat.com> <20141205011501.GA2683@kernel>
In-Reply-To: <20141205011501.GA2683@kernel>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 05/12/2014 02:15, Wanpeng Li wrote:
> Hi Paolo,
> On Thu, Dec 04, 2014 at 04:57:05PM +0100, Paolo Bonzini wrote:
>> These are all the patches needed to support XSAVES.
>>
> 
> I think you miss to add your patch "kvm: x86: mask out XSAVES" to 
> this patchset,

That one is already on kvm/next, so it is more or less frozen.

> I test the whole patchset w/ that patch applied on 
> skylake-client machine, and it looks good, please feel free to add 
> my tested-by to this patchset.
> 
> Tested-by: Wanpeng Li <wanpeng.li@linux.intel.com>

Awesome, thanks!

Paolo

>> Paolo Bonzini (5):
>>  x86: export get_xsave_addr
>>  KVM: x86: support XSAVES usage in the host
>>  KVM: x86: use F() macro throughout cpuid.c
>>  KVM: cpuid: set CPUID(EAX=0xd,ECX=1).EBX correctly
>>  KVM: cpuid: mask more bits in leaf 0xd and subleaves
>>
>> Wanpeng Li (4):
>>  kvm: x86: Add kvm_x86_ops hook that enables XSAVES for guest
>>  kvm: x86: handle XSAVES vmcs and vmexit
>>  kvm: vmx: add MSR logic for XSAVES
>>  kvm: vmx: add nested virtualization support for xsaves
>>
>> arch/x86/include/asm/kvm_host.h |  2 +
>> arch/x86/include/asm/vmx.h      |  3 ++
>> arch/x86/include/uapi/asm/vmx.h |  6 ++-
>> arch/x86/kernel/xsave.c         |  1 +
>> arch/x86/kvm/cpuid.c            | 47 ++++++++++++++-------
>> arch/x86/kvm/svm.c              |  6 +++
>> arch/x86/kvm/vmx.c              | 80 +++++++++++++++++++++++++++++++++++-
>> arch/x86/kvm/x86.c              | 90 +++++++++++++++++++++++++++++++++++++----
>> 8 files changed, 210 insertions(+), 25 deletions(-)
>>
>> -- 
>> 1.8.3.1
