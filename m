Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596Ab3LCSXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 13:23:17 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:49457 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab3LCSXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 13:23:15 -0500
Date: Tue, 3 Dec 2013 15:23:05 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/7] perf script: Do not call
 perf_event__preprocess_sample() twice)
Message-ID: <20131203182305.GA2052@ghostprotocols.net>
References: <1386055390-13757-1-git-send-email-adrian.hunter@intel.com>
 <1386055390-13757-2-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386055390-13757-2-git-send-email-adrian.hunter@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Dec 03, 2013 at 09:23:04AM +0200, Adrian Hunter escreveu:
> perf_event__preprocess_sample() is called in
> process_sample_event().  Instead of calling it
> again in perf_evsel__print_ip(), pass though
> the resultant addr_location.

<SNIP>
> +++ b/tools/perf/util/session.c
> @@ -1487,11 +1487,12 @@ struct perf_evsel *perf_session__find_first_evtype(struct perf_session *session,
>  	return NULL;
>  }
>  
> -void perf_evsel__print_ip(struct perf_evsel *evsel, union perf_event *event,
> +void perf_evsel__print_ip(struct perf_evsel *evsel,
> +			  union perf_event *event __maybe_unused,

Why do we have to keep this parameter?

- Arnaldo
