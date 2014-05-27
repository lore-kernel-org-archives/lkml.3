Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518AbaE0NmY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 09:42:24 -0400
Received: from numidia.opendz.org ([98.142.220.152]:58007 "EHLO
	numidia.opendz.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbaE0NmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 09:42:22 -0400
Date: Tue, 27 May 2014 14:42:18 +0100
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
Subject: Re: [PATCH 1/9] procfs: use flags to deny or allow access to
 /proc/<pid>/$entry
Message-ID: <20140527134218.GB3148@dztty>
References: <1401110850-3552-1-git-send-email-tixxdz@opendz.org>
 <1401110850-3552-2-git-send-email-tixxdz@opendz.org>
 <CALCETrUte7WRMi23+rp+XbgAoOcw=TPZe02YEuZRZyVroj+mfQ@mail.gmail.com>
 <20140526172101.GA6380@dztty>
 <CALCETrU=Jy-urWRcRnRyUNKgJFKykcQP6Diy35R3Uf=7fw_wqw@mail.gmail.com>
 <20140526191353.GB6887@dztty>
 <CALCETrU1xjXvwtuYyqGhDgch7cZgP_LWLNDC8b8oeEtwJ0UNmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrU1xjXvwtuYyqGhDgch7cZgP_LWLNDC8b8oeEtwJ0UNmg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 12:17:48PM -0700, Andy Lutomirski wrote:
> On Mon, May 26, 2014 at 12:13 PM, Djalal Harouni <tixxdz@opendz.org> wrote:
> > On Mon, May 26, 2014 at 11:06:40AM -0700, Andy Lutomirski wrote:
> >> On Mon, May 26, 2014 at 10:21 AM, Djalal Harouni <tixxdz@opendz.org> wrote:
> >> > I would like to keep it enum, enum is type-safe and I want to follow the
> >> > semantics of /proc/pid/stat and others:
> >>
> >> It's not type-safe the way you're doing it, though.
> > Can you please shed some light Andy, thank you in advance!
> 
> You're casting these things back and forth.  If you were storing enum
> values in an enum-typed variable, great, but you're not.
Ok I see your point! Yes, but AFAIK in this case it's perfectly safe!

We don't use large values, the one used here can be represented as an
int, and later we cast them to unsigned long to make sure that we are
using the correct value and the correct size of a pointer.

GCC is able to warn in this case of any appropriate cast:
-Wpointer-to-int-cast ...

And from Documentation/CodingStyle:
"Enums are preferred when defining several related constants."

Perhaps I'm missing something!

> --Andy

-- 
Djalal Harouni
http://opendz.org
