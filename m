Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933135Ab3HNUX4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 16:23:56 -0400
Received: from 8bytes.org ([85.214.48.195]:51423 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933031Ab3HNUXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 16:23:55 -0400
Date: Wed, 14 Aug 2013 22:23:51 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: dwmw2@infradead.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] intel-iommu: Fix leaks in pagetable freeing
Message-ID: <20130814202350.GA3493@8bytes.org>
References: <20130615161614.2107.41044.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130615161614.2107.41044.stgit@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Aug 14 22:23:54 2013
X-DSPAM-Confidence: 0.9983
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 520be75a20861400791629
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 15, 2013 at 10:27:19AM -0600, Alex Williamson wrote:
> At best the current code only seems to free the leaf pagetables and
> the root.  If you're unlucky enough to have a large gap (like any
> QEMU guest with more than 3G of memory), only the first chunk of leaf
> pagetables are freed (plus the root).  This is a massive memory leak.
> This patch re-writes the pagetable freeing function to use a
> recursive algorithm and manages to not only free all the pagetables,
> but does it without any apparent performance loss versus the current
> broken version.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> Cc: stable@vger.kernel.org

Applied to iommu/fixes, thanks Alex. Will send this for v3.11 after a
couple of days in next.


