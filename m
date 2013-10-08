Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab3JHQKz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 12:10:55 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:33542 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756188Ab3JHQKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 12:10:49 -0400
Date: Tue, 8 Oct 2013 18:11:35 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Landley <rob@landley.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCH 4/3] vfs: Allow rmdir to remove mounts in all but
 the current mount namespace
Message-ID: <20131008161135.GK14242@tucsk.piliscsaba.szeredi.hu>
References: <8761v7h2pt.fsf@tw-ebiederman.twitter.com>
 <CAJfpegtT7y-1HhbEVAMKkdQugTG_w7G_epGtQHGvQLpcZB5FVA@mail.gmail.com>
 <87li281wx6.fsf_-_@xmission.com>
 <87a9ioo37a.fsf_-_@xmission.com>
 <20131007043919.GB10284@mail.hallyn.com>
 <87vc191sf2.fsf@xmission.com>
 <CALCETrUaubASZyeoNZcYxn5-GJO68=Ng=GYmas7K_OBsjM7f0Q@mail.gmail.com>
 <87d2ngyb02.fsf@xmission.com>
 <20131008160601.GJ14242@tucsk.piliscsaba.szeredi.hu>
 <CALCETrWw=htmgxqq=RQztdJQ-a8c3860vmJh9Ni=Hhs0TkO3YA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWw=htmgxqq=RQztdJQ-a8c3860vmJh9Ni=Hhs0TkO3YA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 09:06:29AM -0700, Andy Lutomirski wrote:

> > I think the risks of changing behavior outweigh the benefits.  How many
> > times did you have to remove or rename a mounted file or directory?  It's
> > very rarely needed.
> 
> I do this every time I reinstall a system while running that system.
> Admittedly, mount --move works, but that's a really unpleasant
> interface.
> 
> When rename2 gets added, there could be a flag RENAME_MOVE_MOUNT to opt in.

Good point.  Opting in would be the safest for both unlinkat() and
renameat2().

Thanks,
Miklos
