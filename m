Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791AbaD3AYM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 20:24:12 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:55072 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbaD3AYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 20:24:11 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH v3 2/3] perf record: Propagate exit status of a command line workload
References: <1398346054-3322-1-git-send-email-namhyung@kernel.org>
	<1398346054-3322-2-git-send-email-namhyung@kernel.org>
	<20140429105654.GB1148@krava.brq.redhat.com>
	<20140429111939.GP11096@twins.programming.kicks-ass.net>
	<20140429113747.GD1148@krava.brq.redhat.com>
Date: Wed, 30 Apr 2014 09:24:08 +0900
In-Reply-To: <20140429113747.GD1148@krava.brq.redhat.com> (Jiri Olsa's message
	of "Tue, 29 Apr 2014 13:37:47 +0200")
Message-ID: <87tx9boeaf.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri and Peter,

On Tue, 29 Apr 2014 13:37:47 +0200, Jiri Olsa wrote:
> On Tue, Apr 29, 2014 at 01:19:39PM +0200, Peter Zijlstra wrote:
>> On Tue, Apr 29, 2014 at 12:56:54PM +0200, Jiri Olsa wrote:
>> > 
>> >   perf_counter tools: Propagate signals properly
>> >   commit f7b7c26e01e51fe46097e11f179dc71ce7950084
>> >   Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
>> >   Date:   Wed Jun 10 15:55:59 2009 +0200
>> > 
>> > but I dont think we need to do that
>> 
>> But but but, then you're re-introducing that fail again? That no good.

FYI, it's already gone with 804f7ac78803 ("perf record: handle death by
SIGTERM").

>
> well, I was trying the testcase you mentioned in the changelog
> and it seemed to work for me.. ;-) I guess I was lucky to hit
> the bash time window..
>
>   while :; do perf stat ./foo ; done
>
> so how does this work? bash will kill the loop if perf's wait
> status is WIFSIGNALED?

I'm not sure but isn't it *bash* to catch signal and terminate the
loop?  It seems the wait status of child has no business with the loop
termination.  Am I missing something?

  $ cat suicide.c
  #include <signal.h>
  
  int main(void)
  {
    raise(SIGTERM);
    return 0;
  }
  
  $ gcc -o suicide suicide.c
  
  $ while :; do ./suicide; done
  Terminated
  Terminated
  Terminated
  Terminated
  Terminated
  Terminated
  Terminated
  Terminated
  Terminated
  Terminated
  Terminated
  Terminated
  Terminated
  Terminated
  Terminated
  Terminated
  Terminated
  Terminated
  Terminated
  Terminated
  Terminated
  Terminated
  Terminated
  Terminated
  Terminated
  Terminated
  Terminated
  Terminated
  Terminated
  Terminated
  Terminated
  Terminated
  Terminated
  Terminated
  Terminated
  Terminated
  Terminated
  Terminated
  ...


Thanks,
Namhyung
