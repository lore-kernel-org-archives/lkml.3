Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933386AbaLEBfR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 20:35:17 -0500
Received: from mga01.intel.com ([192.55.52.88]:26848 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824AbaLEBfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 20:35:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,519,1413270000"; 
   d="scan'208";a="642697676"
Date: Fri, 5 Dec 2014 09:15:01 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, rkrcmar@redhat.com
Subject: Re: [PATCH 0/9] Final set of XSAVES patches
Message-ID: <20141205011501.GA2683@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <1417708634-24333-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417708634-24333-1-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paolo,
On Thu, Dec 04, 2014 at 04:57:05PM +0100, Paolo Bonzini wrote:
>These are all the patches needed to support XSAVES.
>

I think you miss to add your patch "kvm: x86: mask out XSAVES" to 
this patchset, I test the whole patchset w/ that patch applied on 
skylake-client machine, and it looks good, please feel free to add 
my tested-by to this patchset.

Tested-by: Wanpeng Li <wanpeng.li@linux.intel.com>

>Paolo Bonzini (5):
>  x86: export get_xsave_addr
>  KVM: x86: support XSAVES usage in the host
>  KVM: x86: use F() macro throughout cpuid.c
>  KVM: cpuid: set CPUID(EAX=0xd,ECX=1).EBX correctly
>  KVM: cpuid: mask more bits in leaf 0xd and subleaves
>
>Wanpeng Li (4):
>  kvm: x86: Add kvm_x86_ops hook that enables XSAVES for guest
>  kvm: x86: handle XSAVES vmcs and vmexit
>  kvm: vmx: add MSR logic for XSAVES
>  kvm: vmx: add nested virtualization support for xsaves
>
> arch/x86/include/asm/kvm_host.h |  2 +
> arch/x86/include/asm/vmx.h      |  3 ++
> arch/x86/include/uapi/asm/vmx.h |  6 ++-
> arch/x86/kernel/xsave.c         |  1 +
> arch/x86/kvm/cpuid.c            | 47 ++++++++++++++-------
> arch/x86/kvm/svm.c              |  6 +++
> arch/x86/kvm/vmx.c              | 80 +++++++++++++++++++++++++++++++++++-
> arch/x86/kvm/x86.c              | 90 +++++++++++++++++++++++++++++++++++++----
> 8 files changed, 210 insertions(+), 25 deletions(-)
>
>-- 
>1.8.3.1
