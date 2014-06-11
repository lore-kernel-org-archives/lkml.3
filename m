Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450AbaFKRhf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 13:37:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60350 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754315AbaFKRhe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 13:37:34 -0400
Date: Wed, 11 Jun 2014 19:37:30 +0200
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Reiserfs & ext3 changes for 3.16-rc1
Message-ID: <20140611173730.GA9511@quack.suse.cz>
References: <20140604202758.GC22927@quack.suse.cz>
 <CA+55aFzPvSGCorqEKRi87oCOrZN5RbUA1uUWq26WR=ZS2pNt+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFzPvSGCorqEKRi87oCOrZN5RbUA1uUWq26WR=ZS2pNt+w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 07-06-14 16:52:49, Linus Torvalds wrote:
> On Wed, Jun 4, 2014 at 1:27 PM, Jan Kara <jack@suse.cz> wrote:
> >   Hello Linus,
> >
> >   could you please pull from
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git for_linus
> >
> > to get big reiserfs cleanup from Jeff, an ext3 deadlock fix, and some small
> > cleanups.
> 
> This does not work at all for me:
> 
>   fs/reiserfs/do_balan.c: In function ‘balance_leaf_new_nodes’:
>   fs/reiserfs/do_balan.c:1248:3: error: implicit declaration of
> function ‘format_bh’ [-Werror=implicit-function-declaration]
>      RFALSE(!buffer_journaled(tb->S_new[i])
>      ^
> 
> Hmm? "format_bh()"?
  Bah, so I screwed up and apparently didn't push out my for_next branch
after merging patches from Jeff so various build bots didn't catch the
problem and I only compiled kernels without CONFIG_REISERFS_DEBUG_CHECK so
I didn't see the problem either. Anyway, I've added commit fixing this to
my for_next & for_linus branches (things now compile fine) and I'll send
you new pull request. I'm sorry for the mess.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
