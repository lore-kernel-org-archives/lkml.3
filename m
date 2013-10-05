Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762Ab3JFGKq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 02:10:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46093 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609Ab3JFGKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 02:10:45 -0400
Date: Sat, 5 Oct 2013 16:41:48 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Alex Williamson <alex.williamson@redhat.com>, dwmw2@infradead.org,
        iommu@lists.linux-foundation.org, ddutile@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] intel-iommu: Fix leaks in pagetable freeing
Message-ID: <20131005234148.GB18223@kroah.com>
References: <20130615161614.2107.41044.stgit@bling.home>
 <20131002084431.GA20568@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131002084431.GA20568@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 10:44:31AM +0200, Borislav Petkov wrote:
> On Sat, Jun 15, 2013 at 10:27:19AM -0600, Alex Williamson wrote:
> > At best the current code only seems to free the leaf pagetables and
> > the root.  If you're unlucky enough to have a large gap (like any
> > QEMU guest with more than 3G of memory), only the first chunk of leaf
> > pagetables are freed (plus the root).  This is a massive memory leak.
> > This patch re-writes the pagetable freeing function to use a
> > recursive algorithm and manages to not only free all the pagetables,
> > but does it without any apparent performance loss versus the current
> > broken version.
> > 
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > Cc: stable@vger.kernel.org
> > ---
> > 
> > Suggesting for stable, would like to see some soak time, but it's
> > hard to imagine this being any worse than the current code.
> 
> Btw, I have a backport for the 3.0.x series which builds fine here, in
> case you guys are interested :)

Thanks, now applied.

greg k-h
