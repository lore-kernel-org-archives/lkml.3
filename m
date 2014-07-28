Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903AbaG1IU2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 04:20:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165AbaG1IU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 04:20:27 -0400
Date: Mon, 28 Jul 2014 10:19:48 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 02/27] perf tools: Fix jump label always changing during
 tracing
Message-ID: <20140728081948.GA1124@krava.brq.redhat.com>
References: <1406302629-11790-1-git-send-email-acme@kernel.org>
 <1406302629-11790-3-git-send-email-acme@kernel.org>
 <20140728065844.GK6758@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140728065844.GK6758@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 08:58:44AM +0200, Peter Zijlstra wrote:
> On Fri, Jul 25, 2014 at 12:36:44PM -0300, Arnaldo Carvalho de Melo wrote:
> > From: Adrian Hunter <adrian.hunter@intel.com>
> > 
> > Intel PT decoding walks the object code to reconstruct the trace.  A
> > jump label change during tracing causes decoding errors.
> > 
> > The "Enable close-on-exec flag on perf file descriptor" patch caused
> > there to be always a jump label change.
> > 
> > It was found that using a per-cpu context instead of a per-thread
> > context for the probe of the close-on-exec feature, made the problem go
> > away.
> 
> per-cpu events are privileged, wouldn't this change make CLOEXEC always
> undetected for normal users?
> 
> Also, the $subject doesn't related to CLOEXEC at all.

right, it would.. Ingo, still any chance to skip this one?

[jolsa@dhcp-26-214 perf]$ ./perf record sleep 1
perf_event_open(..., PERF_FLAG_FD_CLOEXEC) failed with unexpected error 13 (Permission denied)
perf_event_open(..., 0) failed unexpectedly with error 13 (Permission denied)

jirka
