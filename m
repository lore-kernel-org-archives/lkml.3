Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090AbaIZUir (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 16:38:47 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:40575 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111AbaIZUip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 16:38:45 -0400
MIME-Version: 1.0
In-Reply-To: <20140914194738.GS7996@ZenIV.linux.org.uk>
References: <20140914194738.GS7996@ZenIV.linux.org.uk>
Date: Fri, 26 Sep 2014 22:38:43 +0200
Message-ID: <CAGhQ9Vww4g8+uFAjR+6kBhE+6uxyifnze=qBDCJNDWaySR6MOg@mail.gmail.com>
Subject: Re: [git pull] vfs fixes
From: Joachim Eastwood <manabian@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 September 2014 21:47, Al Viro <viro@zeniv.linux.org.uk> wrote:
> double iput() on failure exit in lustre, racy removal of spliced dentries
> from ->s_anon in __d_materialise_dentry() plus a bunch of assorted RCU pathwalk
> fixes.  Please, pull from the usual place -
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus
>
> Shortlog:
> Al Viro (5):
>       [fix] lustre: d_make_root() does iput() on dentry allocation failure
>       move the call of __d_drop(anon) into __d_materialise_unique(dentry, anon)
>       fix bogus read_seqretry() checks introduced in b37199e
>       don't bugger nd->seq on set_root_rcu() from follow_dotdot_rcu()
>       be careful with nd->inode in path_init() and follow_dotdot_rcu()
>
> Diffstat:
>  drivers/staging/lustre/lustre/llite/llite_lib.c |    2 +-
>  fs/dcache.c                                     |    8 +++-
>  fs/namei.c                                      |   52 ++++++++++++++---------
>  3 files changed, 39 insertions(+), 23 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
