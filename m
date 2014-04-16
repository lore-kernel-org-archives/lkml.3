Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257AbaDPUBJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 16:01:09 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:37958 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845AbaDPUBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 16:01:07 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20140416145746.66b7441c@tlielax.poochiereds.net>
References: <20140416145746.66b7441c@tlielax.poochiereds.net>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Wed, 16 Apr 2014 22:00:46 +0200
Message-ID: <CAKgNAkgqZDcT0jda8XS+4HrJzXjzwehqciHbkNuAVY3fNkH4zQ@mail.gmail.com>
Subject: Re: should we change the name/macros of file-private locks?
To: Jeff Layton <jlayton@redhat.com>
Cc: libc-alpha <libc-alpha@sourceware.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "Carlos O'Donell" <carlos@redhat.com>,
        Michael Kerrisk-manpages <mtk.manpages@googlemail.com>,
        samba-technical@lists.samba.org,
        Ganesha NFS List <nfs-ganesha-devel@lists.sourceforge.net>,
        Jeremy Allison <jra@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CC += Jeremy Allison]

On Wed, Apr 16, 2014 at 8:57 PM, Jeff Layton <jlayton@redhat.com> wrote:
> Sorry to spam so many lists, but I think this needs widespread
> distribution and consensus.
>
> File-private locks have been merged into Linux for v3.15, and *now*
> people are commenting that the name and macro definitions for the new
> file-private locks suck.
>
> ...and I can't even disagree. They do suck.
>
> We're going to have to live with these for a long time, so it's
> important that we be happy with the names before we're stuck with them.

So, to add my perspective: The existing byte-range locking system has
persisted (despite egregious faults) for well over two decades. One
supposes that Jeff's new improved version might be around
at least as long. With that in mind, and before setting in stone (and
pushing into POSIX) a model of thinking that thousands of programmers
will live with for a long time, it's worth thinking about names.

> Michael Kerrisk suggested several names but I think the only one that
> doesn't have other issues is "file-associated locks", which can be
> distinguished against "process-associated" locks (aka classic POSIX
> locks).

The names I have suggested are:

    file-associated locks

or

   file-handle locks

or (using POSIX terminology)

    file-description locks

but that last might be a bit confusing to people who are not
standards-aware. (The POSIX standard defines the thing that a "file
descriptor" refers to as a "file description"; other people often call
that thing a "file handle" or an "open file table entry" or a "struct
file". The POSIX term is precise and unambiguous, but, unfortunately,
the term is not common outside the standard and is also easily
mistaken for "file descriptor".)

> At the same time, he suggested that we rename the command macros since
> the 'P' suffix would no longer be relevant. He suggested something like
> this:
>
>     F_FA_GETLK
>     F_FA_SETLK
>     F_FA_SETLKW
>
> That would also make them more visually distinguishable from the
> classic F_GETLK/F_SETLK/F_SETLKW commands. I like that change in
> particular, as the original macros names would be easy to typo.
>
> I think we'd also need to rename how these are reported in /proc/locks.
> Currently they have a type label of "FLPVT". I'd suggest that we
> change that to "FASSOC". For v3.15, this is the only part we'd
> absolutely have to change before it ships. The rest I can fix up in
> v3.16.
>
> Does this sound like a reasonable set of changes to make? Does anyone
> else have a better set of names they can suggest? Speak now, or forever
> hold your peace!

I think none of my suggested terms is perfect, but they at least have
the virtue of being better than "file-private lock", since the term
"private" is somewhat nonsensical. It may be that someone else has an
even better idea for a term for these new kinds of locks.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
