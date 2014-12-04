Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932323AbaLDN5U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 08:57:20 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:36354 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932101AbaLDN5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 08:57:18 -0500
Message-ID: <54806839.1080301@redhat.com>
Date: Thu, 04 Dec 2014 14:57:13 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.comp.emulators.kvm.devel
To: Wanpeng Li <wanpeng.li@linux.intel.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] kvm: cpuid: fix xsave area size of XSAVEC
References: <1417681468-7165-1-git-send-email-wanpeng.li@linux.intel.com> <1417681468-7165-3-git-send-email-wanpeng.li@linux.intel.com>
In-Reply-To: <1417681468-7165-3-git-send-email-wanpeng.li@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/12/2014 09:24, Wanpeng Li wrote:
> XSAVEC also use the compacted format for the extended region
> of the XSAVE area. This patch fix it by caculate the size of 
> XSAVEC extended region of XSAVE area as compact format.
> 
> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
> ---
>  arch/x86/kvm/cpuid.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 70f0fa1..e16a0c7 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -92,7 +92,7 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
>  	}
>  
>  	best = kvm_find_cpuid_entry(vcpu, 0xD, 1);
> -	if (best && (best->eax & F(XSAVES)))
> +	if (best && (best->eax & (F(XSAVES) || F(XSAVEC))))

"|" instead of "||" as mentioned by Nadav.

Is the Intel manual implicitly relying on the fact that there is no
processor that has XSAVES but not XSAVEC?

Paolo

>  		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
>  
>  	/*
> 
