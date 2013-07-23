Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221Ab3GWLSA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 07:18:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757053Ab3GWLR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 07:17:59 -0400
Message-ID: <51EE664E.9020203@redhat.com>
Date: Tue, 23 Jul 2013 13:17:34 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jason Wang <jasowang@redhat.com>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        gleb@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>
Subject: Re: [PATCH 4/4] x86: properly handle kvm emulation of hyperv
References: <1374572465-15278-1-git-send-email-jasowang@redhat.com> <1374572465-15278-4-git-send-email-jasowang@redhat.com>
In-Reply-To: <1374572465-15278-4-git-send-email-jasowang@redhat.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 23/07/2013 11:41, Jason Wang ha scritto:
> Recent kvm has some basic support of hyperv, this will cause the guest to
> identify itself as running on top of hyperv instead of kvm which will disable
> kvm pv functionality. This is because we try to detect hyperv before kvm. Solve
> this by simply checking kvm in detect_hypervisor() first.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: x86@kernel.org
> Cc: Gleb Natapov <gleb@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  arch/x86/kernel/cpu/hypervisor.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/hypervisor.c b/arch/x86/kernel/cpu/hypervisor.c
> index 8727921..3e149b6 100644
> --- a/arch/x86/kernel/cpu/hypervisor.c
> +++ b/arch/x86/kernel/cpu/hypervisor.c
> @@ -36,10 +36,10 @@ static const __initconst struct hypervisor_x86 * const hypervisors[] =
>  	&x86_hyper_xen_hvm,
>  #endif
>  	&x86_hyper_vmware,
> -	&x86_hyper_ms_hyperv,
>  #ifdef CONFIG_KVM_GUEST
>  	&x86_hyper_kvm,
>  #endif
> +	&x86_hyper_ms_hyperv,
>  };
>  
>  const struct hypervisor_x86 *x86_hyper;
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>
