Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043Ab3KPUH3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 15:07:29 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:53174 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901Ab3KPUHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 15:07:21 -0500
Date: Sat, 16 Nov 2013 21:07:18 +0100
From: Simon Baatz <gmbnomis@gmail.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de>, Benjamin LaHaise <bcrl@kvack.org>,
        linux-aio@kvack.org, linux-kernel@vger.kernel.org,
        linux-parisc@vger.kernel.org
Subject: Re: [PATCH] aio: fix D-cache aliasing issues
Message-ID: <20131116200717.GA18939@schnuecks.de>
References: <20131115220529.GA3160@ls3530.box>
 <1384555325.2003.39.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384555325.2003.39.camel@dabdike.int.hansenpartnership.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 02:42:05PM -0800, James Bottomley wrote:
> On Fri, 2013-11-15 at 23:05 +0100, Helge Deller wrote:
> > When a user page mapping is released via kunmap*() functions, the D-cache needs
> > to be flushed via flush_dcache_page() to avoid D-cache aliasing issues.
> > 
> > This patch fixes aio on the parisc platform (and probably others).
> 
> This should be flush_kernel_dcache_page().  flush_dcache_page() is for
> full coherency but for unmap, we know the page was coherent going in and
> may have been modified by the kernel, so only the kernel view needs to
> be sync'd.  Technically, by the kernel API, the flush should be done
> *before* unmapping.  This would have mattered on parisc until we did
> flush via tmpalias which means we no-longer care if the mapping for the
> flush exists or not because we always recreate it via the tmpalias
> pages.

On ARM, flush_kernel_dcache_page() actually assumes that the page is
mapped.  It avoids double flushing of highmem pages by not flushing
in those cases where kunmap_atomic() already takes care of flushing.


- Simon
