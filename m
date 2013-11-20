Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab3KTWdj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 17:33:39 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:55316 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab3KTWdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 17:33:36 -0500
MIME-Version: 1.0
In-Reply-To: <20131120174712.GG10323@ZenIV.linux.org.uk>
References: <20131120174211.GF10323@ZenIV.linux.org.uk>
	<20131120174712.GG10323@ZenIV.linux.org.uk>
Date: Wed, 20 Nov 2013 14:33:35 -0800
X-Google-Sender-Auth: GoL0W7TDyyYL10QaVW5IYrg6Ywk
Message-ID: <CA+55aFw_SuTAtTM0YTgiGf1pq4v4j5jbB1af=ExxjyFRbAJ4Ow@mail.gmail.com>
Subject: Re: [git pull] vfs.git bits and pieces
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 9:47 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> BTW, something odd happened to mm/memory.c - either a mangled patch
> or a lost followup:
>
>     commit ea1e7ed33708
>     mm: create a separate slab for page->ptl allocation
>
> Fair enough, and yes, it does create that separate slab.  The problem is,
> it's still using kmalloc/kfree for those beasts - page_ptl_cachep isn't
> used at all...

Ok, it looks straightforward enough to just replace the kmalloc/kfree
with using a slab allocation using the page_ptl_cachep pointer. I'd do
it myself, but I would like to know how it got lost? Also, much
testing to make sure the cachep is initialized early enough.

Or should we just revert the commit that added the pointless/unused
slab pointer?

Andrew, Kirill, comments?

Also note the other issue Al found: see commit 2a46eed54a28 ("Wrong
page freed on preallocate_pmds() failure exit") that I just pushed
out.

                Linus
