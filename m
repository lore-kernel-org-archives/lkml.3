Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbaLJMG7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 07:06:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49362 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153AbaLJMG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 07:06:57 -0500
Message-ID: <54883759.4090409@redhat.com>
Date: Wed, 10 Dec 2014 13:06:49 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Bandan Das <bsd@redhat.com>, kvm@vger.kernel.org
CC: jan.kiszka@siemens.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Disable unrestricted mode if ept=0
References: <jpg388s95zb.fsf@redhat.com>
In-Reply-To: <jpg388s95zb.fsf@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/12/2014 16:02, Bandan Das wrote:
> 
> If L0 has disabled EPT, don't advertise unrestricted
> mode at all since it depends on EPT to run real mode code.
> 
> Signed-off-by: Bandan Das <bsd@redhat.com>
> ---
>  arch/x86/kvm/vmx.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index 3e556c6..ed70394 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -2377,12 +2377,12 @@ static __init void nested_vmx_setup_ctls_msrs(void)
>  	nested_vmx_secondary_ctls_low = 0;
>  	nested_vmx_secondary_ctls_high &=
>  		SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES |
> -		SECONDARY_EXEC_UNRESTRICTED_GUEST |
>  		SECONDARY_EXEC_WBINVD_EXITING;
>  
>  	if (enable_ept) {
>  		/* nested EPT: emulate EPT also to L1 */
> -		nested_vmx_secondary_ctls_high |= SECONDARY_EXEC_ENABLE_EPT;
> +		nested_vmx_secondary_ctls_high |= SECONDARY_EXEC_ENABLE_EPT |
> +			SECONDARY_EXEC_UNRESTRICTED_GUEST;
>  		nested_vmx_ept_caps = VMX_EPT_PAGE_WALK_4_BIT |
>  			 VMX_EPTP_WB_BIT | VMX_EPT_2MB_PAGE_BIT |
>  			 VMX_EPT_INVEPT_BIT;
> 

Thanks, applied with

Fixes: 92fbc7b195b824e201d9f06f2b93105f72384d65
Cc: stable@vger.kernel.org

Paolo
