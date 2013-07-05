Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500Ab3GEPCj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 11:02:39 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50009 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757463Ab3GEPCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 11:02:38 -0400
Date: Fri, 5 Jul 2013 16:02:24 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v5 00/12] Lockless update of reference count protected by
 spinlock
Message-ID: <20130705150224.GS4165@ZenIV.linux.org.uk>
References: <1373035656-40600-1-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373035656-40600-1-git-send-email-Waiman.Long@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 05, 2013 at 10:47:33AM -0400, Waiman Long wrote:
> v4->v5:
>  - Add a d_count() helper for readonly access of reference count and
>    change all references to d_count outside of dcache.c, dcache.h
>    and namei.c to use d_count().

Sigh...  You are breaking bisectability again.  This helper should
be introduced *first*, along with conversion to it.  Then you can
do the rest on top of that.

I've just pushed such commit into vfs.git#for-linus; please, do the rest
on top of it.  And keep it bisectable, i.e. so that at any intermediate
point the tree would build and work.
