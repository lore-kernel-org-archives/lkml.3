Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710Ab3HABIJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 21:08:09 -0400
Received: from imap.thunk.org ([74.207.234.97]:37631 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845Ab3HABIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 21:08:07 -0400
Date: Wed, 31 Jul 2013 21:07:52 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Dave Chinner <david@fromorbit.com>
Cc: Namjae Jeon <linkinjeon@gmail.com>, adilger.kernel@dilger.ca, bpm@sgi.com,
        elder@kernel.org, hch@infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        xfs@oss.sgi.com, a.sangwan@samsung.com,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: Re: [PATCH 1/3] fs: Introduce new flag FALLOC_FL_COLLAPSE_RANGE
Message-ID: <20130801010751.GD11378@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Dave Chinner <david@fromorbit.com>,
	Namjae Jeon <linkinjeon@gmail.com>, adilger.kernel@dilger.ca,
	bpm@sgi.com, elder@kernel.org, hch@infradead.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com, a.sangwan@samsung.com,
	Namjae Jeon <namjae.jeon@samsung.com>
References: <1375281721-15840-1-git-send-email-linkinjeon@gmail.com>
 <20130731220154.GA11378@thunk.org>
 <20130801002341.GI7118@dastard>
 <20130801004645.GC11378@thunk.org>
 <20130801005447.GS13468@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130801005447.GS13468@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 10:54:47AM +1000, Dave Chinner wrote:
> > It's not just the range that it's operating on, but also the region
> > beyond the range that's been collapsed out.
> 
> Yes, that's part of "the range that it is operating over".
> 
> > A quick eyeball of the patch didn't seem to show any code that handled
> > this, which is why I asked the question.
> 
> Right, but really it's the least of the problems I've noticed - the
> XFS code is fundamentally broken in many ways - once I've finished
> commenting on it, I'll have a quick look to see if the ext4 code has
> the same fundamental flaws....

Well, the fundamental flaw of potential races if the file being
collapsed has been mmap'ed and there is another process making changes
beyond the range that is being collapsed is I suspect one that is
going to be very hard to solve, short of not allowing the collapse
while there are any read/write mmap's for the file in question.

And I would think these sorts of VM issues should be handled with some
generic library functions, instead of reimplementing them from scratch
in each file system.

						- Ted
