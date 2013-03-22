Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab3CVBjI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 21:39:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16571 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752175Ab3CVBjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 21:39:06 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CA+icZUVj4jChaGSdC5Lu4R9h-NzVx8HqT+tnve9GOMh84C5sVw@mail.gmail.com>
References: <CA+icZUVj4jChaGSdC5Lu4R9h-NzVx8HqT+tnve9GOMh84C5sVw@mail.gmail.com> <CA+icZUUqSCZeb2JOFv-OSRXAQyD+crvGqg9E0FAUF=+ZAg5vFA@mail.gmail.com> <16729.1363108768@warthog.procyon.org.uk>
To: sedat.dilek@gmail.com
Cc: dhowells@redhat.com, Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: Status of union-mount?
Date: Fri, 22 Mar 2013 01:38:55 +0000
Message-ID: <3190.1363916335@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sedat Dilek <sedat.dilek@gmail.com> wrote:

> Hmmm, sorry for asking, but when do you plan to offer a "working"
> union-mount (u-m)?

It's a maze of twisty locking problems - some of which also apply to things
like overlayfs:-(

> What's the status of the user-space tools or are they no more needed?

You need to be able to tell mount(2) that you want a union.  This is currently
done with a mount flag, but it might be portable to something in the mount
option string.

> AFAICS the original authors patched e2fsprogs etc. (see Valerie's old
> homepage [1]).

Yeah... I guess fsck programs need to be able to handle whiteout and fallthru
directory entries.

> >> Where does the development happen - in [1]?
> >
> > On a git tree on my PC - which is occasionally mirrored in [1] when I've got
> > it working.
> >
> 
> Development on your local workstation does not look like you do an
> open development.

Excuse me.  But it's quite hard to develop this on a remote git tree.
Further, I prefer not to push partially working stuff to my git tree, lest
someone pull it, try playing with it and have their fs eaten.

If someone wants it, I can mail the partially working stuff to them, but not
many people ask.

> So, it's currently only you doing the work on u-m?

Almost entirely, yes.

David
