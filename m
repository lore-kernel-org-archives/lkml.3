Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbaHMUTM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 16:19:12 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:37875 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbaHMUTL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 16:19:11 -0400
MIME-Version: 1.0
In-Reply-To: <20140813082756.GB2923@twins.programming.kicks-ass.net>
References: <20140812153812.2923046a@monolith.infinux.org>
	<20140812202129.GA20344@home.goodmis.org>
	<yw1xr40l2whi.fsf@unicorn.mansr.com>
	<20140813082756.GB2923@twins.programming.kicks-ass.net>
Date: Wed, 13 Aug 2014 15:19:09 -0500
Message-ID: <CA+T2pCH5-+v7Knu4xmt7mZtbZdx5L612L8sOGEaHMDPSjg15rA@mail.gmail.com>
Subject: Re: OT: Open letter to the Linux World
From: William Pitcock <nenolod@dereferenced.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: =?UTF-8?B?TcOlbnMgUnVsbGfDpXJk?= <mans@mansr.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Christopher Barry <christopher.r.barry@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Aug 13, 2014 at 3:27 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Aug 12, 2014 at 11:07:05PM +0100, Måns Rullgård wrote:
>> Steven Rostedt <rostedt@goodmis.org> writes:
>>
>> > Nice rant, I sympathize with you (just complaining about this on G+).
>>
>> Made my day.
>>
>> > I'm just waiting for Linus to get pissed enough to write his own init
>> > routine. Maybe he'll call it "Boot Init Through Computer Hardware".
>>
>> The trouble is that most of the heavy-weight kernel developers don't
>> seem to care at all about what goes on in userspace.
>
> Well, I know for a fact that quite a number do; but so far most people
> who care have been able to steer clear of this trainwreck so we did.
>
> I'm about to switch all my machines to Gentoo (from Debian) because that
> will indeed allow you to build a distro without much of this nonsense
> in -- because as has been eloquently said; you simply don't need this
> fucking shite to run a 'normal' machine.
>
> And the thing is; we're all very busy so we tend to take the 'easy' way
> out for things like this; but wholesale switching all my machines is
> indeed painful, and I'm not liking.

Another solution here which is more similar to Debian than Gentoo, is
Alpine (http://www.alpinelinux.org).  Alpine is a distribution which
takes a lot of design cues from Debian (although we do use OpenRC).
The typical user experience when using the alpine package management
tools is easy for Debian users to understand, being modeled on the apt
package manager.  Another interesting detail is that we have adopted
musl libc recently, and are working on glibc binary compatibility
where it matters - the non-free flash player is already working here,
and nvidia/fglrx are interesting targets as well.

We feel that our usage of musl libc allows for improved security of
the entire distribution, as musl's simplified implementation of
standard library features has a much lower attack surface, and indeed
a common observation is that many applications behave more robustly on
Alpine (using musl) than other distributions they are developing
against.

At present, there are no plans to adopt systemd there, and systemd
would need to be radically different than it is now to even be
considered as the init system.  The main blockers for systemd on
Alpine are believed to be permanent:

- systemd intentionally uses non-standard extensions to glibc
- systemd components cannot be safely split up to reduce installation footprint
- systemd has too much attack surface on PID 1 (d-bus, etc.)
- kdbus support could be reasonably implemented without systemd
- alpine does not wish to be 'forced' into adopting systemd through
applications using systemd-exclusive APIs

It should also be mentioned that Alpine is lightweight by default.
This has been a goal that Debian in many ways has strayed from over
the years.  An empty LXC container with an alpine install in it, but
no deployed applications, only takes approximately 3 megabytes of
disc.  Debian takes many orders of magnitude more now.

William
