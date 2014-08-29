Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759AbaH2Nzr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 09:55:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:63863 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528AbaH2Nzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 09:55:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,424,1406617200"; 
   d="scan'208";a="583445346"
Message-ID: <54008590.7000507@intel.com>
Date: Fri, 29 Aug 2014 16:52:16 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 01/24] perf tools: Add a test for tracking with sched_switch
References: <1408129739-17368-1-git-send-email-adrian.hunter@intel.com> <1408129739-17368-2-git-send-email-adrian.hunter@intel.com> <20140820194813.GI2892@kernel.org>
In-Reply-To: <20140820194813.GI2892@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2014 10:48 PM, Arnaldo Carvalho de Melo wrote:
> Em Fri, Aug 15, 2014 at 10:08:36PM +0300, Adrian Hunter escreveu:
>> Add a test that checks that sched_switch events and
>> tracking events can be recorded for a workload using the
>> evsel->system_wide and evsel->tracking flags (respectively)
>> with other events sometimes enabled or disabled.
> 
> Really nice exercise! Gives lots of evlist/evsel routines a good test,
> checking for expected behaviour, really good, thanks.
> 
> One thing I noticed was that it uses parse_events() for creating events,
> a perhaps simpler equivalent would be:
> 
> 	switch_evsel = perf_evsel__newtp("sched", "sched_switch");
> 
> And then go on, like you did, configuring whatever attribute one wants
> to have set, like what you get from ":u", and the other things you
> touched, like:
> 
> 	switch_evsel->system_wide = true;
> 	switch_evsel->no_aux_samples = true;
> 	switch_evsel->immediate = true;
> 
> And when the evsel is all set up, if dealing with evlists, like in this
> case, just do a:
> 
> 	perf_evlist__add(evlist, switch_evsel);
> 
> Looks more natural than using parse_events(evlist, "sched:sched_switch");
> 
> To then infer that it must be the last entry at this point to retrieve
> it using:
> 
> 	switch_evsel = perf_evlist__last(evlist);
> 
> But, for the current architecture, that should be just a clarification,
> not a requirement for this specific test.

I will keep that in mind.

> Applying!

Thank you!

AFAICT the other 20 patches still apply cleanly to your tree, so I am not
going to send any more for now.

