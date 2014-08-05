Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823AbaHEM2H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 08:28:07 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:50851 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638AbaHEM2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 08:28:03 -0400
Message-ID: <53E0CDCD.8010504@redhat.com>
Date: Tue, 05 Aug 2014 14:27:57 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: agraf@suse.de, kvm@vger.kernel.org, linux-next@vger.kernel.org,
        kvm-ppc@vger.kernel.org, sfr@canb.auug.org.au
Subject: Re: [PATCH] KVM: PPC: drop duplicate tracepoint
References: <1407234956-743-1-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1407234956-743-1-git-send-email-pbonzini@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 05/08/2014 12:35, Paolo Bonzini ha scritto:
> diff --git a/arch/powerpc/kvm/emulate.c b/arch/powerpc/kvm/emulate.c
> index e96b50d0bdab..2325168ad1ff 100644
> --- a/arch/powerpc/kvm/emulate.c
> +++ b/arch/powerpc/kvm/emulate.c
> @@ -300,3 +300,5 @@ int kvmppc_emulate_instruction(struct kvm_run *run, struct kvm_vcpu *vcpu)
>  	return emulated;
>  }
>  EXPORT_SYMBOL_GPL(kvmppc_emulate_instruction);
> +
> +EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_ppc_instr);

Nope, this is in kvm-pr.ko so it is not enough... replaced with

diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 288b4bb05cbd..4c79284b58be 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -1347,3 +1347,5 @@ void kvm_arch_exit(void)
 {

 }
+
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_ppc_instr);


Paolo
