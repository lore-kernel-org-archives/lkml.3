Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab3JHQFS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 12:05:18 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:48819 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647Ab3JHQFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 12:05:15 -0400
Date: Tue, 8 Oct 2013 18:06:01 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Landley <rob@landley.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCH 4/3] vfs: Allow rmdir to remove mounts in all but
 the current mount namespace
Message-ID: <20131008160601.GJ14242@tucsk.piliscsaba.szeredi.hu>
References: <87a9kkax0j.fsf@xmission.com>
 <CAJfpeguv+7giYNpAuXE9Ja_9BEwB0-fZBVgRSeVqpzSXgQYZ6Q@mail.gmail.com>
 <8761v7h2pt.fsf@tw-ebiederman.twitter.com>
 <CAJfpegtT7y-1HhbEVAMKkdQugTG_w7G_epGtQHGvQLpcZB5FVA@mail.gmail.com>
 <87li281wx6.fsf_-_@xmission.com>
 <87a9ioo37a.fsf_-_@xmission.com>
 <20131007043919.GB10284@mail.hallyn.com>
 <87vc191sf2.fsf@xmission.com>
 <CALCETrUaubASZyeoNZcYxn5-GJO68=Ng=GYmas7K_OBsjM7f0Q@mail.gmail.com>
 <87d2ngyb02.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d2ngyb02.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 07, 2013 at 03:25:17PM -0700, Eric W. Biederman wrote:
> Andy Lutomirski <luto@amacapital.net> writes:
> 
> > On Mon, Oct 7, 2013 at 7:55 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> >> "Serge E. Hallyn" <serge@hallyn.com> writes:
> >>
> >>> Quoting Eric W. Biederman (ebiederm@xmission.com):
> >>>>
> >>>> Programs have been known to test for empty directories by attempting
> >>>> to remove them.  To keep from violating the principle of least
> >>>> surprise don't let directories the caller can see with someting
> >>>> mounted on them be deleted.
> >>>
> >>> Do you think we should do the same thing for over-mounted file at
> >>> vfs_unlink()?
> >>
> >> We easily could.

And for vfs_rename()?

I think the risks of changing behavior outweigh the benefits.  How many times
did you have to remove or rename a mounted file or directory?  It's very rarely
needed.

Thanks,
Miklos
