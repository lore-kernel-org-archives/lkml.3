Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803Ab3EATGS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 15:06:18 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36878 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756120Ab3EATGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 15:06:10 -0400
Date: Wed, 1 May 2013 21:05:53 +0200
From: Jens Axboe <axboe@kernel.dk>
To: Kent Overstreet <koverstreet@google.com>
Cc: akpm@linux-foundation.org, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Bcache fixes for 3.10
Message-ID: <20130501190553.GC7800@kernel.dk>
References: <20130430195214.GH9931@google.com>
 <20130501072616.GH7800@kernel.dk>
 <20130501185450.GA4057@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130501185450.GA4057@moria.home.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 01 2013, Kent Overstreet wrote:
> On Wed, May 01, 2013 at 09:26:16AM +0200, Jens Axboe wrote:
> > On Tue, Apr 30 2013, Kent Overstreet wrote:
> > > Hey Jens, this is everything I've got ready for 3.10 - there's _still_
> > > one more bug I'm trying to track down.
> > > 
> > > Andrew - I've got patches that rip out the pkey() and pbtree() macros,
> > > but they're somewhat tied up with some other nontrivial refactorings so
> > > I think I'm going to wait a bit on those.
> > > 
> > > The following changes since commit cef5279735d3f6f0243e626963e6d5c84efade0a:
> > > 
> > >   bcache: Disable broken btree fuzz tester (2013-04-08 13:33:49 -0700)
> > > 
> > > are available in the git repository at:
> > > 
> > >   http://evilpiepirate.org/git/linux-bcache.git bcache-for-upstream
> > > 
> > > for you to fetch changes up to cd66f1f69ed40270bb34e20b25a8111bc72a1b2a:
> > > 
> > >   bcache: Use bd_link_disk_holder() (2013-04-24 13:15:17 -0700)
> > > 
> > > ----------------------------------------------------------------
> > > Kent Overstreet (8):
> > >       bcache: Take data offset from the bdev superblock.
> > >       bcache: Set ra_pages based on backing device's ra_pages
> > >       bcache: Hack around stuff that clones up to bi_max_vecs
> > >       bcache: Correctly check against BIO_MAX_PAGES
> > >       bcache: Fix merge_bvec_fn usage for when it modifies the bvm
> > >       bcache: Make sure blocksize isn't smaller than device blocksize
> > >       bcache: Allocator cleanup/fixes
> > >       bcache: Use bd_link_disk_holder()
> > > 
> > >  drivers/md/bcache/alloc.c   |  74 +++++++++++++-------
> > >  drivers/md/bcache/bcache.h  |  48 ++++++++++---
> > >  drivers/md/bcache/btree.c   |   8 +--
> > >  drivers/md/bcache/io.c      |  35 ++++++----
> > >  drivers/md/bcache/request.c |   2 +-
> > >  drivers/md/bcache/super.c   | 166 +++++++++++++++++++++++++++-----------------
> > >  6 files changed, 215 insertions(+), 118 deletions(-)
> > 
> > This is what I got, when I pulled it in:
> > 
> > Merge made by the 'recursive' strategy.
> >  drivers/md/bcache/alloc.c   |  72 +++++++++++++------
> >  drivers/md/bcache/bcache.h  |  47 ++++++++++---
> >  drivers/md/bcache/btree.c   |   3 +-
> >  drivers/md/bcache/io.c      |  35 ++++++----
> >  drivers/md/bcache/request.c |   2 +-
> >  drivers/md/bcache/super.c   | 166 +++++++++++++++++++++++++++-----------------
> >  6 files changed, 213 insertions(+), 112 deletions(-)
> > 
> > I only see the same 8 commits there. What happened? Please check
> > for-3.10/drivers and verify it looks as you expect.
> 
> Oh, were you expecting me to rebase? Result looks good, though.

Nope, in fact your series was on top of the last commit I got from you,
cef52797. Only non-bcache in between. Just wondering how that 215
insertions and 118 deletions becames 213/112 for that case.

-- 
Jens Axboe

