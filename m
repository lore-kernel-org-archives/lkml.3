Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811AbaACNOr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 08:14:47 -0500
Received: from smtp.citrix.com ([66.165.176.89]:15566 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085AbaACNOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 08:14:46 -0500
X-IronPort-AV: E=Sophos;i="4.95,598,1384300800"; 
   d="scan'208";a="89526783"
Date: Fri, 3 Jan 2014 13:13:57 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Mark Salter <msalter@redhat.com>
CC: Chen Baozi <baozich@gmail.com>, <linux-arm-kernel@lists.infradead.org>,
        <xen-devel@lists.xenproject.org>, <catalin.marinas@arm.com>,
        <stefano.stabellini@eu.citrix.com>, <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH] arm64/xen: redefine xen_remap on arm64
In-Reply-To: <1388431259.2564.15.camel@deneb.redhat.com>
Message-ID: <alpine.DEB.2.02.1401031310100.8667@kaball.uk.xensource.com>
References: <1388386511-32276-1-git-send-email-baozich@gmail.com> <1388431259.2564.15.camel@deneb.redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Dec 2013, Mark Salter wrote:
> On Mon, 2013-12-30 at 14:55 +0800, Chen Baozi wrote:
> > xen_remap used to be defined as ioremap_cached on arm64. In commit
> > c04e8e2fe, a new ioremap_cache was implemented, and ioremap_cached
> > was deleted, while xen_remap stays the same. This would lead to
> > the failure when building with CONFIG_HVC_XEN. Redefined xen_remap
> > on arm64 as ioremap_cache on arm64 to fix it.
> > 
> 
> I missed that include of arm header by arm64 when looking for users
> of arm64's ioremap_cached() when working on commit c04e8e2fe. Anyway,
> grepping the kernel tree, I see:
> 
>   ioremap_cached()
>     defined by: arm, metag, unicore32
>     used by: arch/arm/include/asm/xen/page.h
>              drivers/mtd/maps/pxa2xx-flash.c
> 
>   ioremap_cache()
>     defined by: arm64, sh, xtensa, ia64, x86
>     used by: drivers/video/vesafb.c
>              drivers/char/toshiba.c
>              drivers/acpi/apei
>              drivers/lguest/lguest_device.c
>              drivers/sfi/sfi_core.c
>              include/linux/acpi_io.h
> 
> I think it would be better to just avoid the confusion and the ifdef in
> asm/xen/page.h by globally changing ioremap_cached to ioremap_cache.

While I welcome the suggestion, this is a critical fix for a regression
that I think should go in as soon as possible, maybe 3.13-rc7, while I
don't think that a global s/ioremap_cached/ioremap_cache would be
acceptable at this stage.
