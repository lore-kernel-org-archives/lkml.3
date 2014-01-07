Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbaAGNdc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 08:33:32 -0500
Received: from smtp.citrix.com ([66.165.176.89]:56227 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047AbaAGNdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 08:33:18 -0500
X-IronPort-AV: E=Sophos;i="4.95,618,1384300800"; 
   d="scan'208";a="90430170"
Date: Tue, 7 Jan 2014 13:32:25 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Xen Devel <Xen-devel@lists.xensource.com>,
        Russell King <rmk@arm.linux.org.uk>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Rob Herring <rob.herring@calxeda.com>,
        Wei Liu <liuw@liuw.name>
Subject: Re: linux-next: manual merge of the xen-tip tree with the arm-current
 tree
In-Reply-To: <20140107154222.b2c0c8081441671f32d78bc1@canb.auug.org.au>
Message-ID: <alpine.DEB.2.02.1401071332140.8667@kaball.uk.xensource.com>
References: <20140107154222.b2c0c8081441671f32d78bc1@canb.auug.org.au>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Jan 2014, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the xen-tip tree got a conflict in
> arch/arm/include/asm/xen/page.h between commit 0a5ccc86507f ("ARM:
> 7933/1: rename ioremap_cached to ioremap_cache") from the  tree and
> commit 02bcf053e9c5 ("asm/xen/page.h: remove redundant semicolon") from
> the xen-tip tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

That's fine, thanks!


> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc arch/arm/include/asm/xen/page.h
> index 3759cacdd7f8,709c4b4d2f1d..000000000000
> --- a/arch/arm/include/asm/xen/page.h
> +++ b/arch/arm/include/asm/xen/page.h
> @@@ -117,6 -117,7 +117,7 @@@ static inline bool set_phys_to_machine(
>   	return __set_phys_to_machine(pfn, mfn);
>   }
>   
> - #define xen_remap(cookie, size) ioremap_cache((cookie), (size));
>  -#define xen_remap(cookie, size) ioremap_cached((cookie), (size))
> ++#define xen_remap(cookie, size) ioremap_cache((cookie), (size))
> + #define xen_unmap(cookie) iounmap((cookie))
>   
>   #endif /* _ASM_ARM_XEN_PAGE_H */
> 
