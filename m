Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab3KXDdi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 22:33:38 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:62241 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756375Ab3KXDdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 22:33:36 -0500
MIME-Version: 1.0
In-Reply-To: <28109.1385151958@warthog.procyon.org.uk>
References: <alpine.LRH.2.02.1311071146450.31522@tundra.namei.org>
	<CA+5PVA7C-SSg5TyQ14kUN2SbLi-=bk6isi05xgtR5j8MC7-Uhg@mail.gmail.com>
	<alpine.LRH.2.02.1311191029050.20131@tundra.namei.org>
	<CA+55aFyp2HnMATV1v81QwZFqXcyca-RTD93=55ba37kF4ANfCw@mail.gmail.com>
	<alpine.LRH.2.02.1311192319180.27775@tundra.namei.org>
	<CA+55aFwF8BV+YAD1RzV=yvcN2qVZ5sajBaeR=exqeZL6R-iYqw@mail.gmail.com>
	<28109.1385151958@warthog.procyon.org.uk>
Date: Sat, 23 Nov 2013 19:33:34 -0800
X-Google-Sender-Auth: ciJnEz1bM2wWKw7ZoKbpo9S0ml8
Message-ID: <CA+55aFwzqMGk7C=ySOoOo-eT9vZrhzSzGPwt9Cmd+dtNztMezw@mail.gmail.com>
Subject: Re: [GIT] Security subsystem updates for 3.13
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        James Morris <jmorris@namei.org>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 12:25 PM, David Howells <dhowells@redhat.com> wrote:
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>> So for future cases: if there are big independent overhauls of core
>> subsystems, I'd really like to see them kept separate, ok?
>
> Since the trusted and encrypted keys that Mimi and Dmitry deal with are also
> more akin to the keyring stuff, should they go through the keyring branch?
> And does James want to hold that branch?

So by now, the changes are hopefully smaller and general "updates"
rather than big new features. At that point, I don't care too deeply.
It's the "this is a whole new big way of doing things, and there's
fundamental new core code" that I would really like to be able to see
separately in order to make it much easier for me to pull and walk
through independently of the normal "updates to subsystem" stuff.

> I wrote it in userspace where I could easily drive it with huge numbers of
> entries (add a million keys, say, delete them randomly and check at each step
> that each remaining key can still be found) and also valground it.  For
> reference, what's the best way of showing you something like this?

Quite frankly, I just want to *know* about things like this, there
doesn't have to be some fixed format for it.

It can be part of the pull request, explaining where the code comes
from, how it's been tested, who has looked at it etc etc. Or it can be
just free-form in the commit messages.

And again, this - for me - is about core code that isn't deeply
embedded in some internal subsystem. So the reason I reacted to the
assoc_array.c thing is that it was clearly set up to be generic, and
it does end up being pretty different and affects "normal" users. So I
go off looking for "ok, where can I find this discussed" for doing
some minimal due diligence on a new set of core code, and I find very
little on lkml, and nothing else. And the commit message talks about
what it does, but not about the "who looked at it", so I basically had
nothing to judge it by except just looking at the code.

Which didn't look horrible, but it really would have made me happier
hearing about people looking it over, and about you testing it in user
space etc etc.

> I did show it to Paul McKenney - and he gave me some comments on it, though I
> didn't ask for a Reviewed-by line, which in retrospect I should've done.
>
> Should we have a "Comments-from: x <y@z>" line for this?  So that people who
> made comments but don't want to say they've properly reviewed it can be
> recognised formally?

A "reviewed-by" line is fine, but so is really just free-form explanations too.

Not everything has to be a "xyz-by:" thing, especially things that are
more important for one-time use at merge time rather than anything
"this is a common pattern and people might want to do statistics about
it over time".

It's too late for this case, and for all I know there are no similar
cases coming up in the security layer, but when I have something that
ends up being pending for a two weeks, I want to at least try to
educate people about *why* it was pending, and what I found difficult
about the process. Maybe it happens again, maybe it won't. But if it
does, we'll have at least spoken about the issues.

> Is there some way in the GIT repo to associate an 'extended explanation' with
> several patches?

In theory, you can use notes, but I don't actually like it either
technically _or_ from a "flow of information" standpoint, so I'd much
rather see people try to note things in the commit messages, and then
for the merge itself try to have explanations in the "please pull"
message.

                 Linus
