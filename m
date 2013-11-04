Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab3KDSPo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 13:15:44 -0500
Received: from smtp.citrix.com ([66.165.176.89]:42050 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746Ab3KDSPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 13:15:43 -0500
X-IronPort-AV: E=Sophos;i="4.93,634,1378857600"; 
   d="scan'208";a="70412636"
Date: Mon, 4 Nov 2013 18:14:26 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Randy Dunlap <rdunlap@infradead.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>
Subject: Re: linux-next: Tree for Oct 30 (include/xen/swiotlb-xen.h)
In-Reply-To: <20131101193720.GB15622@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1311041801470.26077@kaball.uk.xensource.com>
References: <20131030184511.c90aa7f40fec6b2e1652f394@canb.auug.org.au> <527153A3.5020404@infradead.org> <20131101193720.GB15622@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Nov 2013, Konrad Rzeszutek Wilk wrote:
> On Wed, Oct 30, 2013 at 11:44:51AM -0700, Randy Dunlap wrote:
> > On 10/30/13 00:45, Stephen Rothwell wrote:
> > > Hi all,
> > > 
> > > News:  I am now doing an arm multi_v7_defconfig build between each merge.
> > > 
> > > Changes since 20131029:
> > > 
> > > The arm defconfig build is fixed again.
> > > 
> > > The net-next tree gained a conflict against the net tree.
> > > 
> > > The xen-tip tree gained a conflict against the arm tree.
> > > 
> > > The akpm-current tree gained a conflict against the tip tree and a build
> > > failure for which I reverted 3 commits.
> > > 
> > > Various build problems from yesterday have been resolved.
> > 
> > on x86_64:
> 
> Stefano, please fix that.
 
Thanks for the notification. I am appending the fix that I am about to
apply to xentip/linux-next.


commit bb5ebdb6a674c59cd7b5d159d6ca3c0084ee60e1
Author: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Date:   Mon Nov 4 17:54:27 2013 +0000

    swiotlb-xen: missing include dma-direction.h
    
    Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

diff --git a/include/xen/swiotlb-xen.h b/include/xen/swiotlb-xen.h
index 7b64465..8b2eb93 100644
--- a/include/xen/swiotlb-xen.h
+++ b/include/xen/swiotlb-xen.h
@@ -1,6 +1,7 @@
 #ifndef __LINUX_SWIOTLB_XEN_H
 #define __LINUX_SWIOTLB_XEN_H
 
+#include <linux/dma-direction.h>
 #include <linux/swiotlb.h>
 
 extern int xen_swiotlb_init(int verbose, bool early);
