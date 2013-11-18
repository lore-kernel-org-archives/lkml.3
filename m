Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751421Ab3KRODD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 09:03:03 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:50079 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab3KROC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 09:02:59 -0500
X-IronPort-AV: E=Sophos;i="4.93,724,1378857600"; 
   d="scan'208";a="73025721"
Date: Mon, 18 Nov 2013 14:02:52 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Josh Boyer <jwboyer@redhat.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <xen-devel@lists.xenproject.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH] arm/xen: Export phys_to_mach to fix Xen module link
 errors
In-Reply-To: <20131118134806.GA1908@hansolo.jdub.homelinux.org>
Message-ID: <alpine.DEB.2.02.1311181402160.4714@kaball.uk.xensource.com>
References: <20131118134806.GA1908@hansolo.jdub.homelinux.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Nov 2013, Josh Boyer wrote:
> Various xen drivers fail to link when built as modules with the following
> error:
> 
> ERROR: "phys_to_mach" [drivers/xen/xen-gntalloc.ko] undefined!
> ERROR: "phys_to_mach" [drivers/net/xen-netfront.ko] undefined!
> ERROR: "phys_to_mach" [drivers/net/xen-netback/xen-netback.ko] undefined!
> ERROR: "phys_to_mach" [drivers/block/xen-blkfront.ko] undefined!
> 
> The mfn_to_pfn and pfn_to_mfn functions get inlined in these modules and
> those functions require phys_to_mach.  Export the symbol to fix the link
> errors.
> 
> Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>

Reviewed-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>


>  arch/arm/xen/p2m.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/xen/p2m.c b/arch/arm/xen/p2m.c
> index 23732cd..0f842e8 100644
> --- a/arch/arm/xen/p2m.c
> +++ b/arch/arm/xen/p2m.c
> @@ -27,6 +27,7 @@ struct xen_p2m_entry {
>  
>  rwlock_t p2m_lock;
>  struct rb_root phys_to_mach = RB_ROOT;
> +EXPORT_SYMBOL_GPL(phys_to_mach);
>  static struct rb_root mach_to_phys = RB_ROOT;
>  
>  static int xen_add_phys_to_mach_entry(struct xen_p2m_entry *new)
> -- 
> 1.8.3.1
> 
