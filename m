Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736Ab3LBPGD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 10:06:03 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:54300 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab3LBPGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 10:06:00 -0500
Subject: Re: [PATCH 1/3] perf tools: Record total sampling time
From: Namhyung Kim <namhyung@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        Pekka Enberg <penberg@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <20131202124527.GB22212@gmail.com>
References: <1385967199-3759-1-git-send-email-namhyung@kernel.org>
	 <1385967199-3759-2-git-send-email-namhyung@kernel.org>
	 <20131202124527.GB22212@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Dec 2013 00:05:49 +0900
Message-ID: <1385996749.1710.34.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

2013-12-02 (월), 13:45 +0100, Ingo Molnar:
> * Namhyung Kim <namhyung@kernel.org> wrote:
> 
> > From: Namhyung Kim <namhyung.kim@lge.com>
> > 
> > It's sometimes useful to see total sampling or elapsed time with
> > normal performance result.  To do that, record first and last sample
> > time for each evsel and to display it in the header (--stdio only for
> > now).
> > 
> >   $ perf record -a sleep 1
> >   $ perf report --stdio
> >   ...
> >   # Samples: 4K of event 'cycles'
> >   # Event count (approx.): 4087481688
> >   # Total sampling time  : 1.001260 (sec)
> 
> Btw., would it make sense to output it using the 'perf stat' print-out 
> machinery?
> 
> If the 'count' of every event sampled is saved in the perf.data, 
> including elapsed time, at the beginning and at the end, then all 
> information is there to output things in perf stat style.

Yeah, it'd be great if we can share same code in the end.

> 
> ( It might even make sense to save two more timestamps: rusage stime
>   and utime - that way the output could be made /usr/bin/time-alike. )

Hmm.. I think I can do it by adding time info according to a cpumode in
a sample.

> 
> Also I think there is some related existing functionality, I think 
> Stephane added a way to essentially do non-sampling 'perf stat' via 
> perf record - but the details escape me, I think it was related to the 
> -n option?

I have no idea about the perf record -n/--no-samples option.  It looks
like something related to task stat?

  commit 649c48a9e7fafcc72bfcc99471d9dea98d789d59
  Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
  Date:   Wed Jun 24 21:12:48 2009 +0200
  
      perf-report: Add modes for inherited stats and no-samples
      
      Now that we can collect per task statistics, add modes that
      make use of that facility.
      
      Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
      LKML-Reference: <new-submission>
      Signed-off-by: Ingo Molnar <mingo@elte.hu>


But everytime I tried to use it, perf report always complained about the
file has no samples.. :-/

> 
> So what we want here is in essence a sampling mode that can record and 
> report all the absolute counts as well.

Agreed.

Thanks,
Namhyung


