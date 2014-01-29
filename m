Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486AbaA2OzY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 09:55:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11188 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752080AbaA2OzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 09:55:23 -0500
Date: Wed, 29 Jan 2014 15:55:35 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Do we really need curr_target in signal_struct ?
Message-ID: <20140129145535.GA12562@redhat.com>
References: <1390895840.8373.2.camel@beeld> <20140128164320.GB7596@redhat.com> <CADZ9YHhx3NkeQp4S=o0ruAd7U20AprFt-uejcqn1oLzJbm3w4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADZ9YHhx3NkeQp4S=o0ruAd7U20AprFt-uejcqn1oLzJbm3w4A@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29, Rakib Mullick wrote:
>
> On Tue, Jan 28, 2014 at 10:43 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> > But I guess ->curr_target was added exactly to avoid this loop if
> > possible, assuming that wants_signal(->current_targer) should be
> > likely true. Although perhaps this optimization is too simple.
> >
> Well, this code block will only hit when first check for wants_signal()
> will miss,

Yes,

> that means we need to find some other thread of the group.

Yes,

> AFAIU, ->current_target is only a loop breaker to avoid infinite loop,

No. It caches the last result of "find a thread which can handle this
group-wide signal".

> but - by using while_each_thread() we can remove it completely, thus
> helps to get rid from maintaining it too.

... and remove the optimization above.

> I'll prepare a proper patch with you suggestions for reviewing.

I am not sure we want this patch. Once again, I do not know how much
->curr_target helps, and certainaly it can't help always. But you
should not blindly remove it just because yes, sure, it is not strictly
needed to find a wants_signal() thread.

Oleg.

