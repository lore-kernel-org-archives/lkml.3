Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933042AbaCQM3B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 08:29:01 -0400
Received: from smtp.citrix.com ([66.165.176.89]:52259 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932767AbaCQM3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 08:29:00 -0400
X-IronPort-AV: E=Sophos;i="4.97,670,1389744000"; 
   d="scan'208";a="112085240"
Date: Mon, 17 Mar 2014 12:28:10 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Arnd Bergmann <arnd@arndb.de>
CC: <xen-devel@lists.xenproject.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>, <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [PATCH] Xen: include asm/page.h in xen-ops.h
In-Reply-To: <201403151042.15932.arnd@arndb.de>
Message-ID: <alpine.DEB.2.02.1403171228020.30819@kaball.uk.xensource.com>
References: <201403151042.15932.arnd@arndb.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Mar 2014, Arnd Bergmann wrote:
> The declaration of xen_remap_domain_mfn_range relies on the
> pgprot_t typedef to be visible. In some configurations, that
> may not already have been seen, and I have encountered a
> bug during randconfig testing on ARM.
> 
> Adding an explicit #include for asm/page.h fixes the problem.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

I'll add to xentip


> diff --git a/include/xen/xen-ops.h b/include/xen/xen-ops.h
> index 6d8c042..b8ad234 100644
> --- a/include/xen/xen-ops.h
> +++ b/include/xen/xen-ops.h
> @@ -3,6 +3,7 @@
>  
>  #include <linux/percpu.h>
>  #include <asm/xen/interface.h>
> +#include <asm/page.h>
>  
>  DECLARE_PER_CPU(struct vcpu_info *, xen_vcpu);
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
