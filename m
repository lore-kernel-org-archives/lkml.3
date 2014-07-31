Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906AbaGaOi6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 10:38:58 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:35406 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaGaOi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 10:38:56 -0400
Message-ID: <53DA54F9.8090605@redhat.com>
Date: Thu, 31 Jul 2014 16:38:49 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Igor Mammedov <imammedo@redhat.com>, linux-kernel@vger.kernel.org
CC: x86@kernel.org, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de,
        kvm@vger.kernel.org, mtosatti@redhat.com
Subject: Re: [PATCH 2/2] x86: kvm: do not advertise stable clocksource if
 CPU has TSC drift BUG
References: <1406800033-13404-1-git-send-email-imammedo@redhat.com> <1406800033-13404-3-git-send-email-imammedo@redhat.com>
In-Reply-To: <1406800033-13404-3-git-send-email-imammedo@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 31/07/2014 11:47, Igor Mammedov ha scritto:
> Signed-off-by: Igor Mammedov <imammedo@redhat.com>
> ---
>  arch/x86/kvm/cpuid.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 38a0afe..f519823 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -478,8 +478,9 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
>  			     (1 << KVM_FEATURE_CLOCKSOURCE2) |
>  			     (1 << KVM_FEATURE_ASYNC_PF) |
>  			     (1 << KVM_FEATURE_PV_EOI) |
> -			     (1 << KVM_FEATURE_CLOCKSOURCE_STABLE_BIT) |
>  			     (1 << KVM_FEATURE_PV_UNHALT);
> +		if (!static_cpu_has_bug(X86_BUG_AMD_TSC_DRIFT))
> +			entry->eax |= (1 << KVM_FEATURE_CLOCKSOURCE_STABLE_BIT);
>  
>  		if (sched_info_on())
>  			entry->eax |= (1 << KVM_FEATURE_STEAL_TIME);
> 

Marcelo, is there anything we can do if the VM migrates from a sane host
to a buggy one?

Paolo
