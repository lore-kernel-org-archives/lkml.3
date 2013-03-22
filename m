Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932786Ab3CVGJ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 02:09:59 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40543 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012Ab3CVGJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 02:09:58 -0400
Date: Fri, 22 Mar 2013 06:09:53 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [CFT] Re: VFS deadlock ?
Message-ID: <20130322060953.GN21522@ZenIV.linux.org.uk>
References: <CA+55aFyWNkOnrQ41xCAU8q5sVXdq1-u2P8n+quLY50OdiFo3Zw@mail.gmail.com>
 <20130322001257.GH21522@ZenIV.linux.org.uk>
 <CA+55aFz5Ce7h2ja0m++tENXuG-1d346VNu9N=ZKy2UfojaSf0g@mail.gmail.com>
 <20130322012208.GJ21522@ZenIV.linux.org.uk>
 <CA+55aFzPD08kJi=x8wLBi5FAjr1TqSGXWbv5KXy5Ymm0PJL0wA@mail.gmail.com>
 <20130322014037.GK21522@ZenIV.linux.org.uk>
 <20130322043715.GL21522@ZenIV.linux.org.uk>
 <CA+55aFzUobqDR0RSh8t18m32BdTvm4k7j2PCseXpFVCH_gR=Fw@mail.gmail.com>
 <20130322051817.GM21522@ZenIV.linux.org.uk>
 <CA+55aFzbV81KQh_f0=wti9=_6=PXu37z0+NJymhDvzv13GgpuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzbV81KQh_f0=wti9=_6=PXu37z0+NJymhDvzv13GgpuA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 10:33:27PM -0700, Linus Torvalds wrote:

> Ok, that's kind of ugly, but shouldn't be a correctness issue. It
> should still work - just cycle through inodes quite aggressivelydue to
> no longer re-using them - so I suspect Dave could test it (with the
> extra line removed I pointed out just a moment ago).
> 
> And I wonder how big of a deal the aggressive dentry deletion is.
> Maybe it's even ok to allocate/free the inodes all the time. The whole
> "get the inode hash lock and look it up there" can't be all that
> wonderful either. It takes the inode->i_lock for each entry it finds
> on the hash list, which looks horrible. I suspect our slab allocator
> isn't much worse than that, although the RCU freeing of the inodes
> could end up being problematic.

Hell knows...  At the very least, I'd expect /proc/self to be fairly hot.
During the boot time - /proc/mounts, /proc/filesystems, /proc/cmdline...
Dunno.  Would be interesting to slap a printk into proc_lookup_de() and
see how much (and what) does it hit on a busy system...
