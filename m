Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933227Ab3HGUrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 16:47:36 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:40459 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933014Ab3HGUrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 16:47:35 -0400
MIME-Version: 1.0
In-Reply-To: <5202ABEF.10107@akamai.com>
References: <20130807173606.872055511@goodmis.org>
	<1375898048.6848.18.camel@gandalf.local.home>
	<CA+55aFwo4iFk4_6cSoK=NjCWjVgdPgKy0YfKpZd2zSGn_RXHYg@mail.gmail.com>
	<5202ABEF.10107@akamai.com>
Date: Wed, 7 Aug 2013 13:47:34 -0700
X-Google-Sender-Auth: ILhgn35-iHbhl48cgi4yTH7BSp8
Message-ID: <CA+55aFyu+3fRrsGUZkH6y5yND3oV9K+jCzrJyCWqwHQreFELOw@mail.gmail.com>
Subject: Re: [RFC][PATCH 3/2] x86/jump labels: Count and display the short
 jumps used
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jason Baron <jbaron@akamai.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 7, 2013 at 1:19 PM, Jason Baron <jbaron@akamai.com> wrote:
>
> The whole point of the thread started with wanting to move the default
> 'disabled' branch further out-of-line.

Yeah, but I always disagreed with that.

Putting the unusual code out-of-line (as in "at the end of the
function") is a good idea, but putting it *far* out of line (as in "in
a different section") likely makes little sense.

Now, the tracing code is admittedly specialized enough that we could
have some "really cold" attribute and move it to that kind of "even
further away" model, but most of the other uses of the static keys are
not necessarily of the kind where the non-default case is completely
or utterly unlikely - they want to use the static keys not because
some codepath is basically never taken, but because the code-path is
so critical that loading and testing a value from memory is considered
to be excessive for when the feature is turned off (ie scheduler
statistics etc).

So the code may not even be all that cold - some people may well run
with statistics enabled all the time - it's just that the non-enabled
case really *really* doesn't want to have the overhead of even
bothering to test for this event.

So I really think that a short jump would be a good thing, it's just
that I don't think it's *so* important that it's worth having several
hundreds of lines of code to support it.

                 Linus
