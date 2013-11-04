Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab3KDWaU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 17:30:20 -0500
Received: from fieldses.org ([174.143.236.118]:58479 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957Ab3KDWaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 17:30:16 -0500
Date: Mon, 4 Nov 2013 17:30:14 -0500
From: Bruce Fields <bfields@fieldses.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [git pull] fixes for 3.12-final
Message-ID: <20131104223014.GA8828@fieldses.org>
References: <20131103015803.GK13318@ZenIV.linux.org.uk>
 <CA+55aFy3tAeLYL3_+PbeD15p6PGS-P7bs8fMUaRVSC0OCzvq6w@mail.gmail.com>
 <20131103195452.GL13318@ZenIV.linux.org.uk>
 <CA+55aFwW9s3GCa+zNTMg7m44-cj2RdJp7wRpCnPUvQHm9xYnFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwW9s3GCa+zNTMg7m44-cj2RdJp7wRpCnPUvQHm9xYnFg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 03, 2013 at 03:39:14PM -0800, Linus Torvalds wrote:
> On Sun, Nov 3, 2013 at 11:54 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > IIRC, at some point such an attempt has seriously hurt iget() on 32bit
> > boxen, so we ended up deciding not to go there.  Had been years ago,
> > though...
> 
> Yeah, I think the circumstances have changed. 32-bit is less
> important, and iget() is much less critical than it used to be (all
> *normal* inode lookups are through the direct dentry pointer).
> 
> Sure, ARM is a few years away from 64-bit being common, but it's
> happening. And I suspect even 32-bit ARM doesn't have the annoying
> issues that x86-32 had with 64-bit values (namely using up a lot of
> the register space).
> 
> So unless there's something hidden that makes it really nasty, I do
> suspect that a "u64 i_ino" would just be the right thing to do. Rather
> than adding workarounds for our current odd situation on 32-bit
> kernels (and just wasting time on 64-bit kernels).

I'm all for it, though I'm worried about:

	$ git grep '\bi_ino\b'|wc -l
	1746

so would prefer a more modest (and possibly stable-appropriate) fix for
3.13 while we sort out what i_ino's being used for.

--b.
