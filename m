Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757146AbaC0SrD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 14:47:03 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:59859 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757069AbaC0SrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 14:47:00 -0400
MIME-Version: 1.0
In-Reply-To: <20140327182617.GC2526@jeremy-laptop>
References: <CALCETrVyNXYaMWOyWj4gKLWVdzPrSkvv7WTBi2Aa8mYs4NKH9g@mail.gmail.com>
 <53341D8E.80105@redhat.com> <20140327060225.4f4caa5a@ipyr.poochiereds.net>
 <53342258.8000304@redhat.com> <20140327070126.41ac75ac@ipyr.poochiereds.net> <20140327182617.GC2526@jeremy-laptop>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 27 Mar 2014 11:46:39 -0700
Message-ID: <CALCETrU+D-W_CCHuiWorTXUwsSHWS7AF91Kj2G0MtK_J+ESFKQ@mail.gmail.com>
Subject: Re: Thoughts on credential switching
To: Jeremy Allison <jra@samba.org>
Cc: Jeff Layton <jlayton@redhat.com>, Florian Weimer <fweimer@redhat.com>,
        Jim Lieb <jlieb@panasas.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        "Serge E. Hallyn" <serge@canonical.com>,
        Kees Cook <keescook@chromium.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bfields@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2014 at 11:26 AM, Jeremy Allison <jra@samba.org> wrote:
>
> Amen to that :-).
>
> However, after talking with Jeff and Jim at CollabSummit,
> I was 'encouraged' to make my opinions known on the list.
>
> To me, calling the creds handle a file descriptor just
> feels wrong. IT *isn't* an fd, you can't read/write/poll
> on it, and it's only done as a convenience to get the
> close-on-exec semantics and the fact that the creds are
> already hung off the fd's in kernel space.

Windows calls these things "handles."  Linux has "file descriptors,"
and there's plenty of precedent for things that aren't files.

>
> I'd rather any creads call use a different type, even if
> it's a typedef of 'int -> creds_handle_t', just to make
> it really clear it's *NOT* an fd.
>
> That way we can also make it clear this thing only has
> meaning to a thread group, and SHOULD NOT (and indeed
> preferably CAN NOT) be passed between processes.
>

If you want those semantics, then stick a struct pid * in there for
the tgid of the cretor and make sure that current's tgid matches when
you try to use it.

I think they'd be more useful without that check, though.

BTW, what do you want to have happen on fork?  I think they should keep working.

> Cheers,
>
>         Jeremy.



-- 
Andy Lutomirski
AMA Capital Management, LLC
