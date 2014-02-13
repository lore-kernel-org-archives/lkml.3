Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830AbaBMTDY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:03:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20214 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790AbaBMTDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:03:22 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CA+55aFxE+v-RpHd1zNdw4COrkXmdT5btuE6Xei4oyeWSzeGHLw@mail.gmail.com>
References: <CA+55aFxE+v-RpHd1zNdw4COrkXmdT5btuE6Xei4oyeWSzeGHLw@mail.gmail.com> <1391791751-2533-1-git-send-email-miklos@szeredi.hu> <19258.1392306854@warthog.procyon.org.uk> <20140213162534.GB4026@tucsk.piliscsaba.szeredi.hu> <20106.1392309770@warthog.procyon.org.uk> <CAJfpegtTDgLY=koYwg8m=snyD8FQ_EFyvLWErhcQ1jprAcOrrA@mail.gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, Miklos Szeredi <miklos@szeredi.hu>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bruce Fields <bfields@fieldses.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Zach Brown <zab@redhat.com>,
        Jan Kara <jack@suse.cz>, Andy Lutomirski <luto@amacapital.net>,
        "mszeredi@suse.cz" <mszeredi@suse.cz>
Subject: Re: [PATCH 00/13] cross rename v4
Date: Thu, 13 Feb 2014 19:02:41 +0000
Message-ID: <16729.1392318161@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> So what do others that support this do?  Looking at the gitweb for
> ls.c in coreutils, we find:
> 
> http://git.savannah.gnu.org/gitweb/?p=coreutils.git;a=blob;f=src/ls.c
> 
>     # ifdef DT_WHT
>                     case DT_WHT:  type = whiteout;          break;
>     # endif
> 
> so that's presumably what we should use.

Whilst that does seem reasonable, what about all the other software that
iterates over a directory?  Some of that is surely not going to know about
DT_WHT.

Further, while that may sort whiteouts, what about fallthroughs?  There isn't
a DT_ symbol for that...  Fallthroughs are 'really there' in the sense that
they're positive, but they should take on the underlying object type - which
in this situation we can't retrieve:-/

I wonder if it would be possible to require filesystems that can store
fallthroughs to store the lower type in the upper dentry (ie. there is no
fallthrough type per se, but rather fallthrough-to-file, f-to-char, f-to-sym,
etc.).

David
