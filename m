Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbaFKJdE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 05:33:04 -0400
Received: from mail04-md.ns.itscom.net ([175.177.155.114]:33604 "EHLO
	mail04-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251AbaFKJdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 05:33:03 -0400
From: "J. R. Okajima" <hooanon05g@gmail.com>
Subject: Re: Linux 3.15 .. and continuation of merge window
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20140611011036.GV18016@ZenIV.linux.org.uk>
References: <CA+55aFw3A=ycq4kRpsDDoV4+rzg0z2kwfE9C9Bg1nSwiYfUpLw@mail.gmail.com> <13591.1402284634@jrobl> <20140611011036.GV18016@ZenIV.linux.org.uk>
Date: Wed, 11 Jun 2014 18:32:58 +0900
Message-ID: <26914.1402479178@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Al Viro:
> So I suspect that the right fix is a bit trickier - in addition to check
> on the fast path (i.e. when trylock gets us the lock on parent), we need
> to
> 	* get rcu_read_lock() before dropping ->d_lock.
> 	* check if dentry is already doomed right after taking rcu_read_lock();
> if not, any value we might see in ->d_parent afterwards will point to object
> not freed until we drop rcu_read_lock.
>
> IOW, something like the delta below.  Comments?

I will try testing later.
For now, as a comment before testing, the patch looks weird for me. It
checks d_lockref.count twice during d_lockref.lock held. It must be the
same result, isn't it? Or does it mean that denty can be handled by
lockref_mark_dead() even if d_lockref.lock is held?


J. R. Okajima
