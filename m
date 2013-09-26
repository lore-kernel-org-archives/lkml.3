Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269Ab3IZB0G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 21:26:06 -0400
Received: from cobra.newdream.net ([66.33.216.30]:33326 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777Ab3IZB0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 21:26:04 -0400
Date: Wed, 25 Sep 2013 18:26:03 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: majianpeng <majianpeng@gmail.com>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, Sage Weil <sage@newdream.net>,
        linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kent Overstreet <koverstreet@google.com>,
        Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: linux-next: build failure after merge of the ceph tree
In-Reply-To: <201309260920374598440@gmail.com>
Message-ID: <alpine.DEB.2.00.1309251824460.12714@cobra.newdream.net>
References: <20130926111500.cb583a5fe861bd4699a4e9d7@canb.auug.org.au> <201309260920374598440@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Sep 2013, majianpeng wrote:
> Sorry for that, i notice the commit 73a7075e3f6e.But i misread it.
> I'll modify this as soon as possible.

Thanks!  For now I'll drop this patch and rebase the queue against 
3.12-rc2.

Thanks, Stephen!
sage

> 
> Thanks!
> Jianpeng Ma
> >Hi Sage,
> >
> >After merging the ceph tree, today's linux-next build (x86_64
> >allmodconfig) failed like this:
> >
> >In file included from include/linux/kernel.h:14:0,
> >                 from include/linux/cache.h:4,
> >                 from include/linux/time.h:4,
> >                 from include/linux/stat.h:18,
> >                 from include/linux/module.h:10,
> >                 from fs/ceph/file.c:3:
> >fs/ceph/file.c: In function 'ceph_sync_read':
> >fs/ceph/file.c:421:21: error: 'struct kiocb' has no member named 'ki_left'
> >       (unsigned)iocb->ki_left,
> >                     ^
> >include/linux/dynamic_debug.h:79:10: note: in definition of macro 'dynamic_pr_debug'
> >        ##__VA_ARGS__);  \
> >          ^
> >include/linux/ceph/ceph_debug.h:17:2: note: in expansion of macro 'pr_debug'
> >  pr_debug("%.*s %12.12s:%-4d : " fmt,    \
> >  ^
> >fs/ceph/file.c:420:2: note: in expansion of macro 'dout'
> >  dout("sync_read on file %p %llu~%u %s\n", file, off,
> >  ^
> >fs/ceph/file.c:430:17: error: 'struct kiocb' has no member named 'ki_left'
> >       off + iocb->ki_left);
> >                 ^
> >fs/ceph/file.c:436:25: error: 'struct iov_iter' has no member named 'iov'
> >    void __user *data = i->iov[0].iov_base + i->iov_offset;
> >                         ^
> >fs/ceph/file.c:437:18: error: 'struct iov_iter' has no member named 'iov'
> >    size_t len = i->iov[0].iov_len - i->iov_offset;
> >                  ^
> >fs/ceph/file.c:458:20: error: 'struct kiocb' has no member named 'ki_left'
> >   size_t len = iocb->ki_left;
> >                    ^
> >fs/ceph/file.c:471:26: error: 'struct iov_iter' has no member named 'iov'
> >     void __user *data = i->iov[0].iov_base
> >                          ^
> >In file included from include/linux/cache.h:4:0,
> >                 from include/linux/time.h:4,
> >                 from include/linux/stat.h:18,
> >                 from include/linux/module.h:10,
> >                 from fs/ceph/file.c:3:
> >fs/ceph/file.c:473:14: error: 'struct iov_iter' has no member named 'iov'
> >     l = min(i->iov[0].iov_len - i->iov_offset,
> >              ^
> >include/linux/kernel.h:670:9: note: in definition of macro 'min'
> >  typeof(x) _min1 = (x);   \
> >         ^
> >fs/ceph/file.c:473:14: error: 'struct iov_iter' has no member named 'iov'
> >     l = min(i->iov[0].iov_len - i->iov_offset,
> >              ^
> >include/linux/kernel.h:670:21: note: in definition of macro 'min'
> >  typeof(x) _min1 = (x);   \
> >                     ^
> >include/linux/kernel.h:672:17: warning: comparison of distinct pointer types lacks a cast [enabled by default]
> >  (void) (&_min1 == &_min2);  \
> >                 ^
> >fs/ceph/file.c:473:9: note: in expansion of macro 'min'
> >     l = min(i->iov[0].iov_len - i->iov_offset,
> >         ^
> >fs/ceph/file.c:496:7: error: 'struct kiocb' has no member named 'ki_left'
> >   iocb->ki_left -= ret;
> >       ^
> >fs/ceph/file.c: In function 'ceph_sync_direct_write':
> >fs/ceph/file.c:588:24: error: 'struct iov_iter' has no member named 'iov'
> >   void __user *data = i.iov->iov_base + i.iov_offset;
> >                        ^
> >fs/ceph/file.c:589:14: error: 'struct iov_iter' has no member named 'iov'
> >   u64 len = i.iov->iov_len - i.iov_offset;
> >              ^
> >fs/ceph/file.c: In function 'ceph_aio_read':
> >fs/ceph/file.c:839:7: error: 'struct kiocb' has no member named 'ki_left'
> >   iocb->ki_left = len;
> >       ^
> >fs/ceph/file.c:870:8: error: 'struct kiocb' has no member named 'ki_left'
> >    iocb->ki_left) {
> >        ^
> >
> >Caused by commit e6c9af8b8f11 ("ceph: implement readv/preadv for sync
> >operation").  ki_left was removed by commit 73a7075e3f6e ("aio: Kill
> >aio_rw_vect_retry()") during the merge window ... basing new work for
> >v3.13 on v3.11 is a bit problematic.
> >
> >I have used the ceph tree from next-20130925 for today.
> >
> >-- 
> >Cheers,
> >Stephen Rothwell                    sfr@canb.auug.org.au
> >
