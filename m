Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab3IMUbl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 16:31:41 -0400
Received: from mail-vb0-f43.google.com ([209.85.212.43]:65261 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287Ab3IMUbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 16:31:39 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxizbVmQE2Y94BRj3kDFdf6hzNHuy-O0qBFw3jnT_mMLw@mail.gmail.com>
References: <20130910222924.GB13318@ZenIV.linux.org.uk>
	<20130910153520.14e49cd32feb16d45eb8abac@linux-foundation.org>
	<20130910223624.GC13318@ZenIV.linux.org.uk>
	<20130910154116.cc4afe048213a779040ea3cc@linux-foundation.org>
	<20130910224823.GE13318@ZenIV.linux.org.uk>
	<20130910225934.GF13318@ZenIV.linux.org.uk>
	<CA+55aFwXXsk47WrAqF6yuVXOQHuNpxT7x-=MmLsNBptyzjH1zQ@mail.gmail.com>
	<CA+55aFxz2r3voP=W0oCns5MzMqBaeYxMLxp5AxRxjY23K3nvuA@mail.gmail.com>
	<CA+55aFxnq2hjx1Aw7+iFuGnZp4sRK3HYK0Kfipz1gEYubOdnYQ@mail.gmail.com>
	<CA+55aFyaRsk-KkjppTnqDxy8+y5z9Yvi3TpMZwgGJ7ad7kwM4g@mail.gmail.com>
	<20130913200000.GT13318@ZenIV.linux.org.uk>
	<CA+55aFxizbVmQE2Y94BRj3kDFdf6hzNHuy-O0qBFw3jnT_mMLw@mail.gmail.com>
Date: Fri, 13 Sep 2013 16:31:38 -0400
X-Google-Sender-Auth: Xt4kBweHzdkIk58zoVWNRUkVy8c
Message-ID: <CA+55aFyZOBa=+zOXT5tanvM+wN-vgb6vKhuWuF1Au7x1wSsX5w@mail.gmail.com>
Subject: Re: linux-next: manual merge of the akpm tree with Linus' tree
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>, Glauber Costa <glommer@openvz.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 4:25 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Yes. And I found the opposite bug in one place: when we are collecting
> dentries by walking the parents etc, we do *not* hold the global RCU
> lock, so we cannot use the "d_lru_shrink_list()" thing after all. It's
> correct as far as the internal logic of fs/dcache.c goes, but it
> violates the global LRU list rules. So I replaced that with a
> dentry_lru_del() followed by a d_shrink_add() instead.

Actually, I replaced it with d_lru_del()+d_shrink_add(), because afaik
we should be guaranteed that the dentry in question is on the global
RCU list (we checked that refcount is 0, and it's not on a local
list).

Agreed?

The patch I sent out already had that version, I just "documented" my first one.

             Linus
