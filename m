Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262AbaD2XUW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 19:20:22 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46858 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbaD2XUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 19:20:19 -0400
Date: Wed, 30 Apr 2014 00:20:13 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, Miklos Szeredi <miklos@szeredi.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: dcache shrink list corruption?
Message-ID: <20140429232013.GM18016@ZenIV.linux.org.uk>
References: <20140429160139.GA3113@tucsk.piliscsaba.szeredi.hu>
 <CA+55aFwJ0mAnkP6rwv3_nDHZ1U3SH_pbRCj-bBN5SdRVR2FCZA@mail.gmail.com>
 <CAJfpegvbzQc2y12_MV6MZ398ggjkc1w73Px7pXViGnSm=+syNA@mail.gmail.com>
 <20140429181610.GJ18016@ZenIV.linux.org.uk>
 <20140429191015.GK18016@ZenIV.linux.org.uk>
 <20140429211851.GA32204@dastard>
 <20140429214842.GL18016@ZenIV.linux.org.uk>
 <CA+55aFwcWcyRpwv3us9BbnsjUEfEr1mRjz4RWbcy_tSnZjc_Sw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwcWcyRpwv3us9BbnsjUEfEr1mRjz4RWbcy_tSnZjc_Sw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 04:04:11PM -0700, Linus Torvalds wrote:
> But at a minimum, we have "d_op->d_prune()" that would now be possibly
> be called for the old dentry *after* a new dentry has been allocated.
> Not to mention the inode not having been dropped. So it looks like a
> disaster where the filesystem now ends up having concurrent "live"
> dentries for the same entry.  Even if one of them is on its way out,
> it's still visible to the filesystem. That makes me very
> uncomfortable.
> 
> I'm starting to think that Miklos' original patch (perhaps with the
> spinlock split to at least be one per superblock) is the most
> straightforward approach after all. It's annoying having to add locks
> here, but the whole pruning path should not be a hotpath, so maybe
> it's not actually a big deal.

FWIW, my solution is more or less working; I'll give more local beating
and post it... 
