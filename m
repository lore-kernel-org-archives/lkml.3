Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755Ab3CWRIM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 13:08:12 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:36464 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab3CWRIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 13:08:11 -0400
X-IronPort-AV: E=Sophos;i="4.84,897,1355097600"; 
   d="scan'208";a="14451719"
Date: Sat, 23 Mar 2013 17:08:07 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        David Vrabel <david.vrabel@citrix.com>
Subject: Re: [GIT PULL] (xen) stable/for-linus-3.9-rc3-tag
In-Reply-To: <20130322210201.GA7932@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1303231705170.5135@kaball.uk.xensource.com>
References: <20130322210201.GA7932@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Mar 2013, Konrad Rzeszutek Wilk wrote:
> Hey Linus,
> 
> Please git pull the following tag:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-linus-3.9-rc3-tag
> 
> which is full of fixes. The signed tag has the details (as always) but
> this is mostly just the last stragglers of the regression bugs that this
> merge window had. There are also two normal bug-fixes in the lot.
> 
> P.S.
> We are working out the kinks in an early warning #linux-next testing framework
> so that it can give us heads up in the future - so the when the next merge
> window opens we shouldn't have surprises.
> 
> Please pull!
> 
>  arch/x86/include/asm/xen/hypercall.h |  4 +--
>  arch/x86/xen/mmu.c                   |  3 +-
>  drivers/xen/Kconfig                  |  2 +-
>  drivers/xen/events.c                 | 10 +++---
>  drivers/xen/fallback.c               |  3 +-
>  drivers/xen/xen-acpi-processor.c     |  3 ++
>  drivers/xen/xen-pciback/pci_stub.c   | 59 +++++++++++++++++++++++++++---------
>  include/xen/interface/physdev.h      |  6 ++++
>  8 files changed, 64 insertions(+), 26 deletions(-)
> 
> David Vrabel (1):
>       xen/events: avoid race with raising an event in unmask_evtchn()

Unless I am looking in the wrong place, this patch is still the same one
that breaks PV on HVM and Xen ARM guests, see:

http://marc.info/?l=xen-devel&m=136377731913034

David is aware of the issue and I think is working on an alternative
fix.
