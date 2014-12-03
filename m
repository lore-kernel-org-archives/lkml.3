Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736AbaLCK1Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 05:27:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53481 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168AbaLCK1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 05:27:24 -0500
Date: Wed, 3 Dec 2014 11:27:21 +0100
From: Joerg Roedel <jroedel@suse.de>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86, swiotlb: Try coherent allocations with
 __GFP_NOWARN
Message-ID: <20141203102721.GM3156@suse.de>
References: <1417174149-31210-1-git-send-email-joro@8bytes.org>
 <1417174149-31210-3-git-send-email-joro@8bytes.org>
 <20141201202854.GD21626@laptop.dumpdata.com>
 <20141202144551.GJ3156@suse.de>
 <20141202184648.GB32622@laptop.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141202184648.GB32622@laptop.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 01:46:48PM -0500, Konrad Rzeszutek Wilk wrote:
> On Tue, Dec 02, 2014 at 03:45:51PM +0100, Joerg Roedel wrote:
> > On Mon, Dec 01, 2014 at 03:28:54PM -0500, Konrad Rzeszutek Wilk wrote:
> > > On Fri, Nov 28, 2014 at 12:29:08PM +0100, Joerg Roedel wrote:
> > > > diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
> > > > index 77dd0ad..79b2291 100644
> > > > --- a/arch/x86/kernel/pci-swiotlb.c
> > > > +++ b/arch/x86/kernel/pci-swiotlb.c
> > > > @@ -20,6 +20,14 @@ void *x86_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
> > > >  {
> > > >  	void *vaddr;
> > > >  
> > > > +	/*
> > > > +	 * When booting a kdump kernel in high memory these allocations are very
> > > > +	 * likely to fail, as there are by default only 8MB of low memory to
> > > > +	 * allocate from. So disable the warnings from the allocator when this
> > > > +	 * happens.  SWIOTLB also implements fall-backs for failed allocations.
> > > > +	 */
> > > > +	flags |= __GFP_NOWARN;
> > > 
> > > Should this perhaps then have 'if (kdump_kernel)' around it since
> > > the use-case seems to be kdump related?
> > 
> > Hmm, I don't think this is entirely kdump specific. It can also be
> > triggered on a non-kdump kernel, it is just much more unlikely. But
> > maybe I should change the comment to something like:
> > 
> > 	/*
> > 	 * Don't print a warning when the first allocation attempt
> > 	 * fails. The swiotlb_alloc_coherent() function will print a
> > 	 * warning when the allocation of DMA memory ultimatly failed.
> > 	 */
> 
> Much better. Thank you.
> > 
> > This takes the kdump-specifics out of this change (in the end
> > kdump-kernel loaded high is just a case where this failure is much more
> > likely).
> 
> <nods>

Okay, thanks. I'll update the patch.


	Joerg

