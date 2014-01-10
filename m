Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198AbaAJASX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 19:18:23 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:49198 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbaAJASU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 19:18:20 -0500
MIME-Version: 1.0
In-Reply-To: <20140110000642.GN10323@ZenIV.linux.org.uk>
References: <20140109162731.12500986@gandalf.local.home>
	<20140109214239.GD29910@parisc-linux.org>
	<20140109165012.391db81e@gandalf.local.home>
	<20140109223127.GM10323@ZenIV.linux.org.uk>
	<CA+55aFzCTPYEQCPnLBi1CwmMTocVqCFiCuJ391HkVx1CMw61ug@mail.gmail.com>
	<20140109182523.5b50131f@gandalf.local.home>
	<20140109182756.17abaaa8@gandalf.local.home>
	<1389310626.15209.92.camel@localhost>
	<CA+55aFzd2nw=JU4s0u=PJbATK0bwhm0kot3zRH=anLLT6THRFQ@mail.gmail.com>
	<20140110000642.GN10323@ZenIV.linux.org.uk>
Date: Fri, 10 Jan 2014 08:18:18 +0800
X-Google-Sender-Auth: ig9ZWLsxN7jpB910lwwyIJjBh4E
Message-ID: <CA+55aFwVNAKAqyR8gA+pewz2qSjDCq2w+NwN-vmChoMKSz-idg@mail.gmail.com>
Subject: Re: [PATCH] vfs: Fix possible NULL pointer dereference in inode_permission()
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Smalley <sds@tycho.nsa.gov>, "Theodore Ts'o" <tytso@mit.edu>,
        stable <stable@vger.kernel.org>, Paul Moore <paul@paul-moore.com>,
        LKML <linux-kernel@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>,
        Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, 2014 at 8:06 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Sure, we can separate the simple "just do call_rcu(...->free_inode)" case
> and hit it whenever full ->free_inode is there and ->destroy_inode isn't.
> Not too pretty, but removal of tons of boilerplate might be worth doing
> that anyway.

Yeah.

> But ->destroy_inode() is still needed for cases where fs
> has its own idea of inode lifetime rules.  Again, check what XFS is doing
> in that area...

Ok, so we can't change destroy_inode, and we'd need to add a new op
for just freeing it.

Painful mainly because there are so many filesystems, but it shouldn't
be *complicated*.

> There's an extra source of headache, BTW - what about the "LSM stacking"
> crowd and their plans?

LSM stacking is a pipedream right  now anyway, isn't it? It's been
talked about for years and years, I've never seen a patch-set that is
even remotely something we'd seriously consider.

            Linus
