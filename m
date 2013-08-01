Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934Ab3HAAX7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 20:23:59 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:24750 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750918Ab3HAAX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 20:23:57 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjgFADSq+VF5LPxHgWdsb2JhbABbDr0DhS6BHBcOAQEWJiiCJAEBBTocMwgDGAklDwUlAyEBEogPuRIWj3iECwOXXooiigJQKg
Date: Thu, 1 Aug 2013 10:23:41 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Namjae Jeon <linkinjeon@gmail.com>,
        adilger.kernel@dilger.ca, bpm@sgi.com, elder@kernel.org,
        hch@infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        xfs@oss.sgi.com, a.sangwan@samsung.com,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: Re: [PATCH 1/3] fs: Introduce new flag FALLOC_FL_COLLAPSE_RANGE
Message-ID: <20130801002341.GI7118@dastard>
References: <1375281721-15840-1-git-send-email-linkinjeon@gmail.com>
 <20130731220154.GA11378@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130731220154.GA11378@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 06:01:54PM -0400, Theodore Ts'o wrote:
> Have you considered what happens if you have a 10 megabyte file, of
> which the first 5 megs are mmap'ed into a userspace process.
> 
> Now suppose you call COLLAPASE_RANGE on a one megabyte range starting
> at offset 1024k from the beginning of the file.
> 
> Does the right thing happen to the mmap'ed region in memory?

Implementation detail. like a hole punch, it needs to invalidate the
range that it is operating over so mmap()d regions are refaulted
after the operation is done.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
