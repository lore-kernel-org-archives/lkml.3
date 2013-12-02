Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264Ab3LBMpf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 07:45:35 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:55322 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab3LBMpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 07:45:31 -0500
Date: Mon, 2 Dec 2013 13:45:27 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>, Stephane Eranian <eranian@google.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/3] perf tools: Record total sampling time
Message-ID: <20131202124527.GB22212@gmail.com>
References: <1385967199-3759-1-git-send-email-namhyung@kernel.org>
 <1385967199-3759-2-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385967199-3759-2-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Namhyung Kim <namhyung@kernel.org> wrote:

> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> It's sometimes useful to see total sampling or elapsed time with
> normal performance result.  To do that, record first and last sample
> time for each evsel and to display it in the header (--stdio only for
> now).
> 
>   $ perf record -a sleep 1
>   $ perf report --stdio
>   ...
>   # Samples: 4K of event 'cycles'
>   # Event count (approx.): 4087481688
>   # Total sampling time  : 1.001260 (sec)

Btw., would it make sense to output it using the 'perf stat' print-out 
machinery?

If the 'count' of every event sampled is saved in the perf.data, 
including elapsed time, at the beginning and at the end, then all 
information is there to output things in perf stat style.

( It might even make sense to save two more timestamps: rusage stime
  and utime - that way the output could be made /usr/bin/time-alike. )

Also I think there is some related existing functionality, I think 
Stephane added a way to essentially do non-sampling 'perf stat' via 
perf record - but the details escape me, I think it was related to the 
-n option?

So what we want here is in essence a sampling mode that can record and 
report all the absolute counts as well.

Thanks,

	Ingo
