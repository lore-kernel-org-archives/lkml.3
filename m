Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbaDUT4D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 15:56:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47093 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753925AbaDUTz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 15:55:59 -0400
Date: Mon, 21 Apr 2014 15:55:20 -0400
From: Jeff Layton <jlayton@redhat.com>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Rich Felker <dalias@libc.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
        Ganesha NFS List <nfs-ganesha-devel@lists.sourceforge.net>,
        "Carlos O'Donell" <carlos@redhat.com>,
        libc-alpha <libc-alpha@sourceware.org>,
        "Stefan (metze) Metzmacher" <metze@samba.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] locks: rename file-private locks to file-description
 locks
Message-ID: <20140421155520.3b33fbef@ipyr.poochiereds.net>
In-Reply-To: <535573E0.9080106@gmail.com>
References: <1398087935-14001-1-git-send-email-jlayton@redhat.com>
	<20140421140246.GB26358@brightrain.aerifal.cx>
	<535529FA.8070709@gmail.com>
	<20140421161004.GC26358@brightrain.aerifal.cx>
	<5355644C.7000801@gmail.com>
	<20140421184640.GD26358@brightrain.aerifal.cx>
	<535573E0.9080106@gmail.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Apr 2014 21:39:12 +0200
"Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> wrote:

> On 04/21/2014 08:46 PM, Rich Felker wrote:
> > On Mon, Apr 21, 2014 at 08:32:44PM +0200, Michael Kerrisk (man-pages) wrote:
> >> On 04/21/2014 06:10 PM, Rich Felker wrote:
> >>> I'm well aware of that. The problem is that the proposed API is using
> >>> the two-letter abbreviation FD, which ALWAYS means file descriptor and
> >>> NEVER means file description (in existing usage) to mean file
> >>> description. That's what's wrong.
> >>
> >> So, can you *please* answer this question: what do you call (i.e., 
> >> what  everyday technical language term do use for) the thing
> >> that sits between a file descriptor and an i-node? 
> >>
> >> (Please don't say 'struct file' -- that is not is an implementation 
> >> detail, and does not qualify as the kind of term that I could use 
> >> when documenting this feature in man pages.)
> > 
> > "Open file description".
> 
> Oh! I didn't realize we agreed :-).
> 
> >> POSIX uses (or invented, I am not sure which) the term file description
> >> for a good reason: it is unambiguous, and therefore precise. I do agree
> >> that there's a risk of confusion between 'open file descriptor" and 
> >> 'and file description'--it's the same kind of risk as between English 
> >> terms such as 'arbitrator' and 'arbitration' (and any number of other
> >> examples), and as language speakers we deal with this every day.
> > 
> > There's not a problem when the full word is used. On the other hand,
> > if you use "arb" as an abbreviation for "arbitration" in a context
> > where it was already universally understood as meaning "arbitrator",
> > that would be a big problem.
> > 
> > Likewise the problem here isn't that "open file description" is a bad
> > term. It's that using "FD" to mean "[open] file description" is
> > utterly confusing, even moreso than just making up a new completely
> > random word.
> 
> Ohh -- I had thought you a problem not just with "FD" but also
> "(open) file description".
> 
> >>>> 2) The new API constants (F_SETLKP, F_SETLKPW, F_GETLKP) have names
> >>>>    that are visually very close to the traditional POSIX lock names 
> >>>>    (F_SETLK, F_SETLKW, F_GETLK). That's an accident waiting to happen
> >>>>    when someone mistypes in code and/or misses such a misttyping
> >>>>    when reading code. That really must be fixed.
> >>>
> >>> I agree, but I don't think making it worse is a solution.
> >>
> >> I don't agree that it's making it worse. The real problem here is 
> >> that people use no good unambiguous term for the thing between a file
> >> descriptor and an inode. POSIX provides us with a solution that may
> >> not seem perfect, but it is unambiguous, and I think it might feel
> >> more comfortable if we used it often enough.
> > 
> > I would like to see it used more too, and in particular, I think it
> > belongs in the documentation for these new locking interfaces. But
> > that still doesn't answer the question of what to call them (the
> > macros) unless you want:
> > 
> > F_OPEN_FILE_DESCRIPTION_GETLK
> > F_OPEN_FILE_DESCRIPTION_SETLK
> > F_OPEN_FILE_DESCRIPTION_SETLKW
> 
> Or just 'F_OFD_*'?
> 
> > Perhaps "OP" (for open-private, i.e. private to the particular open)
> > would be a sensible choice; OTOH people are likely to misread it as
> > OPeration. The general principle I have in mind though is that it
> > might be nice to highlight the word "open" in "open file description"
> 
> (Fair enough.)
> 
> > since it (1) contrasts with file descriptor, despite file descriptors
> > also dealing with open files, and (2) contrasts well with legacy fcntl
> > locks, which are (this is the whole bug) associated with the
> > underlying file and not the open file description.
> 
> Makes sense to me. (We are in more agreement that I realized.)
> 
> Cheers,
> 
> Michael
> 
> 
> 

So the motion is to call them "open file description locks" and change
the macros to read *_OFD_*. Does anyone object?

-- 
Jeff Layton <jlayton@redhat.com>
