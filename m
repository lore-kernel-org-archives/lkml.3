Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953Ab3H2EqN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 00:46:13 -0400
Received: from gate.crashing.org ([63.228.1.57]:49700 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753261Ab3H2EqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 00:46:11 -0400
Message-ID: <1377751465.4028.20.camel@pasglop>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Waiman Long <Waiman.Long@hp.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Date: Thu, 29 Aug 2013 14:44:25 +1000
In-Reply-To: <CA+55aFyMeK+bAvkqi_HpShqm7Des6uriVP_xp+BJqD0ASCVL0g@mail.gmail.com>
References: <1375758759-29629-1-git-send-email-Waiman.Long@hp.com>
	 <1375758759-29629-2-git-send-email-Waiman.Long@hp.com>
	 <CA+55aFyMeK+bAvkqi_HpShqm7Des6uriVP_xp+BJqD0ASCVL0g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-08-28 at 18:40 -0700, Linus Torvalds wrote:
> Just FYI: I've merged two preparatory patches in my tree for the whole
> lockref thing. Instead of applying your four patches as-is during the
> merge window, I ended up writing two patches that introduce the
> concept and use it in the dentry code *without* introducing any of the
> new semantics yet.
> 
> Waiman, I attributed the patches to you, even if they don't actually
> look much like any of the patches you sent out. And because I was
> trying very hard to make sure that no actual semantics changed, my
> version doesn't have the dget_parent() lockless update code, for
> example. I literally just did a search-and-replace of "->d_count" with
> "->d_lockref.count" and then I fixed up a few things by hand (undid
> one replacement in a comment, and used the helper functions where they
> were semantically identical).
> 
>  You don't have to rewrite your patches if you don't want to, I'm
> planning on cherry-picking the actual code changes during the merge
> window.

I've somewhat lost track of this, will I need some arch support for
powerpc ?

Cheers,
Ben.


