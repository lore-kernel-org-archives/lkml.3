Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbbALKM3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 05:12:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263AbbALKM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 05:12:28 -0500
Message-ID: <54B39DFD.60004@redhat.com>
Date: Mon, 12 Jan 2015 11:12:13 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Gleb Natapov <gleb@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: kvm: vmx: Remove some unused functions
References: <1420999346-21962-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1420999346-21962-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2015 19:02, Rickard Strandqvist wrote:
> Removes some functions that are not used anywhere:
> cpu_has_vmx_eptp_writeback() cpu_has_vmx_eptp_uncacheable()
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  arch/x86/kvm/vmx.c |   10 ----------
>  1 file changed, 10 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index 3e556c6..e273f15 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -951,16 +951,6 @@ static inline bool cpu_has_vmx_ept_execute_only(void)
>  	return vmx_capability.ept & VMX_EPT_EXECUTE_ONLY_BIT;
>  }
>  
> -static inline bool cpu_has_vmx_eptp_uncacheable(void)
> -{
> -	return vmx_capability.ept & VMX_EPTP_UC_BIT;
> -}
> -
> -static inline bool cpu_has_vmx_eptp_writeback(void)
> -{
> -	return vmx_capability.ept & VMX_EPTP_WB_BIT;
> -}
> -
>  static inline bool cpu_has_vmx_ept_2m_page(void)
>  {
>  	return vmx_capability.ept & VMX_EPT_2MB_PAGE_BIT;
> 

Looks good, thanks.

Paolo
