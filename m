Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227AbaEHHtZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 03:49:25 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:63120 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbaEHHtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 03:49:24 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH v3 2/3] perf record: Propagate exit status of a command line workload
References: <1398346054-3322-1-git-send-email-namhyung@kernel.org>
	<1398346054-3322-2-git-send-email-namhyung@kernel.org>
	<20140429105654.GB1148@krava.brq.redhat.com>
	<20140429111939.GP11096@twins.programming.kicks-ass.net>
	<20140429113747.GD1148@krava.brq.redhat.com>
	<87tx9boeaf.fsf@sejong.aot.lge.com>
	<20140507150404.GO30445@twins.programming.kicks-ass.net>
	<CABPqkBTC-MjMB0U0+NjqrdKFFuoQt-N7MZJikcbcWJpLLgVRRg@mail.gmail.com>
	<20140507173532.GV30445@twins.programming.kicks-ass.net>
Date: Thu, 08 May 2014 16:49:20 +0900
In-Reply-To: <20140507173532.GV30445@twins.programming.kicks-ass.net> (Peter
	Zijlstra's message of "Wed, 7 May 2014 19:35:32 +0200")
Message-ID: <87eh04oglb.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Wed, 7 May 2014 19:35:32 +0200, Peter Zijlstra wrote:
> On Wed, May 07, 2014 at 07:19:14PM +0200, Stephane Eranian wrote:
>> > $ while :; do ./foo /bin/sleep 5 ; done
>> >
>> > and try and break out using ^C
>> >
>> What I usually do here is hit ^Z, then kill the job.
>> But I agree it would be nicer to handle this case automatically.
>
> So that used to work. And note that if you take out the signal(SIGINT,
> SIG_IGN) from the proglet, it will actually propagate the SIGINT and
> work as expected.
>
> So its only because perf handles SIGINT -- to be able to finish the
> stat/data record, that it doesn't. Which is why I propagated the signal
> the child got killed with.

Ah, okay.  But just propagating saved signal looks not enough since it's
overwritten by SIGCHLD as child exited.  I'll resend v5 soon.

Thanks,
Namhyung
