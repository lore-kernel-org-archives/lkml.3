Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758615AbaLKTJB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 14:09:01 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:31297 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbaLKTI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 14:08:59 -0500
Date: Thu, 11 Dec 2014 14:08:36 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Joerg Roedel <jroedel@suse.de>
Cc: Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] swiotlb: Warn on allocation failure in
 swiotlb_alloc_coherent
Message-ID: <20141211190836.GA18992@laptop.dumpdata.com>
References: <1417174149-31210-1-git-send-email-joro@8bytes.org>
 <1417174149-31210-2-git-send-email-joro@8bytes.org>
 <20141201202802.GC21626@laptop.dumpdata.com>
 <20141202144122.GI3156@suse.de>
 <20141202184615.GA32622@laptop.dumpdata.com>
 <20141203102652.GL3156@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141203102652.GL3156@suse.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 11:26:52AM +0100, Joerg Roedel wrote:
> On Tue, Dec 02, 2014 at 01:46:15PM -0500, Konrad Rzeszutek Wilk wrote:
> > On Tue, Dec 02, 2014 at 03:41:22PM +0100, Joerg Roedel wrote:
> > > On Mon, Dec 01, 2014 at 03:28:03PM -0500, Konrad Rzeszutek Wilk wrote:
> > > > On Fri, Nov 28, 2014 at 12:29:07PM +0100, Joerg Roedel wrote:
> > > > > From: Joerg Roedel <jroedel@suse.de>
> > > > > 
> > > > > Print a warning when all allocation tries have been failed
> > > > > and the function is about to return NULL. This prepares for
> > > > > calling the function with __GFP_NOWARN to suppress
> > > > > allocation failure warnings before all fall-backs have
> > > > > failed.
> > > > 
> > > > This can be quite noisy. Especially the dump-stack.
> > > 
> > > Well, this is as noisy as the dump_stack()s from the page-allocator when
> > > the first allocation try fails. The goal of the first two patches in
> > 
> > Right, on the first allocation. Subsequent allocations won't be so noisy
> > in the page-allocator (I think?).
> 
> >From the code in mm/page_alloc.c (function warn_alloc_failed) it doesn't
> look like a one-time warning. The dmesg I have seen from a failing
> kernel also shows a lot of these messages.
> 
> So having the warning at the end of swiotlb_alloc_coherent won't be any
> more noisy than the (removed) warnings from the page allocator.

OK, then Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> 
> 
> 	Joerg
> 
