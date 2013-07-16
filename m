Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520Ab3GPMG1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 08:06:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55020 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932146Ab3GPMGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 08:06:25 -0400
Date: Tue, 16 Jul 2013 14:05:49 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH V6 06/12] perf tools: remove unnecessary callchain
 validation
Message-ID: <20130716120549.GB9964@krava.brq.redhat.com>
References: <1373956698-27540-1-git-send-email-adrian.hunter@intel.com>
 <1373956698-27540-7-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373956698-27540-7-git-send-email-adrian.hunter@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 09:38:12AM +0300, Adrian Hunter wrote:

SNIP

>  	}
>  }
>  
> -static int perf_session__preprocess_sample(struct perf_session *session,
> -					   union perf_event *event, struct perf_sample *sample)
> -{
> -	if (event->header.type != PERF_RECORD_SAMPLE ||
> -	    !sample->callchain)
> -		return 0;
> -
> -	if (!ip_callchain__valid(sample->callchain, event)) {
> -		pr_debug("call-chain problem with event, skipping it.\n");
> -		++session->stats.nr_invalid_chains;
> -		session->stats.total_invalid_chains += sample->period;

How about the '*invalid_chains' stats here? I dont see
it incremented in the parsing routine.

Also the current behaviour is to increments stats for invalid
callchains, but dont fail. With your changes we fail during the
parsing.

On the other hand.. maybe we should fail ;-) I think that
invalid callchain data is serious enough to be overlooked
by not seeing the nr_invalid_chains got incremented.

let's see other comments and then silently push it :-)

jirka
