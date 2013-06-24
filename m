Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab3FXQcI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 12:32:08 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:30150 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab3FXQcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 12:32:06 -0400
Message-ID: <51C87477.9020505@hp.com>
Date: Mon, 24 Jun 2013 12:31:51 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Waiman Long <Waiman.Long@hp.com>
CC: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH RFC 0/2] Lockless update of reference count protected
 by spinlock
References: <1371660605-19225-1-git-send-email-Waiman.Long@hp.com>
In-Reply-To: <1371660605-19225-1-git-send-email-Waiman.Long@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2013 12:50 PM, Waiman Long wrote:
> This patchset supports a generic mechanism to atomically update
> a reference count that is protected by a spinlock without actually
> acquiring the lock itself. If the update doesn't succeeed, the caller
> will have to acquire the lock and update the reference count in the
> the old way.  This will help in situation where there is a lot of
> spinlock contention because of frequent reference count update.
>
> The new mechanism was designed in such a way to easily retrofit
> into existing code with minimal changes. Both the spinlock and the
> reference count can be accessed in the same way as before.
>
> The d_lock and d_count fields of the struct dentry in dcache.h was
> modified to use the new mechanism. This serves as an example of how
> to convert existing spinlock and reference count combo to use the
> new way of locklessly updating the reference count.
>
> Signed-off-by: Waiman Long<Waiman.Long@hp.com>
>
> Waiman Long (2):
>    spinlock: New spinlock_refcount.h for lockless update of refcount
>    dcache: Locklessly update d_count whenever possible
>
>   fs/dcache.c                       |   14 +++-
>   include/linux/dcache.h            |   22 +++++-
>   include/linux/spinlock_refcount.h |  145 +++++++++++++++++++++++++++++++++++++
>   include/linux/spinlock_types.h    |   19 +++++
>   4 files changed, 196 insertions(+), 4 deletions(-)
>   create mode 100644 include/linux/spinlock_refcount.h
>

So far, I haven't received any feedback on this patch. I would really 
appreciate if someone could let me know if there is any improvement that 
will make this patch more merge-able.

Thanks,
Longman
