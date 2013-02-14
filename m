Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205Ab3BNH7X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 02:59:23 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:53817 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365Ab3BNH7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 02:59:22 -0500
X-AuditID: 9c93016f-b7b1fae000006419-4f-511c99583f71
From: Namhyung Kim <namhyung@kernel.org>
To: Clark Williams <williams@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] scheduler include file reorganization
References: <20130207094650.76302f47@riff.lan>
	<20130207185608.GA25223@gmail.com> <20130207191345.GA28960@gmail.com>
	<20130207195257.GA29985@gmail.com> <20130207150838.02226207@riff.lan>
	<20130208141841.GB30334@gmail.com> <20130208085828.02e61518@riff.lan>
	<20130211095457.GF23932@gmail.com> <87d2w5ovc0.fsf@sejong.aot.lge.com>
	<20130213091512.GC7630@gmail.com> <20130213091937.5a226c5d@riff.lan>
Date: Thu, 14 Feb 2013 16:59:20 +0900
In-Reply-To: <20130213091937.5a226c5d@riff.lan> (Clark Williams's message of
	"Wed, 13 Feb 2013 09:19:37 -0600")
Message-ID: <87zjz7nx5z.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2013 09:19:37 -0600, Clark Williams wrote:
> On Wed, 13 Feb 2013 10:15:12 +0100
> Ingo Molnar <mingo@kernel.org> wrote:
>> * Namhyung Kim <namhyung@kernel.org> wrote:
>> > On Mon, 11 Feb 2013 10:54:58 +0100, Ingo Molnar wrote:
>> > > * Clark Williams <williams@redhat.com> wrote:
>> > >
>> > >> I figured that was coming. :)
>> > >
>> > > ;-)
>> > >
>> > >> I'll look at it again and see about pulling the 
>> > >> autogroup/cgroup stuff into it's own header. After that it's 
>> > >> probably going to require some serious changes.
>> > >> 
>> > >> Any suggestions?
>> > >
>> > > I'd suggest doing it as finegrained as possible - potentially 
>> > > one concept at a time. I wouldn't mind a dozen small files in 
>> > > include/linux/sched/ - possibly more.
>> > 
>> > What about the .c files?  AFAICS the sched/core.c and 
>> > sched/fair.c are rather huge and contain various concepts 
>> > which might be separated to their own files.  It'd be better 
>> > reorganizing them too IMHO.
>> 
>> I'd be more careful about those, because there's various 
>> scheduler patch-sets floating modifying them.
>> 
>> sched.h is much more static and it is the one that actually gets 
>> included in like 60% of all *other* .c files, adding a few 
>> thousand lines to every .o compilation and causing measurable 
>> compile time overhead ...
>> 
>> So sched.h splitting is something we should really do, if 
>> there's people interested in and capable of pulling it off.
>
> And since I'm one of the people that care about the RT patch (which
> modifies the scheduler files) I'll just start with baby steps and reorg
> the headers. 

Understood.  Thanks for the explanation!

Thanks,
Namhyung
