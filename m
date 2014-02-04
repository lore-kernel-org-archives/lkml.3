Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644AbaBDReD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 12:34:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60872 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754464AbaBDReA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 12:34:00 -0500
Date: Tue, 4 Feb 2014 18:34:06 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Do we really need curr_target in signal_struct ?
Message-ID: <20140204173406.GA6256@redhat.com>
References: <CADZ9YHhx3NkeQp4S=o0ruAd7U20AprFt-uejcqn1oLzJbm3w4A@mail.gmail.com> <20140129145535.GA12562@redhat.com> <CADZ9YHjEfEWJx5z_5KZnfQAVHXY3u613XV7vdZqjts4zFR3_=g@mail.gmail.com> <20140129183204.GA22808@redhat.com> <CADZ9YHj4D7aDAznt5rWvn45aVXZ8r-c+G0EeaH6AGdE_TLu9Bg@mail.gmail.com> <CADZ9YHgYsibaVm9c+Ho+XXZKxZatHY-+pm=w+jj0EQ94qfFt5Q@mail.gmail.com> <20140201165122.GA7478@redhat.com> <CADZ9YHg-8XrQ0p+uQNRNBhvnHE83xVxLKais0DrT9vfoQvm=uA@mail.gmail.com> <20140203163921.GA25698@redhat.com> <CADZ9YHgeKjgffbrfRMOzDZu7qv4YVMzLhQz3NDya827=gsvJ5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADZ9YHgeKjgffbrfRMOzDZu7qv4YVMzLhQz3NDya827=gsvJ5g@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04, Rakib Mullick wrote:
>
> On Mon, Feb 3, 2014 at 10:39 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> > I can only read the current code. I do not know the original intent.
> >
> This is where things are confusing.

Yes, I agree.

Once again, I can understand what this code does, but I am not sure
I understand why, and I am not sure this logic was actually "designed".
The usual problem with the ancient code.

> > I simply can't understand. Why? I do not think so.
> >
> Cause, want_signal logic checks these thread attributes to find whether it's
> eligible or not.

Ah, wants_signal()->signal_pending() doesn't mean "eligible".
sigismember(&p->blocked) does mean.

This signal_pending() checks allows to notify multiple threads, so that
they can run the signal handlers in parallel. And otoh, if signal_pending()
is true then we obviously do not need signal_wake_up().

> And, therefore, I think I should not make any
> changes in this code.

No ;) not at all.

We all do mistakes, and in this particular case I am not even 100% sure
I was right.

> > But I am not going to ack the behaviour change, simply because I have
> > no idea how this can impact the existing applications. Perhaps nobody
> > will notice this change, but we can't know this.
> >
> Yes, I'm not also sure about the behavior change and it's impact over
> existing applications, so, I'm skipping it.

Yes, this is the main reason why I disliked this change from the very
beginning.

Oleg.

