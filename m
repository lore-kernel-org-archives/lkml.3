Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933453AbaGXPVd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 11:21:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3140 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933291AbaGXPVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 11:21:31 -0400
Date: Thu, 24 Jul 2014 17:20:56 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: David Ahern <dsahern@gmail.com>, Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>, Jiri Olsa <jolsa@kernel.org>,
        linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCHv3 00/19] perf tools: Factor ordered samples queue
Message-ID: <20140724152056.GC25165@krava.brq.redhat.com>
References: <53CCB6AE.6020505@intel.com>
 <20140721080219.GA4183@krava.redhat.com>
 <53CCD3A7.5070002@intel.com>
 <20140721095415.GB8865@krava.redhat.com>
 <87d2cy3c7m.fsf@tassilo.jf.intel.com>
 <53CD5AB5.3000307@intel.com>
 <53CD5DC6.3030605@gmail.com>
 <20140724141958.GB7831@kernel.org>
 <20140724145611.GB25165@krava.brq.redhat.com>
 <20140724151009.GD7831@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140724151009.GD7831@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 12:10:09PM -0300, Arnaldo Carvalho de Melo wrote:

SNIP

> > 
> > should be good to go..
> > 
> > Namhyung pointed out performance implications for patch 17:
> >   perf tools: Always force PERF_RECORD_FINISHED_ROUND event
> 
> I haven't seen this comment, just saw David, IIUC, having problems using
> the whole patchkit, David?
> 
> My tests were more to counter what he said, i.e. that:
> 
> <quote David Ahern>
> No overload condition, no dropped chunks message - yet can't process
> events
> </>
> 
> I see no overload condition, no dropped chunks message, I was pounding
> the machine with a big load and could process the events, so all seems
> well.
> 
> And from the discussion I understood that patch 17 is the most important
> one, agreed by you and Adrian, right?

yes, it drives the flush (in report) to happen

Namhyung pointed out, that now we store extra event for
non-tracepoint events sessions.. which might have performance
implications:

  http://marc.info/?l=linux-kernel&m=140266032913387&w=2


> 
> I.e. the other ones are refactorings to make it have better naming and
> to allow it being used elsewhere (builtin-trace.c, whee), but still need
> some more polishing/testing, is that right?

correct.. I plan to polish the debug output patchset,
I dont think I've got comments for the rest

jirka
