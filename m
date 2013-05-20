Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab3ETCwk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 22:52:40 -0400
Received: from ozlabs.org ([203.10.76.45]:35990 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755099Ab3ETCwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 22:52:38 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vinod Koul <vinod.koul@intel.com>
Subject: Re: linux-next: build failure after merge of the rr-fixes tree
In-Reply-To: <20130520105133.2bb50dcc4f8cf639f18f1a2c@canb.auug.org.au>
References: <20130520105133.2bb50dcc4f8cf639f18f1a2c@canb.auug.org.au>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 20 May 2013 12:20:12 +0930
Message-ID: <87d2smz7ob.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:
> Hi Rusty,
>
> After merging the rr-fixes tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>
> drivers/dma/iovlock.c: In function 'dma_pin_iovec_pages':
> drivers/dma/iovlock.c:98:21: error: dereferencing pointer to incomplete type
>    down_read(&current->mm->mmap_sem);
>                      ^
> drivers/dma/iovlock.c:101:11: error: dereferencing pointer to incomplete type
>     current->mm,
>            ^
> drivers/dma/iovlock.c:108:19: error: dereferencing pointer to incomplete type
>    up_read(&current->mm->mmap_sem);
>                    ^
>
> Caused by commit 11227d242a8c ("Hoist memcpy_fromiovec/memcpy_toiovec
> into lib/").  Clearly, net/tcp.h was indirectly including sched.h or
> asm/current.h.  Changing inclusions is fraught with problems since people
> do not follow Rule 1 (in Documentation/SubmitChecklist) consistently.  :-(

Yep, the 0day tester caught this too (it works on 32-bit unfortunately,
so I didn't see the problem).

I've not touched the #includes any more in my updated patch.

Cheers,
Rusty.
