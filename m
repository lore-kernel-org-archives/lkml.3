Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab3JCGOx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 02:14:53 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41535 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278Ab3JCGOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 02:14:52 -0400
Date: Thu, 3 Oct 2013 07:14:49 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [rfc][possible solution] RCU vfsmounts
Message-ID: <20131003061449.GA23460@ZenIV.linux.org.uk>
References: <20130928202728.GK13318@ZenIV.linux.org.uk>
 <CA+55aFzrjiM6bgqNgdckJGAZks2fR8ZD+R_5AqxvrnS64DD3ow@mail.gmail.com>
 <20130929060601.GL13318@ZenIV.linux.org.uk>
 <CA+55aFyGY7hZTDhWiyWBe+oSkxd2GzoYWGhvXtGTyZKL-3PZ1w@mail.gmail.com>
 <20130929181047.GM13318@ZenIV.linux.org.uk>
 <20130930194921.GS13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130930194921.GS13318@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 08:49:21PM +0100, Al Viro wrote:
> * btrfs: wants btrfs_root_readonly(BTRFS_I(inode)->root) usable in
> ->permission().  Delayed freeing of struct btrfs_root, perhaps?

Not needed, actually - it's only checked with MAY_WRITE, and we don't
pass that in RCU mode.

Anyway, I've slapped what looks like a sufficient set of synchronize_rcu()
in affected filesystems and re-pushed.  Result is at least supposed to cover
all of them.  It still might bugger your memory, chew the disks, etc., so
it's only for testing on scratch boxen at that point.

Still, review and (if you are really brave) testing would be very much
appreciated.

I'll post the patchset on top of the current mainline in a few.
