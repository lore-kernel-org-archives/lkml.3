Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357AbaE0LSR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 07:18:17 -0400
Received: from numidia.opendz.org ([98.142.220.152]:39021 "EHLO
	numidia.opendz.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbaE0LSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 07:18:13 -0400
Date: Tue, 27 May 2014 12:18:06 +0100
From: Djalal Harouni <tixxdz@opendz.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 6/9] procfs: add pid_seq_private struct to handle
 /proc/<pid>/{stat|stack}
Message-ID: <20140527111806.GA3148@dztty>
References: <1401110850-3552-1-git-send-email-tixxdz@opendz.org>
 <1401110850-3552-7-git-send-email-tixxdz@opendz.org>
 <CALCETrU71gJ-cUL8YO8UeYdG65A0=z4BJQuga-hbd1WgeTFE+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrU71gJ-cUL8YO8UeYdG65A0=z4BJQuga-hbd1WgeTFE+A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 10:02:15AM -0700, Andy Lutomirski wrote:
> On Mon, May 26, 2014 at 6:27 AM, Djalal Harouni <tixxdz@opendz.org> wrote:
> > This patch is preparation to handle sensitive ONE entries:
> > /proc/<pid>/stat
> > /proc/<pid>/stack
> >
> > These files use sequence iterators and we want to keep that logic, and
> > their internal handler semantics.
> >
> > The sequence iterators stock the inode in the seq_file->private field,
> > so in order to keep the semantic and to make the cached permission
> > checks available during ->read(), we add the 'pid_seq_private' struct
> > that contains both the inode and the cached permission. It will be the
> > one referenced in the seq_file->private.
> >
> > This way the internal handlers of /proc/<pid>/{stat|stack} wont change.
> >
> > Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
> > ---
> >  fs/proc/internal.h | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> >
> > diff --git a/fs/proc/internal.h b/fs/proc/internal.h
> > index f5c452c..f28e4f01 100644
> > --- a/fs/proc/internal.h
> > +++ b/fs/proc/internal.h
> > @@ -78,6 +78,17 @@ struct proc_inode {
> >         struct inode vfs_inode;
> >  };
> >
> > +/*
> > + * Struct used by some /proc/<pid>/$entries that use sequence
> > + * iterators.
> > + * This struct will be saved in seq_file->private so seq handlers
> > + * can access the inode and the cached permission checks of ->open().
> > + */
> > +struct pid_seq_private {
> > +       int permitted;
> > +       struct inode *inode;
> > +};
> > +
> >  typedef int (*proc_read_fn_t)(char *page,
> >                               struct task_struct *task, int permitted);
> 
> int opener_may_ptrace, please.
Ok, I'll change it in v2.

Thanks

-- 
Djalal Harouni
http://opendz.org
