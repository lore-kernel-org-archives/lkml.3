Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878AbaBMTUo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:20:44 -0500
Received: from mail-ve0-f175.google.com ([209.85.128.175]:53156 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbaBMTUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:20:43 -0500
MIME-Version: 1.0
In-Reply-To: <CAJfpegvjwHW5=BhvnbTYrnD6SxZwVyNj0tQGciXo_TzYKLANPQ@mail.gmail.com>
References: <1391791751-2533-1-git-send-email-miklos@szeredi.hu>
	<19258.1392306854@warthog.procyon.org.uk>
	<20140213162534.GB4026@tucsk.piliscsaba.szeredi.hu>
	<20106.1392309770@warthog.procyon.org.uk>
	<CAJfpegtTDgLY=koYwg8m=snyD8FQ_EFyvLWErhcQ1jprAcOrrA@mail.gmail.com>
	<CA+55aFxE+v-RpHd1zNdw4COrkXmdT5btuE6Xei4oyeWSzeGHLw@mail.gmail.com>
	<CAJfpegvjwHW5=BhvnbTYrnD6SxZwVyNj0tQGciXo_TzYKLANPQ@mail.gmail.com>
Date: Thu, 13 Feb 2014 11:20:42 -0800
X-Google-Sender-Auth: tqN_RPXUXozk4C5BQd8exN5O-nM
Message-ID: <CA+55aFwTz6-zwsCr9zbFGEn5B5nKBQtr_+_h0AKZnXWneBvyNg@mail.gmail.com>
Subject: Re: [PATCH 00/13] cross rename v4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
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

On Thu, Feb 13, 2014 at 10:56 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> Fair enough, that allows the thing to be listed, at least.
>
> What about creation?  A new syscall?
>
> Removal?  unlink(2)?
>
> Should stat(2) succeed with a new filetype?

I think it had better work exactly like a special node (eg character
device etc). I don't know about creation (yes, we might even fake it
with mknod(), or just say that the only way to create them is as part
of the union-fs), but removal and renaming should absolutely *not* be
a new system call. That would be a disaster for any system admin,
having to use special tools to edit the filesystem.

Obviously when it is part of a union mount, whiteouts work differently
- they must *not* show up in getdents, and you can't rename/remove a
whiteout anywhere else. But that is obviously part of the union-fs,
nor the low-level filesystem itself.

            Linus
