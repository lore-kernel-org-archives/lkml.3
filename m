Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283AbaLQJLF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 04:11:05 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:37349 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbaLQJLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 04:11:01 -0500
Date: Wed, 17 Dec 2014 01:10:57 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-pm@vger.kernel.org,
        Len Brown <len.brown@intel.com>,
        Chirantan Ekbote <chirantan@chromium.org>
Subject: Re: [PATCH] PM / sleep: add configurable delay for pm_test
Message-ID: <20141217091057.GH7112@brian-ubuntu>
References: <1409788535-28264-1-git-send-email-computersforpeace@gmail.com>
 <20141213025530.GO21347@ld-irv-0074>
 <20141213083123.GA26129@amd>
 <20141216235813.GI9759@ld-irv-0074>
 <20141217080947.GB2027@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141217080947.GB2027@amd>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 09:09:47AM +0100, Pavel Machek wrote:
> 
> > > 40 lines of code, and new sysfs interface for use by someone who puts
> > > the probes on board, anyway... (so should be able to add the single
> > > mdelay himself).
> > 
> > I heard your complaint the first time:
> > 
> >   https://lkml.org/lkml/2014/9/4/63
> > 
> > And I responded to it already:
> > 
> >   https://lkml.org/lkml/2014/9/4/494
> > 
> > You did not respond, but Chirantan spoke up saying he wanted such a
> > patch too. He came up with a very similar solution independently:
> 
> I know. I believe your patch is so crazy that no more discussion was neccessary.

That's awfully disrespectful. You never responded to my follow up
question, and now you ridicule me for asking again.

> >   https://chromium.googlesource.com/chromiumos/third_party/kernel/+/15bccc2c63c3475ef61d3187c73ccf1d80b18c7e
> > 
> > But since you've decided to make the same comment again, I will detail
> > more of the reasons why I think your suggestion ("go add the mdelay
> > yourself") is off-base.
> > 
> >  1. This is behind a debug config option (CONFIG_PM_DEBUG). So what's
> >  the problem with improving its usefulness? Non-debug users can easily
> >  compile it out if they're worried about 40 lines.
> 
> We are talking 40 unneccessary lines of source.

"Unnecessary" is highly subjective. Just because you don't need it
doesn't mean no one else does.

There are at least two completely different projects that have mentioned
the need for it. Thus (as I explained in my "ping") I don't think that
qualifies as unnecessary.

> Imagine everyone who
> needed to change one value added 40 lines of code. Terabyte
> kernel.

That's an exaggeration.

> Overengineered. Crazy. Something we'll have to maintain
> forever.

It follows the same form and style of the other kernel/power/ debug
sysfs code. Its interface is well documented and straightforward. It's
really quite obvious. So how is this a maintenance problem?

Additionally, because it's explicitly a debug feature (CONFIG_PM_DEBUG),
I'm not sure it would really qualify as an unchangeable ABI that can
never be touched, if it really became a maintenance problem somehow.

> Make it module parameter so that the patch is two lines of code. If
> that does not work for you, think of something that does.

OK, so that's actually constructive. If lines of code is really the most
important factor here, then I suppose I can do that. I'd argue that a
module parameter is a much less sensible interface here, though, given
that it is coupled with the existing /sys/power/pm_test interface.

> >  2. The current debug code encodes a particular policy (which kernels
> >  generally should not). Is it better if I submit a patch that changes
> >  the current magic delay to 60000 milliseconds? What about 1334
> >  milliseconds?
> > 
> >  3. To continue your argument: why would I ever try to patch the
> >  upstream kernel, if I'm perfectly capable of doing this myself?
> 
> Good questions. Showing that perhaps you should not patch the
> upstream.

You seem to not understand the point behind my rhetorical questions. And
I don't feel like you've honestly addressed any of the 4 points I made.
That's disappointing.

I'd appreciate some feedback from Rafael. Based on his feedback (or lack
thereof) my options seem to be:

1. Sit and wait on this patch for another few months
2. Resend this patch as a module parameter instead
3. Forget this entirely

Thanks,
Brian
