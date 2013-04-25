Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758650Ab3DYNlW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 09:41:22 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:39084 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757887Ab3DYNlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 09:41:20 -0400
X-IronPort-AV: E=Sophos;i="4.87,551,1363132800"; 
   d="scan'208";a="3933886"
Message-ID: <1366897278.20256.545.camel@zakaz.uk.xensource.com>
Subject: Re: [PATCH v4 4/7] xen/arm: implement HYPERVISOR_vcpu_op
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Date: Thu, 25 Apr 2013 14:41:18 +0100
In-Reply-To: <1366831695-13214-4-git-send-email-stefano.stabellini@eu.citrix.com>
References: <alpine.DEB.2.02.1304242012590.4180@kaball.uk.xensource.com>
	 <1366831695-13214-4-git-send-email-stefano.stabellini@eu.citrix.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-24 at 20:28 +0100, Stefano Stabellini wrote:
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Reviewed-by: Ian Campbell <ian.campbell@citrix.com>

> ---
>  arch/arm/include/asm/xen/hypercall.h |    1 +
>  arch/arm/xen/enlighten.c             |    1 +
>  arch/arm/xen/hypercall.S             |    1 +
>  3 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/include/asm/xen/hypercall.h b/arch/arm/include/asm/xen/hypercall.h
> index 8a82325..799f42e 100644
> --- a/arch/arm/include/asm/xen/hypercall.h
> +++ b/arch/arm/include/asm/xen/hypercall.h
> @@ -46,6 +46,7 @@ int HYPERVISOR_event_channel_op(int cmd, void *arg);
>  unsigned long HYPERVISOR_hvm_op(int op, void *arg);
>  int HYPERVISOR_memory_op(unsigned int cmd, void *arg);
>  int HYPERVISOR_physdev_op(int cmd, void *arg);
> +int HYPERVISOR_vcpu_op(int cmd, int vcpuid, void *extra_args);
>  
>  static inline void
>  MULTI_update_va_mapping(struct multicall_entry *mcl, unsigned long va,
> diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
> index 94bbf3b..b002822 100644
> --- a/arch/arm/xen/enlighten.c
> +++ b/arch/arm/xen/enlighten.c
> @@ -295,4 +295,5 @@ EXPORT_SYMBOL_GPL(HYPERVISOR_sched_op);
>  EXPORT_SYMBOL_GPL(HYPERVISOR_hvm_op);
>  EXPORT_SYMBOL_GPL(HYPERVISOR_memory_op);
>  EXPORT_SYMBOL_GPL(HYPERVISOR_physdev_op);
> +EXPORT_SYMBOL_GPL(HYPERVISOR_vcpu_op);
>  EXPORT_SYMBOL_GPL(privcmd_call);
> diff --git a/arch/arm/xen/hypercall.S b/arch/arm/xen/hypercall.S
> index 71f7239..199cb2d 100644
> --- a/arch/arm/xen/hypercall.S
> +++ b/arch/arm/xen/hypercall.S
> @@ -87,6 +87,7 @@ HYPERCALL2(event_channel_op);
>  HYPERCALL2(hvm_op);
>  HYPERCALL2(memory_op);
>  HYPERCALL2(physdev_op);
> +HYPERCALL3(vcpu_op);
>  
>  ENTRY(privcmd_call)
>  	stmdb sp!, {r4}


