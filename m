Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905AbaA2ScI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 13:32:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16366 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752374AbaA2ScG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 13:32:06 -0500
Date: Wed, 29 Jan 2014 19:32:04 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Do we really need curr_target in signal_struct ?
Message-ID: <20140129183204.GA22808@redhat.com>
References: <1390895840.8373.2.camel@beeld> <20140128164320.GB7596@redhat.com> <CADZ9YHhx3NkeQp4S=o0ruAd7U20AprFt-uejcqn1oLzJbm3w4A@mail.gmail.com> <20140129145535.GA12562@redhat.com> <CADZ9YHjEfEWJx5z_5KZnfQAVHXY3u613XV7vdZqjts4zFR3_=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADZ9YHjEfEWJx5z_5KZnfQAVHXY3u613XV7vdZqjts4zFR3_=g@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29, Rakib Mullick wrote:
>
> On Wed, Jan 29, 2014 at 8:55 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> > On 01/29, Rakib Mullick wrote:
> >>
> >> On Tue, Jan 28, 2014 at 10:43 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> >>
> >
> >> AFAIU, ->current_target is only a loop breaker to avoid infinite loop,
> >
> > No. It caches the last result of "find a thread which can handle this
> > group-wide signal".
> >
> The reason behind of my understanding is the following comments:
>
>                                 /*
>                                  * No thread needs to be woken.
>                                  * Any eligible threads will see
>                                  * the signal in the queue soon.
>                                  */
>
> What if, there's no thread in a group wants_signal()?

then complete_signal() returns without signal_wake_up().

> Or it can't
> practically happen?

It can. Say, all threads has blocked this signal. And other reasons.

> >> but - by using while_each_thread() we can remove it completely, thus
> >> helps to get rid from maintaining it too.
> >
> > ... and remove the optimization above.
> >
> >> I'll prepare a proper patch with you suggestions for reviewing.
> >
> > I am not sure we want this patch. Once again, I do not know how much
> > ->curr_target helps, and certainaly it can't help always. But you
> > should not blindly remove it just because yes, sure, it is not strictly
> > needed to find a wants_signal() thread.
> >
> Are you thinking that , since things are not broken, then we shouldn't
> try to do anything?

Hmm. No.

I am thinking that, since you misunderstood the purpose of ->curr_target,
I should probably try to argue with your patch which blindly removes this
optimization ?

I also think that this logic doesn't look perfect, but this is another
story.

Oleg.

