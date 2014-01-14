Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428AbaANVbF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 16:31:05 -0500
Received: from fieldses.org ([174.143.236.118]:46287 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327AbaANVas (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 16:30:48 -0500
Date: Tue, 14 Jan 2014 16:30:44 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Richard Hipp <drh@sqlite.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Jeff Layton <jlayton@redhat.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        nfs-ganesha-devel@lists.sourceforge.net,
        samba-technical@lists.samba.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Hipp <drh@hwaci.com>
Subject: Re: [PATCH v5 13/14] locks: skip deadlock detection on FL_FILE_PVT
 locks
Message-ID: <20140114213044.GD23999@fieldses.org>
References: <1389277187-18211-1-git-send-email-jlayton@redhat.com>
 <1389277187-18211-14-git-send-email-jlayton@redhat.com>
 <52CF05B5.5080700@amacapital.net>
 <20140109194930.1692fbbe@tlielax.poochiereds.net>
 <CALCETrXp-G2t9Lfd+tbyzWtXeBw+vLHWE4M7-297HQzyFDVU_g@mail.gmail.com>
 <20140114192713.GA22262@fieldses.org>
 <CALCETrWmOu-RVXNYmL--RMaiOiOMYVv5qd1+jfY0j8GZHh0rWg@mail.gmail.com>
 <CALwJ=MyRRjL9kXMdQgACJ6GDTMoMzMJcckuvKk1NBqJD2G07pg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALwJ=MyRRjL9kXMdQgACJ6GDTMoMzMJcckuvKk1NBqJD2G07pg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 04:21:53PM -0500, Richard Hipp wrote:
> SQLite uses only F_SETLK, never F_SETLKW.  Doesn't that mean that SQLite
> will work the same with or without deadlock detection?  Doesn't deadlock
> detection only come into play with F_SETLKW?

That's correct.

> > >> (Actually, what happens if you receive a signal which waiting on a file
> > lock?)
> > >
> > > Return -EINTR.
> >
> 
> Huh.  SQLite is not checking for EINTR if fcntl(F_SETLK,...) fails.  Should
> it be?  Or does EINTR only come up for F_SETLKW?

I don't know--I wonder if a distributed filesystem, for example, might
allow even a non-blocking lock request to be interrupted?  Might be
interesting to check what nfs does.

--b.

> 
> We do check for EINTR and retry for other system calls (read(), write(),
> fallocate(), ftruncate(), close(), chmod(), open(), maybe others too).
