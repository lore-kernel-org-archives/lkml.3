Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab3CKPYI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 11:24:08 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:62230 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab3CKPYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 11:24:06 -0400
Date: Mon, 11 Mar 2013 08:24:00 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, jmoyer@redhat.com,
        zab@redhat.com
Subject: Re: [PATCHSET wq/for-3.10-tmp] workqueue: implement workqueue with
 custom worker attributes
Message-ID: <20130311152400.GK24522@htj.dyndns.org>
References: <1362194662-2344-1-git-send-email-tj@kernel.org>
 <513C61B9.5030004@cn.fujitsu.com>
 <20130310120113.GC24522@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130310120113.GC24522@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 10, 2013 at 05:01:13AM -0700, Tejun Heo wrote:
> Hey, Lai.
> 
> On Sun, Mar 10, 2013 at 06:34:33PM +0800, Lai Jiangshan wrote:
> > > This patchset contains the following 31 patches.
> > > 
> > >  0001-workqueue-make-sanity-checks-less-punshing-using-WAR.patch
> > 
> > >  0002-workqueue-make-workqueue_lock-irq-safe.patch
> > 
> > workqueue_lock protects too many things. We can introduce different locks
> > for different purpose later.
> 
> I don't know.  My general attitude toward locking is the simpler the
> better.  None of the paths protected by workqueue_lock are hot.
> There's no actual benefit in making them finer grained.

Heh, I need to make workqueues and pools protected by a mutex rather
than spinlock, so I'm breaking out the locking after all.  This is
gonna be a separate series of patches and it seems like there are
gonna be three locks - wq_mutex (pool and workqueues), pwq_lock
(spinlock protecting pwqs), wq_mayday_lock (lock for the mayday list).

Thanks.

-- 
tejun
