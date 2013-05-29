Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967111Ab3E2XC2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 19:02:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50986 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966322Ab3E2XCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 19:02:21 -0400
Date: Wed, 29 May 2013 16:01:49 -0700
From: Zach Brown <zab@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: [RFC PATCH] vfs: add permute operation
Message-ID: <20130529230149.GJ2363@lenny.home.zabbo.net>
References: <20130527153313.GC1842@tucsk.piliscsaba.szeredi.hu>
 <20130528173631.GB2363@lenny.home.zabbo.net>
 <CAJfpegtpj7s5gOe3k=47PMzKC71ndzg7N2kYRdtRbGXwkA_2Mg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegtpj7s5gOe3k=47PMzKC71ndzg7N2kYRdtRbGXwkA_2Mg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> +static void sort_parents3(struct dentry **p)
> >> +void sort_parents(struct dentry **p, unsigned *nump)
> >
> > Yikes, that's a bunch of fiddly code.  Is it *really* worth all that to
> > avoid calling the generic sort helpers?
> 
> AFAICS, I cannot make the compare function transitive, e.g.:  A is
> descendant of C but B is unrelated.  Then what should cmp(A, B) and
> cmp(B, C) return?

Ah, of course.  I wasn't reading closely enough.

- z
