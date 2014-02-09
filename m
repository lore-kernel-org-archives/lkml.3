Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581AbaBIMUq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 07:20:46 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:42032 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbaBIMUo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 07:20:44 -0500
X-Originating-IP: 50.43.14.201
Date: Sun, 9 Feb 2014 04:20:32 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Wei Liu <wei.liu2@citrix.com>, xen-devel@lists.xenproject.org
Subject: Re: [PATCH 4/4] drivers: xen: Move prototype declaration to header
 file include/xen/xen-ops.h from arch/x86/xen/xen-ops.h
Message-ID: <20140209122032.GB29984@leaf>
References: <3826f170dae13e3ee700ad9e26a8c88be4b7aaa2.1391943416.git.rashika.kheria@gmail.com>
 <98aa418fd8664807c4bde1ff7cf2cd5969749129.1391943416.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <98aa418fd8664807c4bde1ff7cf2cd5969749129.1391943416.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 09, 2014 at 04:42:33PM +0530, Rashika Kheria wrote:
> Move prototype declaration to header file include/xen/xen-ops.h from
> arch/x86/xen/xen-ops.h because it is used by more than one file. Also,
> remove else condition from xen/events/events_base.c to eliminate
> conflicting definitions when CONFIG_XEN_PVHVM is not defined.
> 
> This eliminates the following warning in xen/events/events_base.c:
> drivers/xen/events/events_base.c:1640:6: warning: no previous prototype for ‘xen_callback_vector’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  arch/x86/xen/xen-ops.h           |    1 -
>  drivers/xen/events/events_base.c |    2 --
>  include/xen/xen-ops.h            |    7 +++++++
>  3 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
> index e5edc7f..aa8a979 100644
> --- a/arch/x86/xen/xen-ops.h
> +++ b/arch/x86/xen/xen-ops.h
> @@ -39,7 +39,6 @@ void xen_enable_sysenter(void);
>  void xen_enable_syscall(void);
>  void xen_vcpu_restore(void);
>  
> -void xen_callback_vector(void);
>  void xen_hvm_init_shared_info(void);
>  void xen_unplug_emulated_devices(void);
>  
> diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
> index 4672e00..5466543 100644
> --- a/drivers/xen/events/events_base.c
> +++ b/drivers/xen/events/events_base.c
> @@ -1656,8 +1656,6 @@ void xen_callback_vector(void)
>  					xen_hvm_callback_vector);
>  	}
>  }
> -#else
> -void xen_callback_vector(void) {}
>  #endif
>  
>  #undef MODULE_PARAM_PREFIX
> diff --git a/include/xen/xen-ops.h b/include/xen/xen-ops.h
> index 9a86337..cdea45b 100644
> --- a/include/xen/xen-ops.h
> +++ b/include/xen/xen-ops.h
> @@ -38,4 +38,11 @@ int xen_unmap_domain_mfn_range(struct vm_area_struct *vma,
>  bool xen_running_on_version_or_later(unsigned int major, unsigned int minor);
>  
>  irqreturn_t xen_debug_interrupt(int irq, void *dev_id);
> +
> +#ifdef CONFIG_XEN_PVHVM
> +void xen_callback_vector(void);
> +#else
> +static inline void xen_callback_vector(void) {}
> +#endif
> +
>  #endif /* INCLUDE_XEN_OPS_H */
> -- 
> 1.7.9.5
> 
