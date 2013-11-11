Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab3KKMRV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 07:17:21 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:33018 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996Ab3KKMRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 07:17:14 -0500
Date: Mon, 11 Nov 2013 13:17:10 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Namhyung Kim <namhyung@kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Arun Sharma <asharma@fb.com>
Subject: Re: [RFC/PATCHSET 00/14] perf report: Add support to accumulate hist
 periods (v2)
Message-ID: <20131111121710.GC21397@gmail.com>
References: <20131101092759.GC27063@gmail.com>
 <87bo1zz4mu.fsf@sejong.aot.lge.com>
 <20131105074650.GA2855@gmail.com>
 <87txfrxlq8.fsf@sejong.aot.lge.com>
 <20131105115802.GA12045@gmail.com>
 <87ppqex8tj.fsf@sejong.aot.lge.com>
 <20131106083046.GA4655@gmail.com>
 <87r4atx51i.fsf@sejong.aot.lge.com>
 <20131106114701.GA20249@gmail.com>
 <20131106160952.GS10651@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131106160952.GS10651@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, Nov 06, 2013 at 12:47:01PM +0100, Ingo Molnar wrote:
>
> > I'm not too worried about call-graph 'legacies': it generates such 
> > huge perf.data files which is parsed so slowly at the moment that 
> > there's very little user base ... Anyone who absolutely needs 
> > call-graph profiling uses SysProf which performs well.
> 
> Uhm, say what? I use it, and I don't use sysprof since that thing is 
> totally not usable ;-)

You aren't a typical case at all! :-)

Just look back the example where Linus tried to use call-graph profiling 
to profile a mild 60-seconds workload (a kernel build) and came away 
reporting that his perf session locked up.

I think many other people ran into that performance problem. Those who are 
using it must be using it for far shorter workloads.

Anyway, that's all fixed now, and I do think that call-graph profiling is 
one of perf's killer features - I thought that from day 1 on when I 
suggested to Frederic that it would be really important to implement it 
;-)

Thanks,

	Ingo
