Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757851Ab3FTT0n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 15:26:43 -0400
Received: from 8bytes.org ([85.214.48.195]:35736 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863Ab3FTT0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 15:26:42 -0400
Date: Thu, 20 Jun 2013 21:26:38 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: iommu@lists.linux-foundation.org, ddutile@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] amd_iommu: Fix leak in free_pagetable()
Message-ID: <20130620192638.GD11309@8bytes.org>
References: <20130618014459.20440.73844.stgit@bling.home>
 <20130618015116.20711.90269.stgit@bling.home>
 <20130620182808.GC11309@8bytes.org>
 <1371755280.30572.4.camel@ul30vt.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371755280.30572.4.camel@ul30vt.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Jun 20 21:26:39 2013
X-DSPAM-Confidence: 0.9981
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 51c3576f20862005116848
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 01:08:00PM -0600, Alex Williamson wrote:
> On Thu, 2013-06-20 at 20:28 +0200, Joerg Roedel wrote:
> > Hmm, actually a recursive version would make more sense here. But since
> > recursion is a bad idea in the kernel, how about this approach instead:
> 
> It's a fixed maximum depth of recursion though, is it really that taboo?

Well, a recursive version would be better here because it has lower icache
impact than my patch. But the risk is if there is a bug in recursive
code and it goes on forever it will overwrite random kernel memory, with
undefined, potentially very bad, results (like data corruption, killed
filesystems and so on).

So in my opinion it is better to not take that risk whenever possible.

> > The IOMMU pagetables can have up to 3 levels, but the code
> 
> s/3/6/

Right, thanks.

> Seems like it should do the right thing

Ok, I also gave it some testing (started a vm, assigned and de-assigned
a device), so it should work as expected.

> Reviewed-by: Alex Williamson <alex.williamson@redhat.com>

Thanks,

	Joerg


