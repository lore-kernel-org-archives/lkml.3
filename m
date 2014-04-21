Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941AbaDUQpb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 12:45:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055AbaDUQp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 12:45:28 -0400
Date: Mon, 21 Apr 2014 12:45:08 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Rich Felker <dalias@libc.org>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        samba-technical@lists.samba.org,
        Ganesha NFS List <nfs-ganesha-devel@lists.sourceforge.net>,
        "Carlos O'Donell" <carlos@redhat.com>,
        libc-alpha <libc-alpha@sourceware.org>,
        "Stefan (metze) Metzmacher" <metze@samba.org>
Subject: Re: [PATCH] locks: rename file-private locks to file-description
 locks
Message-ID: <20140421124508.4f2c9ca7@tlielax.poochiereds.net>
In-Reply-To: <20140421161004.GC26358@brightrain.aerifal.cx>
References: <1398087935-14001-1-git-send-email-jlayton@redhat.com>
	<20140421140246.GB26358@brightrain.aerifal.cx>
	<535529FA.8070709@gmail.com>
	<20140421161004.GC26358@brightrain.aerifal.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Apr 2014 12:10:04 -0400
Rich Felker <dalias@libc.org> wrote:

> On Mon, Apr 21, 2014 at 04:23:54PM +0200, Michael Kerrisk (man-pages) wrote:
> > On 04/21/2014 04:02 PM, Rich Felker wrote:
> > > On Mon, Apr 21, 2014 at 09:45:35AM -0400, Jeff Layton wrote:
> > >> File-private locks have been merged into Linux for v3.15, and *now*
> > >> people are commenting that the name and macro definitions for the new
> > >> file-private locks suck.
> > >>
> > >> ....and I can't even disagree. The names and command macros do suck.
> > >>
> > >> We're going to have to live with these for a long time, so it's
> > >> important that we be happy with the names before we're stuck with them.
> > >>
> > >> The consensus on the lists so far is that they should be rechristened as
> > >> "file-description locks".
> > >>
> > >> This patch makes the following changes that I think are necessary before
> > >> v3.15 ships:
> > >>
> > >> 1) rename the command macros to their new names. These end up in the uapi
> > >>    headers and so are part of the external-facing API. It turns out that
> > >>    glibc doesn't actually use the fcntl.h uapi header, but it's hard to
> > >>    be sure that something else won't. Changing it now is safest.
> > >>
> > >> 2) make the the /proc/locks output display these as type "FDLOCK"
> > >>
> > >> The rest of the renaming can wait until v3.16, since everything else
> > >> isn't visible outside of the kernel.
> > > 
> > > I'm sorry I didn't chime in on this earlier, but I really prefer the
> > > (somewhat bad) current naming ("private") to the
> > > ridiculously-confusing use of "FD" to mean "file descriptION" when
> > > everybody is used to it meaning "file descriptOR". The potential for
> > > confusion that these are "file descriptOR locks" (they're not) is much
> > > more of a problem, IMO, than the confusion about what "private" means
> > > (since it doesn't have an established meaning in this context.
> > > 
> > > Thus my vote is for leaving things the way the kernel did it already.
> > 
> > There's at least two problems to solve here:
> > 
> > 1) "File private locks" is _meaningless_ as a term. Elsewhere
> 
> That's the benefit of it: it doesn't clash with any
> already-established meaning. I agree it's less than ideal, but all the
> alternatives I've seen so far are worse.
> 
> >    (http://thread.gmane.org/gmane.network.samba.internals/76414/focus=1685376),
> >    I suggested various alternatives. "File-handle locks [*]" was my
> 
> This is also bad. "Handle" also has a defined meaning in POSIX. See
> XSH 2.5.1:
> 
> http://pubs.opengroup.org/onlinepubs/9699919799/functions/V2_chap02.html
> 

Not to mention that "filehandle" has a different meaning altogether in
NFS parlance. I think we should avoid "handle" altogether in the name.

> >    initial preference, and I also suggested "file-description locks"
> >    and noted the drawbacks of that term. I think it's insufficient
> >    to say "stick with the existing poor name"--if you have
> >    something better, then please propose it. (Note by the way
> >    that for nearly a decade now, the open(2) man page has followed
> >    POSIX in using the term "open file description. Full disclosure:
> >    of course, I'm responsible for that change in the man page.)
> 
> I'm well aware of that. The problem is that the proposed API is using
> the two-letter abbreviation FD, which ALWAYS means file descriptor and
> NEVER means file description (in existing usage) to mean file
> description. That's what's wrong.
> 

Fair enough. Assuming we kept "file-description locks" as a name, what
would you propose as new macro names?

> > 2) The new API constants (F_SETLKP, F_SETLKPW, F_GETLKP) have names
> >    that are visually very close to the traditional POSIX lock names 
> >    (F_SETLK, F_SETLKW, F_GETLK). That's an accident waiting to happen
> >    when someone mistypes in code and/or misses such a misttyping
> >    when reading code. That really must be fixed.
> 
> I agree, but I don't think making it worse is a solution.
> 

-- 
Jeff Layton <jlayton@redhat.com>
