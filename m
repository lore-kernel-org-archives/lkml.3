Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858AbaBVOzL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 09:55:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34967 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702AbaBVOy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 09:54:57 -0500
Message-ID: <5308BA3B.4050408@redhat.com>
Date: Sat, 22 Feb 2014 15:54:51 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Liu, Jinsong" <jinsong.liu@intel.com>
CC: "gleb@redhat.com" <gleb@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
Subject: Re: [PATCH] KVM: x86: expose ADX feature to guest
References: <DE8DF0795D48FD4CA783C40EC829233501509B37@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <DE8DF0795D48FD4CA783C40EC829233501509B37@SHSMSX101.ccr.corp.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 21/02/2014 18:36, Liu, Jinsong ha scritto:
> From 0750e335eb5860b0b483e217e8a08bd743cbba16 Mon Sep 17 00:00:00 2001
> From: Liu Jinsong <jinsong.liu@intel.com>
> Date: Thu, 20 Feb 2014 17:39:32 +0800
> Subject: [PATCH] KVM: x86: expose ADX feature to guest
>
> ADCX and ADOX instructions perform an unsigned addition with Carry flag and
> Overflow flag respectively.
>
> Signed-off-by: Xudong Hao <xudong.hao@intel.com>
> Signed-off-by: Liu Jinsong <jinsong.liu@intel.com>
> ---
>  arch/x86/kvm/cpuid.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index abe18b4..a951ae4 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -303,7 +303,8 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
>  	/* cpuid 7.0.ebx */
>  	const u32 kvm_supported_word9_x86_features =
>  		F(FSGSBASE) | F(BMI1) | F(HLE) | F(AVX2) | F(SMEP) |
> -		F(BMI2) | F(ERMS) | f_invpcid | F(RTM) | F(RDSEED);
> +		F(BMI2) | F(ERMS) | f_invpcid | F(RTM) | F(RDSEED) |
> +		F(ADX);
>
>  	/* all calls to cpuid_count() should be made on the same cpu */
>  	get_cpu();
>

Applied to kvm/queue, thanks.

Paolo

