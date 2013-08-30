Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292Ab3H3UtD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 16:49:03 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34915 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769Ab3H3UtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 16:49:00 -0400
Date: Fri, 30 Aug 2013 21:48:52 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Waiman Long <waiman.long@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
Message-ID: <20130830204852.GE13318@ZenIV.linux.org.uk>
References: <CA+55aFyq7dJnm6tfn12hLOw5qKLW2RXRFERHgZO-sOOnUmjd3g@mail.gmail.com>
 <52200DAE.2020303@hp.com>
 <CA+55aFyhTR15GBS4VNoRkcFyubEJU7a+Pzd-6VZeKoU8qB0q5Q@mail.gmail.com>
 <5220E56A.80603@hp.com>
 <CA+55aFzv9BZ2+B2NrNRRtTqnfgbH3LRSvSsUZVsy-g9OpM-8HA@mail.gmail.com>
 <5220F090.5050908@hp.com>
 <20130830194059.GC13318@ZenIV.linux.org.uk>
 <5220F811.9060902@hp.com>
 <20130830202608.GD13318@ZenIV.linux.org.uk>
 <52210225.60805@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52210225.60805@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 04:35:49PM -0400, Waiman Long wrote:

> The AIM7 test was run on a set of 16 ramdisk formated with ext3
> filesystem with the following mount options:
> barrier=0,async,noatime,nodiratime. Maybe that is a factor.

I would be really surprised if it was...  Could you slap the following
into __fput():

	struct mount *m = real_mount(mnt);
	if (unlikely(!m->mnt_ns)) {
		printk(KERN_INFO "type = %s",
			mnt->mnt_sb->s_type->name);
		WARN_ON(1);
	}
and see what it catches?  That'll need #include "fs/mount.h" in
fs/file_table.c to compile...
