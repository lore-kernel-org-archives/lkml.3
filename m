Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777Ab3FWMAa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 08:00:30 -0400
Received: from 8bytes.org ([85.214.48.195]:38257 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293Ab3FWMA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 08:00:29 -0400
Date: Sun, 23 Jun 2013 14:00:25 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iommu/amd: Only unmap large pages from the first pte
Message-ID: <20130623120020.GB2557@8bytes.org>
References: <20130621203242.7475.19737.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130621203242.7475.19737.stgit@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Sun Jun 23 14:00:27 2013
X-DSPAM-Confidence: 0.9981
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 51c6e35b20868239215697
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 02:33:19PM -0600, Alex Williamson wrote:
> If we use a large mapping, the expectation is that only unmaps from
> the first pte in the superpage are supported.  Unmaps from offsets
> into the superpage should fail (ie. return zero sized unmap).  In the
> current code, unmapping from an offset clears the size of the full
> mapping starting from an offset.  For instance, if we map a 16k
> physically contiguous range at IOVA 0x0 with a large page, then
> attempt to unmap 4k at offset 12k, 4 ptes are cleared (12k - 28k) and
> the unmap returns 16k unmapped.  This potentially incorrectly clears
> valid mappings and confuses drivers like VFIO that use the unmap size
> to release pinned pages.
> 
> Fix by refusing to unmap from offsets into the page.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> Cc: stable@vger.kernel.org

Applied, thanks for fixing this.


