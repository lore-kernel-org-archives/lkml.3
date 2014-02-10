Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090AbaBJN1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 08:27:19 -0500
Received: from smtp.citrix.com ([66.165.176.89]:45134 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300AbaBJN1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 08:27:15 -0500
X-IronPort-AV: E=Sophos;i="4.95,817,1384300800"; 
   d="scan'208";a="101293015"
Date: Mon, 10 Feb 2014 13:26:53 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Rashika Kheria <rashika.kheria@gmail.com>
CC: <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Wei Liu <wei.liu2@citrix.com>, <xen-devel@lists.xenproject.org>,
        <josh@joshtriplett.org>
Subject: Re: [PATCH 4/4] drivers: xen: Move prototype declaration to header
 file include/xen/xen-ops.h from arch/x86/xen/xen-ops.h
In-Reply-To: <98aa418fd8664807c4bde1ff7cf2cd5969749129.1391943416.git.rashika.kheria@gmail.com>
Message-ID: <alpine.DEB.2.02.1402101326460.4373@kaball.uk.xensource.com>
References: <3826f170dae13e3ee700ad9e26a8c88be4b7aaa2.1391943416.git.rashika.kheria@gmail.com> <98aa418fd8664807c4bde1ff7cf2cd5969749129.1391943416.git.rashika.kheria@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="1342847746-1702294038-1392038813=:4373"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--1342847746-1702294038-1392038813=:4373
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Sun, 9 Feb 2014, Rashika Kheria wrote:
> Move prototype declaration to header file include/xen/xen-ops.h from
> arch/x86/xen/xen-ops.h because it is used by more than one file. Also,
> remove else condition from xen/events/events_base.c to eliminate
> conflicting definitions when CONFIG_XEN_PVHVM is not defined.
>=20
> This eliminates the following warning in xen/events/events_base.c:
> drivers/xen/events/events_base.c:1640:6: warning: no previous prototype f=
or =E2=80=98xen_callback_vector=E2=80=99 [-Wmissing-prototypes]
>=20
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>


>  arch/x86/xen/xen-ops.h           |    1 -
>  drivers/xen/events/events_base.c |    2 --
>  include/xen/xen-ops.h            |    7 +++++++
>  3 files changed, 7 insertions(+), 3 deletions(-)
>=20
> diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
> index e5edc7f..aa8a979 100644
> --- a/arch/x86/xen/xen-ops.h
> +++ b/arch/x86/xen/xen-ops.h
> @@ -39,7 +39,6 @@ void xen_enable_sysenter(void);
>  void xen_enable_syscall(void);
>  void xen_vcpu_restore(void);
> =20
> -void xen_callback_vector(void);
>  void xen_hvm_init_shared_info(void);
>  void xen_unplug_emulated_devices(void);
> =20
> diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events=
_base.c
> index 4672e00..5466543 100644
> --- a/drivers/xen/events/events_base.c
> +++ b/drivers/xen/events/events_base.c
> @@ -1656,8 +1656,6 @@ void xen_callback_vector(void)
>  =09=09=09=09=09xen_hvm_callback_vector);
>  =09}
>  }
> -#else
> -void xen_callback_vector(void) {}
>  #endif
> =20
>  #undef MODULE_PARAM_PREFIX
> diff --git a/include/xen/xen-ops.h b/include/xen/xen-ops.h
> index 9a86337..cdea45b 100644
> --- a/include/xen/xen-ops.h
> +++ b/include/xen/xen-ops.h
> @@ -38,4 +38,11 @@ int xen_unmap_domain_mfn_range(struct vm_area_struct *=
vma,
>  bool xen_running_on_version_or_later(unsigned int major, unsigned int mi=
nor);
> =20
>  irqreturn_t xen_debug_interrupt(int irq, void *dev_id);
> +
> +#ifdef CONFIG_XEN_PVHVM
> +void xen_callback_vector(void);
> +#else
> +static inline void xen_callback_vector(void) {}
> +#endif
> +
>  #endif /* INCLUDE_XEN_OPS_H */
> --=20
> 1.7.9.5
>=20
--1342847746-1702294038-1392038813=:4373--
