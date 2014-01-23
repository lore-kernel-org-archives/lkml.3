Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122AbaAWJBm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 04:01:42 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:24930 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751416AbaAWJBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 04:01:40 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvAIAN/Z4FJ5LKVw/2dsb2JhbABbgwyDOrN2hVCBDhd0giUBAQEEOhwjEAgDGAklDwUlAyETHodmxRcXFo5mB4Q4BJghkhmDQSg
Date: Thu, 23 Jan 2014 20:01:34 +1100
From: Dave Chinner <david@fromorbit.com>
To: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v5 00/22] Rewrite XIP code and add XIP support to ext4
Message-ID: <20140123090133.GR13997@dastard>
References: <cover.1389779961.git.matthew.r.wilcox@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1389779961.git.matthew.r.wilcox@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 08:24:18PM -0500, Matthew Wilcox wrote:
> This series of patches add support for XIP to ext4.  Unfortunately,
> it turns out to be necessary to rewrite the existing XIP support code
> first due to races that are unfixable in the current design.
> 
> Since v4 of this patchset, I've improved the documentation, fixed a
> couple of warnings that a newer version of gcc emitted, and fixed a
> bug where we would read/write the wrong address for I/Os that were not
> aligned to PAGE_SIZE.
> 
> I've dropped the PMD fault patch from this set since there are some
> places where we would need to split a PMD page and there's no way to do
> that right now.  In its place, I've added a patch which attempts to add
> support for unwritten extents.  I'm still in two minds about this; on the
> one hand, it's clearly a win for reads and writes.  On the other hand,
> it adds a lot of complexity, and it probably isn't a win for pagefaults.

I ran this through xfstests, but ext4 in default configuration fails
too many of the tests with filesystem corruption and other cascading
failures on the quick group tests (generic/013, generic/070,
generic/075, generic/091, etc)  for me to be able to tell if adding
MOUNT_OPTIONS="-o xip" adds any problems or not....

XIP definitely caused generic/001 to fail, but other than that I
can't really tell. Still, it looks like it functions enough to be
able to add XFS support on top of. I'll get back to you with that ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
