Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508AbaDARJb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 13:09:31 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:44701 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbaDARJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 13:09:30 -0400
MIME-Version: 1.0
In-Reply-To: <20140401082757.GA23451@gmail.com>
References: <20140401082757.GA23451@gmail.com>
Date: Tue, 1 Apr 2014 10:09:28 -0700
X-Google-Sender-Auth: v4NiBRu46a1h0s6pJIpcOeVIRfU
Message-ID: <CA+55aFzKCVnqYussDpt8Fkoi28SthKRd3oKnSW4GnED+s6QdVQ@mail.gmail.com>
Subject: Re: [GIT PULL] x86/platforms for v3.15
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 1, 2014 at 1:27 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> David E. Box (2):
>       x86, iosf: Change IOSF_MBI Kconfig to default y

Why? This change looks completely and utterly bogus.

That IOSF_MBI Kconfig value shouldn't be exposed at all, since it is
supposed to be selected by modules that need it. And if it is exposed,
why the f*ck should it be on by default? With no help messages about
why you should enable it (quite the reverse)?

Guys, this is crap. It looks like another example of a developer who
thinks that *his* particular meaningless code is _so_ so special that
it needs to be enabled for everybody.  That's utter bullshit, guys.

This is a Kconfig entry for a piece of hardware that

 (a) people don't know about, so asking people about it is f*cking
retarded to begin with

 (b) only exists on some Atom-based SoC chips, so it's not like we
expect *any* normal kernel developer to enable it unless they have
special hardware

 (c) if they have the hardware, they need to enable the drivers that
use this for the doorbell driver to be useful to begin with, so why
the hell would you ask about this?

 (d) the entry has no real documentation for what it is, and the docs
it *does* have explicitly state that the sane thing is for drivers
(that people may actually be *aware* of and thus validly answer
questions about) to select it.

Notice? Exposing it at all is a disgrace. making it "default y" is
doubly so. Tell me _one_ reason for why it should have a question to
begin with, and why it should default to "y".

And no, reasons like "I wrote this code and I love it so much that I
want to force it on others" is not a valid reason.

Neither is "I hate all my users, and I want to terminally confuse them
and discourage people from compiling their own kernels, so I'll ask
annoying and idiotic questions at configure time".

Any _real_ reason?

In the absence of real reasons, I'm not pulling crap like this. Get
your act together. Why the heck should _I_ be the one that notices
that this commit is insane and stupid?

Yes, this is a pet peeve of mine. Our configuration phase is
absolutely *the* single worst part of the kernel, and it's not because
our Kconfig language is complex. It's because it scares people away
from building their own kernels and testing, because we make it
insanely hard to answer the questions, and we seem to actively
encourage people to enable features that are pointless and just bloat
things and make the build process slower and harder.

Christ, even *I* find our configuration process tedious. I can only
imagine how many casual users we scare away.

This cavalier attitude about asking people idiotic questions MUST
STOP. Seriously. This is not some "small harmless bug". This mindset
of crazy questions is a major issue!

              Linus
