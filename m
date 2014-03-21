Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416AbaCUSu0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 14:50:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769AbaCUSuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 14:50:20 -0400
Date: Fri, 21 Mar 2014 19:49:14 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Dilger, Andreas" <andreas.dilger@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Peng Tao <bergwolf@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "Drokin, Oleg" <oleg.drokin@intel.com>
Subject: Re: [PATCH 0/2] wait: introduce WQ_FLAG_EXCLUSIVE_HEAD
Message-ID: <20140321184914.GA4594@redhat.com>
References: <20140318133331.GA23193@laptop.programming.kicks-ass.net> <CA+a=Yy74V9_N4L8DoG=6iLnjGyOb6=ifraAqs5jW7ZsCG0t7jw@mail.gmail.com> <20140318140504.GD23193@laptop.programming.kicks-ass.net> <20140318154724.GA5669@redhat.com> <CA+a=Yy4WPO9FQwqzDygz6AadT6xbOMEa_puwosZ6WFN17uCncw@mail.gmail.com> <20140319164907.GA10113@redhat.com> <20140319165747.GC8557@laptop.programming.kicks-ass.net> <20140319171906.GA11377@redhat.com> <20140320175111.GA7375@redhat.com> <CF5102D5.9B239%andreas.dilger@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CF5102D5.9B239%andreas.dilger@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21, Dilger, Andreas wrote:
>
> On 2014/03/20, 11:51 AM, "Oleg Nesterov" <oleg@redhat.com> wrote:
>
> >On 03/19, Oleg Nesterov wrote:
> >>
> >> OK, I'll try to test/cleanup/resend tomorrow.
> >
> >Cough. Still un-tested, sorry. I will test it somehow and report,
> >but I'd like to send this for review right now.
> >
> >Because I simply can't decide what the new flag should actually
> >do, so please ack/nack the semantics/naming at least.
> >
> >Changes:
> >
> >	1. I decided it would be better to change __wait_event()
> >	   to accept wait.flags right now. This looks better in
> >	   any case to me, and otherwise we need to introduce the
> >	   __wait_exclusive_enum.
> >
> >	   The change looks trivial (both actually), please tell
> >	   me if you think it doesn't deserve a separate patch.
> >
> >	2. I won't insist, but WQ_FLAG_EXCLUSIVE_HEAD can be used
> >	   without WQ_FLAG_EXCLUSIVE.
> >
> >	   Unlikely this can be useful, but it looks more natural
> >	   this way. Otherwise we need to add another check to
> >	   ensure that WQ_FLAG_EXCLUSIVE_HEAD can't come alone.
> >
> >	   However, perhaps this means the new flag needs another
> >	   name. I agree in advance with any.
>
> What about:
>
> #define WQ_FLAG_HEAD	0x02

I am fine either way ;)

But _HEAD looks a bit confusing too. This flag doesn't add at the head,
it inserts the new entry before other exclusive tasks.

> #define WQ_FLAG_EXCLUSIVE_HEAD (WQ_FLAG_HEAD | WQ_FLAG_EXCLUSIVE)
>
> That avoids having WQ_FLAG_EXCLUSIVE_HEAD not actually meaning "exclusive"?
>
> Patches look reasonable at first glance.  The second patch would need
> to be changed to handle that WQ_FLAG_EXCLUSIVE_HEAD has both bits set
> (probably just replace uses of WQ_FLAG_EXCLUSIVE_HEAD with WQ_FLAG_HEAD).

Yes, s/WQ_FLAG_EXCLUSIVE_HEAD/WQ_FLAG_HEAD/ is the only change we
need in this case.

Other than define(WQ_FLAG_EXCLUSIVE_HEAD) of course, but this flags should
only be used by ___wait_event() callers.

Peter, what do you think?

Oleg.

