Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965081Ab3E2IMT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 04:12:19 -0400
Received: from mail-qe0-f44.google.com ([209.85.128.44]:65476 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814Ab3E2IMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 04:12:14 -0400
MIME-Version: 1.0
X-Originating-IP: [188.6.195.195]
In-Reply-To: <20130528173631.GB2363@lenny.home.zabbo.net>
References: <20130527153313.GC1842@tucsk.piliscsaba.szeredi.hu>
	<20130528173631.GB2363@lenny.home.zabbo.net>
Date: Wed, 29 May 2013 10:12:12 +0200
Message-ID: <CAJfpegtpj7s5gOe3k=47PMzKC71ndzg7N2kYRdtRbGXwkA_2Mg@mail.gmail.com>
Subject: Re: [RFC PATCH] vfs: add permute operation
From: Miklos Szeredi <miklos@szeredi.hu>
To: Zach Brown <zab@redhat.com>
Cc: Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 7:36 PM, Zach Brown <zab@redhat.com> wrote:
> Some quick thoughts:
>
>> Permute the location of files.  E.g.  'permute(A, B, C)' is equivalent to A->B,
>> B->C and C->A.  This is essentially a series of renames done as a single atomic
>> operation.
>
> Hmm.  Can we choose a more specific name than 'permute'?  To me,
> ->permute() tells me just as much about the operation as
> ->do_something().  {multi,bulk,mass}_rename()?  renamev()?

It's not just plain muti-rename, but a cyclic one.  Maybe cyclic_rename()?

>> +static void sort_parents3(struct dentry **p)
>> +void sort_parents(struct dentry **p, unsigned *nump)
>
> Yikes, that's a bunch of fiddly code.  Is it *really* worth all that to
> avoid calling the generic sort helpers?

AFAICS, I cannot make the compare function transitive, e.g.:  A is
descendant of C but B is unrelated.  Then what should cmp(A, B) and
cmp(B, C) return?

>
>> +     if (WARN_ON(num > PERMUTE_MAX) ||
>> +         WARN_ON(num < 2))
>> +             return -EINVAL;
>
> And in other places this is a BUG?  Why not, like the syscall, limit the
> arguments to three if we're serious about that limitation?

I could be more consistent with the BUGs.  Doing it with 3 args is not
necessarily good, since then we can't do loops and the chance of a
copy-paste error is increased.

Thanks,
Miklos
