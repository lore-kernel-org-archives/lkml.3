Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab3HUR6W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 13:58:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15931 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791Ab3HUR6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 13:58:19 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=roXeUe4e85gA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=JzSCUfRX3cwA:10 a=XyMNlIghAAAA:8 a=D1pviyP8qKv71XvsCqsA:9 a=CjuIK1q_8ugA:10 a=69vhMaErX6oAKDbg:21 a=Ktd2vMW4ndwQ1_58:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Wed, 21 Aug 2013 13:58:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jochen Striepe <jochen@tolot.escape.de>
Cc: Willy Tarreau <w@1wt.eu>, Greg KH <gregkh@linuxfoundation.org>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, lwn@lwn.net,
        Guenter Roeck <linux@roeck-us.net>, Hugh Dickins <hughd@google.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Borislav Petkov <bp@alien8.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Proposed stable release changes
Message-ID: <20130821135816.41127e6f@gandalf.local.home>
In-Reply-To: <20130821172327.GB2398@pompeji.miese-zwerge.org>
References: <20130820224032.GA20491@kroah.com>
	<CA+5PVA4s8D6Hkvj7c4Hpw6MOefZG4BEEWZjWb4XHW+k4n_sWjA@mail.gmail.com>
	<20130820235700.GA7209@kroah.com>
	<CA+5PVA4q1K9iS0-ppZKMM8QfKQZBHX8auEp+C=Y=gnSMCkbP2Q@mail.gmail.com>
	<20130821004924.GA19098@kroah.com>
	<20130821053836.GF16424@1wt.eu>
	<20130821133713.GA16493@home.goodmis.org>
	<20130821172327.GB2398@pompeji.miese-zwerge.org>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Aug 2013 19:23:27 +0200
Jochen Striepe <jochen@tolot.escape.de> wrote:

> ... people are very different. Many just update here and then, but
> there are those who do update on most stable releases. Those are the
> ones you get feedback and testing from, and I think you should encourage
> them to update as soon as a new -stable kernel is released. Getting
> regression fixes fast sounds like a good encouragement especially for
> people interested in the -stable series. Keeping the number of
> regressions low is the whole point of -stable, right?

Yes, but its even worse when we add a new regression to fix the old one.

Note, this will still encourage people to upgrade to stable, and the
delay should be even more encouragement. The point of the delay is to
catch regressions caused by fixes in mainline. We don't want that added
regression to trickle into stable like it has a few times.

As you say "Keeping the number of regressions low is the whole point of
-stable". Yes it is. By the delay, it should help stable from getting
as many regressions as it is today.

> 
> > Maybe people are rushing, but I don't update my main machines every
> > stable release because I can't always afford the down time it causes me
> > to do so.
> 
> On my server/router and on my desktop machine it's the same, those are
> for daily work. But I have a netbook for playing around. :)

Right, and after upgrading your server/router to a new stable, it will
suck that it hits a new regression and you have to update again. A
delay should help limit those occurrences even more.

For netbook that you can play with the -rc candidates and if you hit a
regression, report it, and go back to a more stable kernel.

The point I'm making, we should be more reluctant in pulling patches
into stable as quick as we are. A patch ideally should simmer in
linux-next for a bit, then go into mainline. It should also simmer
there for a bit before it goes into stable. Except for those very rare
patches that can cause the system to easily crash, let an exploit
happen, or corrupt data. Those do need to go into stable ASAP. But
luckily, those are also rare and far between.

-- Steve
