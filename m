Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbaIZGgp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 02:36:45 -0400
Received: from plane.gmane.org ([80.91.229.3]:41243 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753446AbaIZGgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 02:36:44 -0400
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Ingo Molnar <public-mingo-DgEjT+Ai2ygdnm+yROfE0A@plane.gmane.org>
Cc: Namhyung Kim 
	<public-namhyung-DgEjT+Ai2ygdnm+yROfE0A@plane.gmane.org>,
        Pawel Moll <public-pawel.moll-5wv7dgnIgG8@plane.gmane.org>,
        Richard Cochran 
	<public-richardcochran-Re5JQEeQqe8AvxtiuMwx3w@plane.gmane.org>,
        Steven Rostedt 
	<public-rostedt-nx8X9YLhiw1AfugRpC6u6w@plane.gmane.org>,
        Ingo Molnar <public-mingo-H+wXaHxf7aLQT0dZR+AlfA@plane.gmane.org>,
        Peter Zijlstra 
	<public-peterz-wEGCiKHe2LqWVfeAwA7xHQ@plane.gmane.org>,
        Paul Mackerras 
	<public-paulus-eUNUBHrolfbYtjvyW6yDsg@plane.gmane.org>,
        Arnaldo Carvalho de Melo 
	<public-acme-DgEjT+Ai2ygdnm+yROfE0A@plane.gmane.org>,
        John Stultz 
	<public-john.stultz-QSEj5FYQhm4dnm+yROfE0A@plane.gmane.org>,
        public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@plane.gmane.org,
        public-linux-api-u79uwXL29TY76Z2rM5mHXA@plane.gmane.org
Subject: Re: [PATCH v2 2/2] perf: Userspace event
References: <1411491787-25938-1-git-send-email-pawel.moll@arm.com>
	<1411491787-25938-3-git-send-email-pawel.moll@arm.com>
	<87oau5k0u9.fsf@sejong.aot.lge.com> <20140924072017.GC990@gmail.com>
Date: Fri, 26 Sep 2014 15:21:26 +0900
In-Reply-To: <20140924072017.GC990@gmail.com> (Ingo Molnar's message of "Wed,
	24 Sep 2014 09:20:17 +0200")
Message-ID: <87y4t6j40p.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Hi Ingo,

On Wed, 24 Sep 2014 09:20:17 +0200, Ingo Molnar wrote:
> * Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
>> On Tue, 23 Sep 2014 18:03:07 +0100, Pawel Moll wrote:
>> > This patch adds a new PERF_COUNT_SW_UEVENT software event
>> > and a related PERF_SAMPLE_UEVENT sample. User can now
>> > write to the the perf file descriptor, injecting such
>> > event in the perf buffer.
>> 
>> It seems the PERF_SAMPLE_UEVENT sample can be injected to any event.  So
>> why the PERF_COUNT_SW_UEVENT is needed?  At least one can use the
>> SW_DUMMY event for that purpose.
>> 
>> Also I think it'd be better to be a record type (PERF_RECORD_XXX)
>> instead of a sample flag (PERF_SAMPLE_XXX).  In perf tools, we already
>> use perf_user_event_type for synthesized userspace events.  This way it
>> can avoid unnecessary sample processing for userspace events.
>> 
>> For contents, I prefer to give complete control to users - kernel
>> doesn't need to care about it other than its size.  If one just wants to
>> use strings only, she can write them directly.  If others want to mix
>> different types of data, they might need to define a data format for
>> their use.
>
> It would also be nice to add support for this to tools/perf/ (so 
> that 'trace' displays such entries in a perf.data), with a 
> minimum testcase for 'perf test' as well.
>
> Perhaps also add a small sub-utility to inject such events from 
> the command line, such as:
>
>   trace user-event "this is a test message"
>
> ('trace' is a shortcut command for 'perf trace'.)
>
> It would have a usecase straight away: perf could be used to 
> easily trace script execution for example.

It looks like what trace-marker in ftrace does..  We might connect
output of the trace marker into a perf event somehow.

Thanks,
Namhyung


>
> For that probably another mode of user event generation would be 
> needed as well: a process that has no access to any perf fds 
> should still be able to generate user events, if the 
> profiling/tracing context has permitted that. In this case we'd 
> inject the event either into the first, or all currently active 
> events (but only once per output buffer, or so).
>
> Thanks,
>
> 	Ingo

