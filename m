Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751236Ab3KRKyz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 05:54:55 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:38928 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab3KRKyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 05:54:46 -0500
Date: Mon, 18 Nov 2013 11:54:43 +0100
From: Simon Baatz <gmbnomis@gmail.com>
To: Helge Deller <deller@gmx.de>
Cc: Benjamin LaHaise <bcrl@kvack.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-aio@kvack.org, linux-kernel@vger.kernel.org,
        linux-parisc@vger.kernel.org
Subject: Re: [PATCH] aio: fix D-cache aliasing issues
Message-ID: <20131118105443.GA19633@schnuecks.de>
References: <20131115220529.GA3160@ls3530.box>
 <1384555325.2003.39.camel@dabdike.int.hansenpartnership.com>
 <20131116200717.GA18939@schnuecks.de>
 <20131116200959.GA14098@kvack.org>
 <528933BC.50806@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528933BC.50806@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Helge,

On Sun, Nov 17, 2013 at 10:23:08PM +0100, Helge Deller wrote:
> On 11/16/2013 09:09 PM, Benjamin LaHaise wrote:
> > On Sat, Nov 16, 2013 at 09:07:18PM +0100, Simon Baatz wrote:
> >> On Fri, Nov 15, 2013 at 02:42:05PM -0800, James Bottomley wrote:
> >>> On Fri, 2013-11-15 at 23:05 +0100, Helge Deller wrote:
> >>>> When a user page mapping is released via kunmap*() functions, the D-cache needs
> >>>> to be flushed via flush_dcache_page() to avoid D-cache aliasing issues.
> >>>>
> >>>> This patch fixes aio on the parisc platform (and probably others).
> >>>
> >>> This should be flush_kernel_dcache_page().  flush_dcache_page() is for
> >>> full coherency but for unmap, we know the page was coherent going in and
> >>> may have been modified by the kernel, so only the kernel view needs to
> >>> be sync'd.  Technically, by the kernel API, the flush should be done
> >>> *before* unmapping.  This would have mattered on parisc until we did
> >>> flush via tmpalias which means we no-longer care if the mapping for the
> >>> flush exists or not because we always recreate it via the tmpalias
> >>> pages.
> >>
> >> On ARM, flush_kernel_dcache_page() actually assumes that the page is
> >> mapped.  It avoids double flushing of highmem pages by not flushing
> >> in those cases where kunmap_atomic() already takes care of flushing.
> > 
> > Helge -- are you going to resubmit a version of this patch that makes the 
> > recommended change?
> 
> Sure, I'll do. May need some time for testing the various machine types though.
> Maybe in the end you can drop my patch since we might be able to fix it in the 
> parisc arch code.

Could you provide me with the test case(s) you are running to
reproduce the problem?  I could test this on aliasing D-cache on ARM
as well. Since kmap/kunmap do not flush in general on ARM, we
might need the explicit flushes here.


- Simon
