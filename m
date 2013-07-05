Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965029Ab3GERzK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 13:55:10 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50176 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757476Ab3GERzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 13:55:08 -0400
Date: Fri, 5 Jul 2013 18:54:56 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Waiman Long <waiman.long@hp.com>
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
Message-ID: <20130705175456.GT4165@ZenIV.linux.org.uk>
References: <1373035656-40600-1-git-send-email-Waiman.Long@hp.com>
 <20130705150224.GS4165@ZenIV.linux.org.uk>
 <51D6E646.6020703@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51D6E646.6020703@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 05, 2013 at 11:29:10AM -0400, Waiman Long wrote:
> >I've just pushed such commit into vfs.git#for-linus; please, do the rest
> >on top of it.  And keep it bisectable, i.e. so that at any intermediate
> >point the tree would build and work.
> 
> I am sorry. I didn't change anything in the dentry structure in
> patch 3. So putting patches 4-11 on top of it won't break the build.

*gyah*...  I'd missed the !@#!# macro you've added there.  Could you
explain the reasons for using it at all?  Not to mention anything
else, you've missed
#  define d_refcount(d)                 ((d)->d_count)
in Lustre.  What's the point of your macro (d_refcount -> d_count), anyway?  
All references outside of fs/namei.c, fs/dcache.c, include/linux/dcache.h
should be via d_count(dentry) anyway...
