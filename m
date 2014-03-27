Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243AbaC0S5M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 14:57:12 -0400
Received: from fn.samba.org ([216.83.154.106]:55152 "EHLO mail.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756045AbaC0S5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 14:57:10 -0400
Date: Thu, 27 Mar 2014 11:56:48 -0700
From: Jeremy Allison <jra@samba.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Jeremy Allison <jra@samba.org>, Jeff Layton <jlayton@redhat.com>,
        Florian Weimer <fweimer@redhat.com>, Jim Lieb <jlieb@panasas.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        "Serge E. Hallyn" <serge@canonical.com>,
        Kees Cook <keescook@chromium.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bfields@redhat.com
Subject: Re: Thoughts on credential switching
Message-ID: <20140327185648.GE2526@jeremy-laptop>
Reply-To: Jeremy Allison <jra@samba.org>
References: <CALCETrVyNXYaMWOyWj4gKLWVdzPrSkvv7WTBi2Aa8mYs4NKH9g@mail.gmail.com>
 <53341D8E.80105@redhat.com>
 <20140327060225.4f4caa5a@ipyr.poochiereds.net>
 <53342258.8000304@redhat.com>
 <20140327070126.41ac75ac@ipyr.poochiereds.net>
 <20140327182617.GC2526@jeremy-laptop>
 <CALCETrU+D-W_CCHuiWorTXUwsSHWS7AF91Kj2G0MtK_J+ESFKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrU+D-W_CCHuiWorTXUwsSHWS7AF91Kj2G0MtK_J+ESFKQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2014 at 11:46:39AM -0700, Andy Lutomirski wrote:
> On Thu, Mar 27, 2014 at 11:26 AM, Jeremy Allison <jra@samba.org> wrote:
> >
> > Amen to that :-).
> >
> > However, after talking with Jeff and Jim at CollabSummit,
> > I was 'encouraged' to make my opinions known on the list.
> >
> > To me, calling the creds handle a file descriptor just
> > feels wrong. IT *isn't* an fd, you can't read/write/poll
> > on it, and it's only done as a convenience to get the
> > close-on-exec semantics and the fact that the creds are
> > already hung off the fd's in kernel space.
> 
> Windows calls these things "handles."  Linux has "file descriptors,"
> and there's plenty of precedent for things that aren't files.

Sure, but there's a set of expectations around
fd's that these things don't satisfy - IO-ops.

> > That way we can also make it clear this thing only has
> > meaning to a thread group, and SHOULD NOT (and indeed
> > preferably CAN NOT) be passed between processes.
> >
> 
> If you want those semantics, then stick a struct pid * in there for
> the tgid of the cretor and make sure that current's tgid matches when
> you try to use it.
> 
> I think they'd be more useful without that check, though.

I'm more worried about leakage and unintended consequences
here.

> BTW, what do you want to have happen on fork?  I think they should keep working.

Yeah, that's true. I want them to keep
working across fork, but not across exec
or any other method of fd-passing.

Jeremy.
