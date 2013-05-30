Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751039Ab3E3L5Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 07:57:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34720 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216Ab3E3L5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 07:57:18 -0400
Date: Thu, 30 May 2013 13:56:27 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/2] perf: Enable wakeup_events logic for all events
Message-ID: <20130530115627.GC1099@krava.brq.redhat.com>
References: <1369907587-8963-1-git-send-email-jolsa@redhat.com>
 <1369907587-8963-2-git-send-email-jolsa@redhat.com>
 <20130530110239.GN12193@twins.programming.kicks-ass.net>
 <20130530115113.GB2391@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130530115113.GB2391@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 02:51:13PM +0300, Arnaldo Carvalho de Melo wrote:
> Em Thu, May 30, 2013 at 01:02:39PM +0200, Peter Zijlstra escreveu:
> > On Thu, May 30, 2013 at 11:53:06AM +0200, Jiri Olsa wrote:
> > > Currently the perf_events_attr::wakeup_events logic is
> > > checked only for regular samples.
> 
> > So something like this came up before and ISTR doing a patch similar to
> > what you propose but ended up not going with it because... uhm...
> 
> > I have vague memories about people (possibly me) wanting wake_events to
> > mean samples. Like get me a wakeup every 20 samples. With your patch the
> > side-band events now also count towards 'events'.
> 
> I think it was me, and the test case is tools/perf/pythoh/twatch.py,
> that just wants those side band events, the "fix" was:
> 
> commit cfeb1d90a1b1db96383b48888cb7a5f10ca12e12
> Author: Arnaldo Carvalho de Melo <acme@redhat.com>
> Date:   Mon Jan 30 14:43:21 2012 -0200
> 
>     perf python: Use attr.watermark in twatch.py
>     
>     We want to be woken up for every PERF_RECORD_ event,
> attr.wakeup_events is only for PERF_RECORD_SAMPLE, so also use
> attr.watermark = 1 to fix that.

ah right, using wattermark=1.. ok ;-)

thanks,
jirka
