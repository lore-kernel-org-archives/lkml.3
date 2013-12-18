Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab3LROUa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 09:20:30 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:34951 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754619Ab3LROU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 09:20:28 -0500
X-IronPort-AV: E=Sophos;i="4.95,508,1384300800"; 
   d="scan'208";a="83497095"
Date: Wed, 18 Dec 2013 14:19:28 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        <boris.ostrovsky@oracle.com>, <david.vrabel@citrix.com>,
        <mukesh.rathor@oracle.com>, <jbeulich@suse.com>
Subject: Re: [Xen-devel] [PATCH v11 11/12] xen/pvh: Disable PV code that does
 not work with PVH.
In-Reply-To: <1387313503-31362-12-git-send-email-konrad.wilk@oracle.com>
Message-ID: <alpine.DEB.2.02.1312181416230.8667@kaball.uk.xensource.com>
References: <1387313503-31362-1-git-send-email-konrad.wilk@oracle.com> <1387313503-31362-12-git-send-email-konrad.wilk@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Dec 2013, Konrad Rzeszutek Wilk wrote:
> From: Mukesh Rathor <mukesh.rathor@oracle.com>
> 
> As we do not have yet a mechanism for that.
> 
> Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Even though we don't even compile cpu_hotplug on ARM yet, I don't like
this change because it affects ARM guests too.

Please add a note about ARM guests in the FIXME line.


>  drivers/xen/cpu_hotplug.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/xen/cpu_hotplug.c b/drivers/xen/cpu_hotplug.c
> index cc6513a..cbb02af 100644
> --- a/drivers/xen/cpu_hotplug.c
> +++ b/drivers/xen/cpu_hotplug.c
> @@ -4,6 +4,7 @@
>  
>  #include <xen/xen.h>
>  #include <xen/xenbus.h>
> +#include <xen/features.h>
>  
>  #include <asm/xen/hypervisor.h>
>  #include <asm/cpu.h>
> @@ -102,7 +103,8 @@ static int __init setup_vcpu_hotplug_event(void)
>  	static struct notifier_block xsn_cpu = {
>  		.notifier_call = setup_cpu_watcher };
>  
> -	if (!xen_pv_domain())
> +	/* PVH TBD/FIXME: future work */
> +	if (!xen_pv_domain() || xen_feature(XENFEAT_auto_translated_physmap))
>  		return -ENODEV;
>  
>  	register_xenstore_notifier(&xsn_cpu);

