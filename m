Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039AbaBMTcf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:32:35 -0500
Received: from mail-vb0-f41.google.com ([209.85.212.41]:46452 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbaBMTcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:32:32 -0500
MIME-Version: 1.0
In-Reply-To: <16729.1392318161@warthog.procyon.org.uk>
References: <1391791751-2533-1-git-send-email-miklos@szeredi.hu>
	<19258.1392306854@warthog.procyon.org.uk>
	<20140213162534.GB4026@tucsk.piliscsaba.szeredi.hu>
	<20106.1392309770@warthog.procyon.org.uk>
	<CAJfpegtTDgLY=koYwg8m=snyD8FQ_EFyvLWErhcQ1jprAcOrrA@mail.gmail.com>
	<CA+55aFxE+v-RpHd1zNdw4COrkXmdT5btuE6Xei4oyeWSzeGHLw@mail.gmail.com>
	<16729.1392318161@warthog.procyon.org.uk>
Date: Thu, 13 Feb 2014 11:32:31 -0800
X-Google-Sender-Auth: Tsp22TYAJXLLZPBdiGGZQPMPA84
Message-ID: <CA+55aFyT9_XSFQwv82Qwv5US7QMOvW8RhbsxOa8B2mm3MChWLA@mail.gmail.com>
Subject: Re: [PATCH 00/13] cross rename v4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bruce Fields <bfields@fieldses.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Zach Brown <zab@redhat.com>,
        Jan Kara <jack@suse.cz>, Andy Lutomirski <luto@amacapital.net>,
        "mszeredi@suse.cz" <mszeredi@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 11:02 AM, David Howells <dhowells@redhat.com> wrote:
>
> Whilst that does seem reasonable, what about all the other software that
> iterates over a directory?  Some of that is surely not going to know about
> DT_WHT.

So?

Remeber: whiteout entries do not exist "normally". No normal apps
should care or see them, since the whole and only point of them is
when they are part of a union mount (in which case they are not
visible).

So the "how do you see whiteouts" is really only about the raw
filesystem mount when *not* in the normal place.

IOW, it's not like these guys are going to show up in users home
directories etc. It's more like a special device node than a file - we
need to care about some basic system management interfaces, not about
"random apps". So "coreutils" is the primary user, although I guess a
few IT people would prefer for things like Nautilus etc random file
managers to be able to show them nicely too. But if they show up as an
icon with a question mark on them or whatever, that's really not a big
deal either.

Sure, maybe they'll look odd in some graphical file chooser *if*
somebody makes them show up, but I think creation of a whiteout - if
we allow it at all outside of the union mount itself - should be a
root-only thing (the same way mknod is) so quite frankly, it falls
under "filesystem corruption makes my directory listings look odd -
cry me a river".

(I do think we should allow creation - but for root only - for
management and testing purposes, but I really think it's a secondary
issue, and I do think we should literally use "mknod()" - either with
a new S_IFWHT or even just making use of existing S_IFCHR just so you
could use the user-space "mknod" to create it with some magic
major/minor combination.

               Linus
