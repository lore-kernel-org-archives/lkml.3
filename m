Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595Ab3JCJkx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 05:40:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10880 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386Ab3JCJkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 05:40:45 -0400
Date: Thu, 3 Oct 2013 12:40:43 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 0/3] KVM: prepare for future XSAVE extensions
Message-ID: <20131003094043.GA17294@redhat.com>
References: <1380722776-12358-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380722776-12358-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 04:06:13PM +0200, Paolo Bonzini wrote:
> As soon as the kernel will support the XSAVE extensions in Skylake
> processors, we will want both userspace and the hypervisor to run
> guests without showing any trace of the new features (because
> support for them in the hypervisor will come later).
> 
> This series does exactly this.  Patches 1 and 3 ensures that userspace
> does not get access to features not supported in the hypervisor.
> Patch 2 does the same for the guest.
> 
> The effect of these patches is already visible together with
> the corresponding QEMU patches and a command line such as "-cpu
> SandyBridge,-avx".  Previously, the guest could still enable AVX via
> xsetbv, and state would be sent by QEMU during migration.  These patches
> make sure that disabling AVX will really prevent the guest from using it,
> which helps if you have to deal with migration from newer versions of
> QEMU and the kernel to older versions.  The QEMU patches set up the
> guest's 0xd CPUID leaf, which also ensures that the kernel has the
> necessary information.
> 
> Paolo
> 
Applied, thanks.

> v2->v3:
> 	rename supported_xcr0 field to guest_supported_xcr0
> 	rename xstate_size field to guest_xstate_size
> 	do not hardcode XSTATE_FPSSE in guest_supported_xcr0
> 	handle missing 0xd leaf
> 
> Paolo Bonzini (3):
>   KVM: x86: mask unsupported XSAVE entries from leaf 0Dh index 0
>   KVM: x86: prevent setting unsupported XSAVE states
>   KVM: x86: only copy XSAVE state for the supported features
> 
>  arch/x86/include/asm/kvm_host.h |  2 ++
>  arch/x86/kvm/cpuid.c            | 36 +++++++++++++++++++++++++++++++++++-
>  arch/x86/kvm/x86.c              | 29 ++++++++++++++++++++++-------
>  arch/x86/kvm/x86.h              |  1 +
>  4 files changed, 60 insertions(+), 8 deletions(-)
> 
> -- 
> 1.8.3.1

--
			Gleb.
