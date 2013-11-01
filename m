Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab3KATo6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 15:44:58 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:34021 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab3KATo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 15:44:57 -0400
Date: Fri, 1 Nov 2013 15:43:24 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Randy Dunlap <rdunlap@infradead.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org
Subject: Re: linux-next: Tree for Nov 1 (xen_swiotllb)
Message-ID: <20131101194324.GC15622@phenom.dumpdata.com>
References: <20131101191138.442028fb1f243c7f9c7f0844@canb.auug.org.au>
 <5273EFFA.1030400@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5273EFFA.1030400@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 01, 2013 at 11:16:26AM -0700, Randy Dunlap wrote:
> On 11/01/13 01:11, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20131031:
> > 
> > The squashfs tree gained a build failure so I used the version from
> > next-20131031.
> > 
> > The block tree gained conflicts against the f2fs, aio-direct and Linus'
> > trees and a build failure and generated several warnings so I used the
> > version from next-20131031.
> > 
> > The dt-rh tree gained a conflict against the powerpc tree.
> > 
> > The kvm-ppc tree gained a conflict against the powerpc tree.
> > 
> > The leds tree gained a conflict against the powerpc tree.
> > 
> > The tty tree lost its build failure.
> 
> 
> on x86_64, when CONFIG_PCI is not enabled:
> 
> arch/x86/built-in.o: In function `pci_xen_swiotlb_init_late':
> (.text+0x102cc): undefined reference to `pci_request_acs'
> arch/x86/built-in.o: In function `pci_xen_swiotlb_init':
> (.init.text+0x3f6c): undefined reference to `pci_request_acs'

Stefano,

Please fix that. I think it is commit 83862ccfc0a03212fde43b4ac29c28381828768b
Author: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Date:   Thu Oct 10 13:40:44 2013 +0000

    xen/arm,arm64: enable SWIOTLB_XEN

that is causing this. Is it safe to add:

       depends on PCI

back on it?

Thanks.

> 
> 
> -- 
> ~Randy
