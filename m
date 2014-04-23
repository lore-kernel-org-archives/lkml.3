Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757683AbaDWTN1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 15:13:27 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:57077 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881AbaDWTNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 15:13:25 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <E1Wd2Os-00061e-GU@fencepost.gnu.org>
References: <1398253172-9221-1-git-send-email-jlayton@redhat.com>
 <E1Wcyo3-0000Eg-UC@fencepost.gnu.org> <20140423112843.77889d16@tlielax.poochiereds.net>
 <E1Wd2Os-00061e-GU@fencepost.gnu.org>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Wed, 23 Apr 2014 21:13:03 +0200
Message-ID: <CAKgNAkju-vzgJ=p568ksLy7L63qo_3tHxf_tzNZrDgGoD_vNUA@mail.gmail.com>
Subject: Re: [RFC][glibc PATCH] fcntl-linux.h: add new definitions and manual
 updates for open file description locks
To: ams@gnu.org
Cc: Jeff Layton <jlayton@redhat.com>,
        "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Rich Felker <dalias@libc.org>, samba-technical@lists.samba.org,
        Ganesha NFS List <nfs-ganesha-devel@lists.sourceforge.net>,
        "Carlos O'Donell" <carlos@redhat.com>,
        "Stefan (metze) Metzmacher" <metze@samba.org>,
        Christoph Hellwig <hch@infradead.org>,
        Boaz Harrosh <bharrosh@panasas.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 9:00 PM, Alfred M. Szmidt <ams@gnu.org> wrote:
>    > Likewise.  You infact write that it does get the lock information
>    > later in the document wrt. F_OFD_GETLK.
>
>    Sorry, I disagree here...GETLK is really a misnomer, IMO. TESTLK
>    would have been a better name.

I'm inclined to agree.

>    GETLK are used is to "get the first lock".
>
>    It's a way to test whether a particular lock can be applied, and to
>    return information about a conflicting lock if it can't. If, for
>    instance there is no conflicting lock, then you don't "get" any
>    lock information back (l_type just gets reset to F_UNLCK).
>
> While I kinda see your point, it isn't what GETLK does; it really does
> get you information about the first lock -- you're not testing
> anything.  It is also the terminology used in the POSIX standard.

The POSIX wording is a little confused. For example, what does "first"
mean in this context? F_GETLK returns information about one
(arbitrarily selected) lock that blocks a lock you would like to
place. So, I'm inclined to agree with Jeff -- this really is a "test"
(or "can I lock it") operation.

Of course, the operation has no reliable use: by the time it returns
the information might already be out of date. I suspect that it was
designed to solve the problem: "My F_GETLK operation failed. Who's
blocking me?"

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
