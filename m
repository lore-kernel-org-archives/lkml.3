Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933663Ab3HGVho (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 17:37:44 -0400
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:59097 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933374Ab3HGVhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 17:37:43 -0400
Message-ID: <5202BE17.9010408@akamai.com>
Date: Wed, 07 Aug 2013 17:37:27 -0400
From: Jason Baron <jbaron@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC][PATCH 3/2] x86/jump labels: Count and display the short
 jumps used
References: <20130807173606.872055511@goodmis.org> <1375898048.6848.18.camel@gandalf.local.home> <CA+55aFwo4iFk4_6cSoK=NjCWjVgdPgKy0YfKpZd2zSGn_RXHYg@mail.gmail.com> <5202ABEF.10107@akamai.com> <CA+55aFyu+3fRrsGUZkH6y5yND3oV9K+jCzrJyCWqwHQreFELOw@mail.gmail.com>
In-Reply-To: <CA+55aFyu+3fRrsGUZkH6y5yND3oV9K+jCzrJyCWqwHQreFELOw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2013 04:47 PM, Linus Torvalds wrote:
> On Wed, Aug 7, 2013 at 1:19 PM, Jason Baron <jbaron@akamai.com> wrote:
>> The whole point of the thread started with wanting to move the default
>> 'disabled' branch further out-of-line.
> Yeah, but I always disagreed with that.
>
> Putting the unusual code out-of-line (as in "at the end of the
> function") is a good idea, but putting it *far* out of line (as in "in
> a different section") likely makes little sense.
>
> Now, the tracing code is admittedly specialized enough that we could
> have some "really cold" attribute and move it to that kind of "even
> further away" model, but most of the other uses of the static keys are
> not necessarily of the kind where the non-default case is completely
> or utterly unlikely - they want to use the static keys not because
> some codepath is basically never taken, but because the code-path is
> so critical that loading and testing a value from memory is considered
> to be excessive for when the feature is turned off (ie scheduler
> statistics etc).
>
> So the code may not even be all that cold - some people may well run
> with statistics enabled all the time - it's just that the non-enabled
> case really *really* doesn't want to have the overhead of even
> bothering to test for this event.
>
>

ok - I can see 2 variants here as you mentioned:

1) 'Unbiased' - we want to treat both branches equally but don't want
the load/test/jmp sequence. For things like the scheduler stats.

2) 'Biased' - where the unlikely path is moved completely out-of-line.
And we have a strong 'bias' to optimize the default path.

If we can get the completely out-of-line thing working, we could make
this distinction.

Thanks,

-Jason


