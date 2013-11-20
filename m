Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329Ab3KTWuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 17:50:10 -0500
Received: from mailhost-z6-p4.mangoosta.org ([195.5.209.120]:22015 "EHLO
	smtp-delay1.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754021Ab3KTWuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 17:50:07 -0500
X-Greylist: delayed 407 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Nov 2013 17:50:07 EST
Date: Wed, 20 Nov 2013 23:42:54 +0100
From: Damien Wyart <damien.wyart@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [git pull] vfs.git bits and pieces
Message-ID: <20131120224254.GA3939@brouette>
References: <20131120174211.GF10323@ZenIV.linux.org.uk>
 <20131120174712.GG10323@ZenIV.linux.org.uk>
 <CA+55aFw_SuTAtTM0YTgiGf1pq4v4j5jbB1af=ExxjyFRbAJ4Ow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw_SuTAtTM0YTgiGf1pq4v4j5jbB1af=ExxjyFRbAJ4Ow@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > BTW, something odd happened to mm/memory.c - either a mangled patch
> > or a lost followup:

> >     commit ea1e7ed33708
> >     mm: create a separate slab for page->ptl allocation

> > Fair enough, and yes, it does create that separate slab. The problem
> > is, it's still using kmalloc/kfree for those beasts -
> > page_ptl_cachep isn't used at all...

* Linus Torvalds <torvalds@linux-foundation.org> [2013-11-20 14:33]:
> Ok, it looks straightforward enough to just replace the kmalloc/kfree
> with using a slab allocation using the page_ptl_cachep pointer. I'd do
> it myself, but I would like to know how it got lost? Also, much
> testing to make sure the cachep is initialized early enough.

The initial sending had the proper hunks at the end, so something really
got lost afterwards...
https://lkml.org/lkml/2013/10/22/129

-- 
Damien Wyart
