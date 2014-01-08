Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279AbaAHHiP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 02:38:15 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:64467 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539AbaAHHiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 02:38:08 -0500
X-AuditID: 9c93017e-b7cd8ae000002ce9-fc-52cd005eeefc
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 1/5] tools lib traceevent: Add WARN and WARN_ONCE macros
References: <1389063612-18173-1-git-send-email-namhyung@kernel.org>
	<1389063612-18173-2-git-send-email-namhyung@kernel.org>
	<20140107140747.GA3845@ghostprotocols.net>
Date: Wed, 08 Jan 2014 16:38:05 +0900
In-Reply-To: <20140107140747.GA3845@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Tue, 7 Jan 2014 11:07:47 -0300")
Message-ID: <87eh4idiua.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On Tue, 7 Jan 2014 11:07:47 -0300, Arnaldo Carvalho de Melo wrote:
> Em Tue, Jan 07, 2014 at 12:00:08PM +0900, Namhyung Kim escreveu:
>> They're copied from the perf code and will be used to print error
>> message during trace_seq_printf() and friends.
>> 
>> Suggested-by: Jiri Olsa <jolsa@redhat.com>
>> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
>
> We could take this opportunity and come up with
> tools/lib/{bug,compiler}.h, matching the files in include/linux/ where
> those helpers come from, no?

Hmm.. maybe under tools/include/ ?

>
> Then make both tools/perf/ and tools/lib/traceevent/ use it, instead of
> creating the third copy (kernel proper, perf, libtraceevent).

Okay.

>
> Then, does anybody know why likely/unlikely is guarded inside __KERNEL__
> in include/linux/compiler.h?

IIUC it's because of BRANCH_PROFILING..


> I think the best thing would be for us to just use:
>
> #include <linux/compiler.h> 
>
> just like kernel code and be done with it :-\

Yeah, but it seems to require some modifications.

Thanks,
Namhyung
