Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375Ab3CTDAq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 23:00:46 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:63337 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab3CTDAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 23:00:44 -0400
X-AuditID: 9c930179-b7c78ae000000e4b-cc-5149265bf9b8
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 6/9] perf util: Get rid of malloc_or_die() in trace-event-read.c
References: <1363683224-28804-1-git-send-email-namhyung@kernel.org>
	<1363683224-28804-7-git-send-email-namhyung@kernel.org>
	<1363704602.5938.26.camel@gandalf.local.home>
	<87ehfaj2ic.fsf@sejong.aot.lge.com>
	<1363744502.6345.1.camel@gandalf.local.home>
Date: Wed, 20 Mar 2013 12:00:43 +0900
In-Reply-To: <1363744502.6345.1.camel@gandalf.local.home> (Steven Rostedt's
	message of "Tue, 19 Mar 2013 21:55:02 -0400")
Message-ID: <871ubaixlw.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Mar 2013 21:55:02 -0400, Steven Rostedt wrote:
> On Wed, 2013-03-20 at 10:14 +0900, Namhyung Kim wrote:
>> On Tue, 19 Mar 2013 10:50:02 -0400, Steven Rostedt wrote:
>> > On Tue, 2013-03-19 at 17:53 +0900, Namhyung Kim wrote:
>> >>  	free(version);
>> >> @@ -331,11 +354,12 @@ ssize_t trace_report(int fd, struct pevent **ppevent, bool __repipe)
>> >>  
>> >>  	page_size = read4(pevent);
>> >>  
>> >> -	read_header_files(pevent);
>> >> -	read_ftrace_files(pevent);
>> >> -	read_event_files(pevent);
>> >> -	read_proc_kallsyms(pevent);
>> >> -	read_ftrace_printk(pevent);
>> >> +	if (read_header_files(pevent) ||
>> >> +	    read_ftrace_files(pevent) ||
>> >> +	    read_event_files(pevent) ||
>> >> +	    read_proc_kallsyms(pevent) ||
>> >> +	    read_ftrace_printk(pevent))
>> >> +		goto out;
>> >
>> > I think I like the err += func() and check for err < 0, better.
>> 
>> Okay, I'll change them to err |= func() style if you're fine as Peter
>> suggested.
>
> += or |= I'm not picky ;-)

Ah, one thing I also care was the short-circuit logic.  I think we don't
need to call later functions if one fails, do we?

Thanks,
Namhyung
