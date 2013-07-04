Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041Ab3GDFAJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 01:00:09 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47342 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab3GDFAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 01:00:06 -0400
Date: Thu, 4 Jul 2013 05:59:56 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Waiman Long <Waiman.Long@hp.com>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ian Kent <raven@themaw.net>,
        autofs mailing list <autofs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v4 04/12] auto-fs: rename d_count field of dentry to
 d_refcount
Message-ID: <20130704045956.GO4165@ZenIV.linux.org.uk>
References: <1372908808-33304-1-git-send-email-Waiman.Long@hp.com>
 <CA+55aFzKfPG=CH+vZBUQMNd32qsuxPF1D3c3DB2Dm8w1QCb1+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzKfPG=CH+vZBUQMNd32qsuxPF1D3c3DB2Dm8w1QCb1+w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 03, 2013 at 08:50:07PM -0700, Linus Torvalds wrote:
> On Wed, Jul 3, 2013 at 8:33 PM, Waiman Long <Waiman.Long@hp.com> wrote:
> > Because of the d_count name change made in dcache.h, all references
> > to d_count have to be changed to d_refcount.  There is no change in
> > logic and everything should just work.
> 
> These filesystem patches need to be just joined into the same patch
> that does the d_count -> d_refcount change.
> 
> Otherwise the kernel won't build in lots of configurations for some
> commits, which makes things like bisecting much more painful than it
> should be.
> 
> So we can't do piece-meal changes that break the build for parts of the tree.

Frankly, my preference here would be to add static inline unsigned d_count(...)
and convert the uses of ->d_count outside of fs/{dcache.c,namei.c} and
include/linux/dcache.c to it as the first commit.  All users outside those
are readers, so there's no point playing with macros in this case...
