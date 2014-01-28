Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888AbaA1WUT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 17:20:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755866AbaA1WUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 17:20:17 -0500
Date: Tue, 28 Jan 2014 20:19:01 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, gleb@kernel.org, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de
Subject: Re: [PATCH 0/2] x86, kvm: fix detection of KVM features when KVM and
 Hyper-V coexist
Message-ID: <20140128221901.GA3096@amt.cnet>
References: <1390846290-26844-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390846290-26844-1-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 07:11:28PM +0100, Paolo Bonzini wrote:
> When KVM also presents Hyper-V features (which is useful because Windows
> behaves better), Linux guests prefer KVM because emulated leaves are at
> 0x40000000 and the native ones are at 0x40000100.
> 
> However, Linux is then not accounting for the offset when reading the
> available hypervisor features from CPUID.  Instead of looking at
> 0x40000101, it will always look at 0x40000001.
> 
> This series makes sure that features such as async page faults or steal
> time are available even if, for whatever reason, Hyper-V features are
> enabled.
> 
> As a side effect, patch 1 makes a bunch of code non inline, which also
> makes sense since it should only be called during initialization.  As 
> a result, vmlinux .text size decreases by 96 bytes.
> 
> Please review!
> 
> Paolo Bonzini (2):
>   x86, kvm: cache the base of the KVM cpuid leaves
>   x86, kvm: correctly access the KVM_CPUID_FEATURES leaf at 0x40000101
> 
>  arch/x86/include/asm/kvm_para.h | 33 ++++++++++++---------------------
>  arch/x86/kernel/kvm.c           | 31 +++++++++++++++++++++++++++++++
>  2 files changed, 43 insertions(+), 21 deletions(-)
> 
> -- 
> 1.8.3.1

Reviewed-by: Marcelo Tosatti <mtosatti@redhat.com>

