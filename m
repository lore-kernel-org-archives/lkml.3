Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984Ab3KTWkV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 17:40:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36242 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343Ab3KTWkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 17:40:16 -0500
Date: Wed, 20 Nov 2013 14:40:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [git pull] vfs.git bits and pieces
Message-Id: <20131120144014.386293ce24e7b298ebab7b8e@linux-foundation.org>
In-Reply-To: <CA+55aFw_SuTAtTM0YTgiGf1pq4v4j5jbB1af=ExxjyFRbAJ4Ow@mail.gmail.com>
References: <20131120174211.GF10323@ZenIV.linux.org.uk>
	<20131120174712.GG10323@ZenIV.linux.org.uk>
	<CA+55aFw_SuTAtTM0YTgiGf1pq4v4j5jbB1af=ExxjyFRbAJ4Ow@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Nov 2013 14:33:35 -0800 Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, Nov 20, 2013 at 9:47 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > BTW, something odd happened to mm/memory.c - either a mangled patch
> > or a lost followup:
> >
> >     commit ea1e7ed33708
> >     mm: create a separate slab for page->ptl allocation
> >
> > Fair enough, and yes, it does create that separate slab.  The problem is,
> > it's still using kmalloc/kfree for those beasts - page_ptl_cachep isn't
> > used at all...
> 
> Ok, it looks straightforward enough to just replace the kmalloc/kfree
> with using a slab allocation using the page_ptl_cachep pointer. I'd do
> it myself, but I would like to know how it got lost? Also, much
> testing to make sure the cachep is initialized early enough.

agh, I went through hell keeping that patch alive and it appears I lost
some of it.

> Or should we just revert the commit that added the pointless/unused
> slab pointer?
> 
> Andrew, Kirill, comments?

Let's just kill it please.  We can try again for 3.14.

> Also note the other issue Al found: see commit 2a46eed54a28 ("Wrong
> page freed on preallocate_pmds() failure exit") that I just pushed
> out.

lgtm, thanks.
