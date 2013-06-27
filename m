Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160Ab3F0BHB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 21:07:01 -0400
Received: from one.firstfloor.org ([193.170.194.197]:39452 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731Ab3F0BHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 21:07:00 -0400
Date: Thu, 27 Jun 2013 03:06:58 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Andi Kleen <andi@firstfloor.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v2 1/2] spinlock: New spinlock_refcount.h for lockless
 update of refcount
Message-ID: <20130627010658.GL6123@two.firstfloor.org>
References: <1372268603-46748-1-git-send-email-Waiman.Long@hp.com>
 <1372268603-46748-2-git-send-email-Waiman.Long@hp.com>
 <20130626201713.GH6123@two.firstfloor.org>
 <51CB57F6.6010003@hp.com>
 <20130626212221.GI6123@two.firstfloor.org>
 <51CB7898.5070206@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51CB7898.5070206@hp.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In the uncontended case, doing spin_unlock_wait will be similar to
> spin_can_lock. This, when combined with a cmpxchg, is still faster
> than doing 2 atomic operations in spin_lock/spin_unlock.

I'm totally against any new users of spin_unlock_wait()

It has bizarre semantics, most likely will make various
lock optimizations impossible, it's race condition hell
for most users etc.

spin_can_lock() is not quite as bad has a lot of the similar problems.

> BTW, spin_can_lock is just the negation of spin_is_locked.

e.g. with elision it's not.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
