Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110Ab3F0Fqj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 01:46:39 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:57570 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab3F0Fqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 01:46:38 -0400
X-AuditID: 9c930179-b7cafae000004567-08-51cbd1bcf10d
From: Namhyung Kim <namhyung@kernel.org>
To: Robert Richter <rric@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/14] perf, persistent: Kernel updates for perf tool integration
References: <1370968960-22527-1-git-send-email-rric@kernel.org>
	<20130624152557.GU28407@twins.programming.kicks-ass.net>
	<20130624194510.GC4065@gmail.com>
	<20130625175729.GI21579@rric.localhost>
	<20130625191654.GH4855@pd.tnic>
	<20130626081223.GB21788@rric.localhost>
	<20130626082408.GA20274@pd.tnic>
	<20130626101132.GC21788@rric.localhost>
	<20130626114538.GA4117@gmail.com>
	<20130626124424.GD21788@rric.localhost>
Date: Thu, 27 Jun 2013 14:46:36 +0900
In-Reply-To: <20130626124424.GD21788@rric.localhost> (Robert Richter's message
	of "Wed, 26 Jun 2013 14:44:24 +0200")
Message-ID: <8761x014xv.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robert,

On Wed, 26 Jun 2013 14:44:24 +0200, Robert Richter wrote:
> On 26.06.13 13:45:38, Ingo Molnar wrote:
>> [ How about to additional logic: attr.persistent=1 && attr.config==0 means 
>>   a new persistent event is created straight away - no ioctl is needed to 
>>   detach it explicitly. ]
>
> That's correct. We could also do the following:
>
> To connect to an existing event:
>
>  attr.type=<persistent-pmu> && attr.config==<event-id>
>
> (This might be harder to implement except the persistent event pmu
> type will be fix, PERF_TYPE_PERSISTENT=6.)
>
> To create a new persistent event:
>
>  attr.persistent=1 && attr=<some event setup: pmu, config, flags, etc>

How about using 2 bits for perfsistent flag, 1 for connecting to an
existing one, 2 for creating new one.


>> >  * The persistent event is opened with the syscall, the process gets a
>> >    new fd of the event.
>> >  * The process attaches to the event buffer with mmap.
>> 
>> Yes. And gets the pre-existing event and mmap buffer.
>
> That's what I mean.
>
> A problem here is that mmap'ed buffer size (number of pages) must be
> be equal to the pre-existing buffer size and thus to be known somehow.

What about also exporting the buffer size via sysfs pmu directory?

Thanks,
Namhyung
