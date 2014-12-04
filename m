Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349AbaLDIbE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 03:31:04 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:39722 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbaLDIbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 03:31:00 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: [PATCH 3/4] kvm: cpuid: fix xsave area size of XSAVEC
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <1417681468-7165-3-git-send-email-wanpeng.li@linux.intel.com>
Date: Thu, 4 Dec 2014 10:30:55 +0200
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <1EDEA01D-B396-4F17-947A-22CA4AA4BC61@gmail.com>
References: <1417681468-7165-1-git-send-email-wanpeng.li@linux.intel.com> <1417681468-7165-3-git-send-email-wanpeng.li@linux.intel.com>
To: Wanpeng Li <wanpeng.li@linux.intel.com>
X-Mailer: Apple Mail (2.1993)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wanpeng Li <wanpeng.li@linux.intel.com> wrote:

> XSAVEC also use the compacted format for the extended region
> of the XSAVE area. This patch fix it by caculate the size of 
> XSAVEC extended region of XSAVE area as compact format.
> 
> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
> ---
> arch/x86/kvm/cpuid.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 70f0fa1..e16a0c7 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -92,7 +92,7 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
> 	}
> 
> 	best = kvm_find_cpuid_entry(vcpu, 0xD, 1);
> -	if (best && (best->eax & F(XSAVES)))
> +	if (best && (best->eax & (F(XSAVES) || F(XSAVEC))))
Did you want to use | (bitwise or) instead of II (logical or) ?

> 		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
> 
> 	/*
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Nadav
