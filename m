Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657AbaKAIiM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 04:38:12 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57261 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbaKAIiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 04:38:09 -0400
Date: Sat, 1 Nov 2014 08:38:04 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] dealing with proc_ns_follow_link() and "namespace" dentries
Message-ID: <20141101083804.GO7996@ZenIV.linux.org.uk>
References: <20141013062945.GX7996@ZenIV.linux.org.uk>
 <87r3ybwq0b.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r3ybwq0b.fsf@x220.int.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2014 at 03:42:28PM -0700, Eric W. Biederman wrote:

> >From looking at your proposed code that doesn't look like it will be
> any more difficult to maintain from the namespace side.  So I have no
> objects with moving the code in that direction. 
> 
> > 	It's obviously a project for the next cycle and it'll require
> > some cooperation between vfs and userns trees, but not too much of it -
> > all we really need is a never-changed commit embedding that structure into
> > all ...ns and passing _that_ to proc_{alloc,free}_inum() replacements
> > Merged both into vfs.git #for-next and usern one.  We can do that right
> > after -rc1.  Incidentally, it might make sense to move refcount into that
> > common piece as well, but that's independent from the stuff above.
> 
> That sounds like a reasonable direction to go.  I think your schedule
> may be a tad optimistic time-wise, if for no other reason that code
> reviews take time, but that plan should work.

OK, interim branch (_completely_ untested, and there's quite a bit of
work remaining) is in vfs.git#nsfs.  It will be refactored; moreover,
most of that stuff will move out from fs/proc/namespaces.c - either into
fs/nsfs.c or into kernel/nsproxy.c.  And purely VFS followups are not even
touched yet - I know what I want to do, and I think there's no obstacles
left, but that's a separate story.  "Filesystem for ns dentries/inodes"
part is done, though (modulo debugging and moving it out of fs/proc).

I wonder if we would be better off not using proc_alloc_inum() there -
it's not hard to do a separate allocator, especially since there's no
requirements re non-intersecting sets of inumbers for procfs and for this.
That's the last part shared with procfs...

Anyway, I'm going down right now (nearly 5am here), so further fun will have
to wait a bit...
