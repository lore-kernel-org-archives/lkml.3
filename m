Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab3JYO4a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 10:56:30 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58204 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595Ab3JYO42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 10:56:28 -0400
Date: Fri, 25 Oct 2013 15:56:25 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [git pull] a couple of fixes for rc7
Message-ID: <20131025145625.GF13318@ZenIV.linux.org.uk>
References: <20131025142547.GE13318@ZenIV.linux.org.uk>
 <CA+55aFx2XQvf1pbhoRP7EJL=We04d3E0i0-DY3gCfcqv7T76Hg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFx2XQvf1pbhoRP7EJL=We04d3E0i0-DY3gCfcqv7T76Hg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 25, 2013 at 03:33:46PM +0100, Linus Torvalds wrote:
> On Fri, Oct 25, 2013 at 3:25 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > nfsd performance regression fix + seq_file lseek(2) fix.
> > Please, pull from the usual place -
> > git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus
> 
> Not acceptable.
> 
> fs/file_table.c: In function ???fput???:
> fs/file_table.c:320:4: warning: passing argument 1 of
> ???schedule_delayed_work??? from incompatible pointer type [enabled by
> default]
>     schedule_delayed_work(&delayed_fput_work, 1);
>     ^
> In file included from include/linux/srcu.h:34:0,
>                  from include/linux/notifier.h:15,
>                  from include/linux/memory_hotplug.h:6,
>                  from include/linux/mmzone.h:797,
>                  from include/linux/gfp.h:4,
>                  from include/linux/slab.h:14,
>                  from fs/file_table.c:9:
> include/linux/workqueue.h:594:60: note: expected ???struct delayed_work
> *??? but argument is of type ???struct work_struct *???
>  static inline bool schedule_delayed_work(struct delayed_work *dwork,
> 
> Plase stop sending me untested crap that doesn't even compile cleanly!

Oh, hell...  git cherry-pick (for the wrong place, at that) instead of just
pushing the bugger as it was - it sat on top of previous vfs.git#for-linus.
Mea culpa ;-/

I've pushed the right branch now; should propagate in a few minutes.
Head should be at 05e16745c.
