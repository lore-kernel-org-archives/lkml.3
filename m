Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751754Ab3F0BhS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 21:37:18 -0400
Received: from one.firstfloor.org ([193.170.194.197]:39505 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab3F0BhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 21:37:16 -0400
Date: Thu, 27 Jun 2013 03:37:14 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Andi Kleen <andi@firstfloor.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2 1/2] spinlock: New spinlock_refcount.h for lockless
 update of refcount
Message-ID: <20130627013714.GM6123@two.firstfloor.org>
References: <1372268603-46748-1-git-send-email-Waiman.Long@hp.com>
 <1372268603-46748-2-git-send-email-Waiman.Long@hp.com>
 <20130626201713.GH6123@two.firstfloor.org>
 <51CB57F6.6010003@hp.com>
 <20130626212221.GI6123@two.firstfloor.org>
 <51CB7898.5070206@hp.com>
 <20130627010658.GL6123@two.firstfloor.org>
 <51CB9233.7020508@hp.com>
 <51CB9450.80601@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51CB9450.80601@hp.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It will be hard to know what changes will be needed without knowing
> the exact semantics of the spinlock functions with lock elision. Can
> you explain a little more what bizarre semantics you are referring
> to?

Totally independent of elision.

For example, what semantics does spin_unlock_wait() have with a ticket
lock. Where in the queue does it wait?
It doesn't really make sense with a ticket lock.

What semantics would lockdep put on it?

-Andi
