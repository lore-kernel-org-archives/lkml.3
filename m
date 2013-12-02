Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965Ab3LBSvb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 13:51:31 -0500
Received: from mail-qe0-f53.google.com ([209.85.128.53]:34529 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab3LBSv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 13:51:26 -0500
Date: Mon, 2 Dec 2013 15:51:16 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        Pekka Enberg <penberg@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/3] perf tools: Record total sampling time
Message-ID: <20131202185116.GB14254@ghostprotocols.net>
References: <1385967199-3759-1-git-send-email-namhyung@kernel.org>
 <1385967199-3759-2-git-send-email-namhyung@kernel.org>
 <20131202124527.GB22212@gmail.com>
 <1385996749.1710.34.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1385996749.1710.34.camel@leonhard>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Dec 03, 2013 at 12:05:49AM +0900, Namhyung Kim escreveu:
> Hi Ingo,
> 
> 2013-12-02 (월), 13:45 +0100, Ingo Molnar:
> > * Namhyung Kim <namhyung@kernel.org> wrote:
> > 
> > > From: Namhyung Kim <namhyung.kim@lge.com>
> > > 
> > > It's sometimes useful to see total sampling or elapsed time with
> > > normal performance result.  To do that, record first and last sample
> > > time for each evsel and to display it in the header (--stdio only for
> > > now).
> > > 
> > >   $ perf record -a sleep 1
> > >   $ perf report --stdio
> > >   ...
> > >   # Samples: 4K of event 'cycles'
> > >   # Event count (approx.): 4087481688
> > >   # Total sampling time  : 1.001260 (sec)
> > 
> > Btw., would it make sense to output it using the 'perf stat' print-out 
> > machinery?
> > 
> > If the 'count' of every event sampled is saved in the perf.data, 
> > including elapsed time, at the beginning and at the end, then all 
> > information is there to output things in perf stat style.
> 
> Yeah, it'd be great if we can share same code in the end.

I guess we'll basically just process all samples, accumulating stuff
where the builtin-stat code finds them, in struct perf_evsel, then just
hand it to that code.

- Arnaldo
