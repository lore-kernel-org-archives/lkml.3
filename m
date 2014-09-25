Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbaIYOkk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 10:40:40 -0400
Received: from 8bytes.org ([81.169.241.247]:58122 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752983AbaIYOkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 10:40:37 -0400
Date: Thu, 25 Sep 2014 16:40:35 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        mstowe@redhat.com
Subject: Re: [PATCH 0/2] iommu: Fix regression in IOMMU grouping
Message-ID: <20140925144035.GC8306@8bytes.org>
References: <20140919154944.14485.743.stgit@gimli.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140919154944.14485.743.stgit@gimli.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 10:03:00AM -0600, Alex Williamson wrote:
> We've had surprisingly little fallout from the DMA alias changes, but
> unfortunately one regression has popped up.  We have an AMD system
> that seems to use the SATA controller to master transactions for the
> legacy IDE controller and they are different slots on the root complex.
> The IVRS reports 00:11.0 (SATA) as an alias from 00:14.1 (IDE), which
> doesn't work with the new, converged PCI IOMMU grouping code, where
> we've made a simplifying assumption that aliases will be to the same
> slot.
> 
> To fix this, we need to rip out that assumption and write the alias
> search code that I was unable to come up with previously.  I think
> this can now do the chaining of aliases, which I referenced in the
> removed comments.  Any sort of multi-level aliases are exceptionally
> unlikely, but I think this code can now handle whatever firmware and
> alias quirks can throw at it.

Applied to core, thanks Alex.

> 
> I know this is late for 3.17, but this is a regression from the prior
> code.  If reviews and testing can give us the confidence to put it in
> for 3.17, that would be my preference.  I've also marked it for stable
> in case we want to loop back through that way.  Thanks,

The change is too big to make it into v3.17 at this point of the
development cycle, so I queued it up for the upcoming merge window.


	Joerg

