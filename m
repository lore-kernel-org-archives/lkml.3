Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957AbaKTGLX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 01:11:23 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:49919 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755748AbaKTGLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 01:11:21 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: byungchul.park@lge.com, mingo@redhat.com, linux-kernel@vger.kernel.org,
        seungho1.park@lge.com, jolsa@redhat.com
Subject: Re: [PATCH v4 3/3] tracing: add additional marks to signal very large delay
References: <1416290246-882-1-git-send-email-byungchul.park@lge.com>
	<1416290246-882-4-git-send-email-byungchul.park@lge.com>
	<20141119133515.1caa293e@gandalf.local.home>
Date: Thu, 20 Nov 2014 15:11:19 +0900
In-Reply-To: <20141119133515.1caa293e@gandalf.local.home> (Steven Rostedt's
	message of "Wed, 19 Nov 2014 13:35:15 -0500")
Message-ID: <87egsypfjs.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Nov 2014 13:35:15 -0500, Steven Rostedt wrote:
> On Tue, 18 Nov 2014 14:57:26 +0900
> byungchul.park@lge.com wrote:
>
>> From: Byungchul Park <byungchul.park@lge.com>
>> 
>> Currently, some tracers tracing latency print "!" or "+" just after time
>> to signal overhead, depending on the interval between events. Even it is
>> usually enough to do that, we sometimes need to be signaled for bigger
>> interval than 100 micro seconds.
>> 
>> Signed-off-by: Byungchul Park <byungchul.park@lge.com>
>> ---
>>  Documentation/trace/ftrace.txt |    8 +++++---
>>  kernel/trace/trace_output.c    |   23 ++++++++++++++++++-----
>>  2 files changed, 23 insertions(+), 8 deletions(-)
>> 
>> diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
>> index f827e2f..64efb3e 100644
>> --- a/Documentation/trace/ftrace.txt
>> +++ b/Documentation/trace/ftrace.txt
>> @@ -680,9 +680,11 @@ The above is mostly meaningful for kernel developers.
>>  	 needs to be fixed to be only relative to the same CPU.
>>  	 The marks are determined by the difference between this
>>  	 current trace and the next trace.
>> -	  '!' - greater than preempt_mark_thresh (default 100)
>> -	  '+' - greater than 1 microsecond
>> -	  ' ' - less than or equal to 1 microsecond.
>> +	  '$' - greater than 1 second
>> +	  '#' - greater than 1000 microsecond
>> +	  '!' - greater than 100 microsecond
>> +	  '+' - greater than 10 microsecond

I've noticed that it's now changed from 1 msec to 10 msec.  Is it okay?

Thanks,
Namhyung


>> +	  ' ' - less than or equal to 10 microsecond.
>>  
>>    The rest is the same as the 'trace' file.
