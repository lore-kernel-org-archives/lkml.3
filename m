Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552Ab3HLRYd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 13:24:33 -0400
Received: from thoth.sbs.de ([192.35.17.2]:27457 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757518Ab3HLRY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 13:24:27 -0400
X-Greylist: delayed 961 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Aug 2013 13:24:27 EDT
Message-ID: <52091682.8020004@siemens.com>
Date: Mon, 12 Aug 2013 19:08:18 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Chris Metcalf <cmetcalf@tilera.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] tile: support KVM for tilegx
References: <201308121615.r7CGFstm024706@farm-0021.internal.tilera.com>
In-Reply-To: <201308121615.r7CGFstm024706@farm-0021.internal.tilera.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-08-12 17:24, Chris Metcalf wrote:
> This change provides the initial framework support for KVM on tilegx.
> Basic virtual disk and networking is supported.
> 
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
> ---

...

> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index acccd08..d3879c5 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -171,6 +171,7 @@ struct kvm_pit_config {
>  #define KVM_EXIT_WATCHDOG         21
>  #define KVM_EXIT_S390_TSCH        22
>  #define KVM_EXIT_EPR              23
> +#define KVM_EXIT_AGAIN            24
>  
>  /* For KVM_EXIT_INTERNAL_ERROR */
>  /* Emulate instruction failed. */
> @@ -1012,6 +1013,8 @@ struct kvm_s390_ucas_mapping {
>  #define KVM_KVMCLOCK_CTRL	  _IO(KVMIO,   0xad)
>  #define KVM_ARM_VCPU_INIT	  _IOW(KVMIO,  0xae, struct kvm_vcpu_init)
>  #define KVM_GET_REG_LIST	  _IOWR(KVMIO, 0xb0, struct kvm_reg_list)
> +/* Reset some SPR registers for tilegx */
> +#define KVM_TILE_RESET_SPR	  _IO(KVMIO,  0xa8)

The KVM way of doing this is typically GET/SET_SPR, i.e. a way to
read/write the registers from userspace. This will be required for
migration support anyway, I bet.

Jan

-- 
Siemens AG, Corporate Technology, CT RTC ITP SES-DE
Corporate Competence Center Embedded Linux
