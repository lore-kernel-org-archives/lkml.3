Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbaAWHyL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 02:54:11 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:12089 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750831AbaAWHyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 02:54:09 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvAIAGPJ4FJ5LKVw/2dsb2JhbABbgwyDOrN2hVCBDBd0giUBAQEEOhwjEAgDGAklDwUlAyETHodmxQsXFo5mB4Q4BJghkhmDQSg
Date: Thu, 23 Jan 2014 18:53:56 +1100
From: Dave Chinner <david@fromorbit.com>
To: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v5 00/22] Rewrite XIP code and add XIP support to ext4
Message-ID: <20140123075356.GM13997@dastard>
References: <cover.1389779961.git.matthew.r.wilcox@intel.com>
 <20140123074825.GL13997@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140123074825.GL13997@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 06:48:25PM +1100, Dave Chinner wrote:
> On Wed, Jan 15, 2014 at 08:24:18PM -0500, Matthew Wilcox wrote:
> > This series of patches add support for XIP to ext4.  Unfortunately,
> > it turns out to be necessary to rewrite the existing XIP support code
> > first due to races that are unfixable in the current design.
> > 
> > Since v4 of this patchset, I've improved the documentation, fixed a
> > couple of warnings that a newer version of gcc emitted, and fixed a
> > bug where we would read/write the wrong address for I/Os that were not
> > aligned to PAGE_SIZE.
> > 
> > I've dropped the PMD fault patch from this set since there are some
> > places where we would need to split a PMD page and there's no way to do
> > that right now.  In its place, I've added a patch which attempts to add
> > support for unwritten extents.  I'm still in two minds about this; on the
> > one hand, it's clearly a win for reads and writes.  On the other hand,
> > it adds a lot of complexity, and it probably isn't a win for pagefaults.
> 
> FYI, this may just be pure coincidence, but shortly after the first
> boot of a machine with this patchset on 3.13 the root *ext3*
> filesystem started having problems.  It now gives persistent ENOSPC
> errors when there's 2.3GB of space free (on a 8GB partition), even
> though e2fsck says the filesystem is clean and error free.
> 
> Fmeh.
> 
> Update: I've just removed the patchset, rebuilt the kernel and the
> ENOSPC problem is still there. So it may be co-incidence, but given
> that it is persistent something is screwed got screwed up in the
> filesytem.

OK, false alarm - it is co-incidence. The damn root filesystem ran
out of inodes. Can you beleive that you're only allowed 600k inodes
in an 8GB filesystems? Sheesh! :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
