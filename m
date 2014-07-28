Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200AbaG1Kt2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 06:49:28 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:61246 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbaG1KtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 06:49:25 -0400
Date: Mon, 28 Jul 2014 12:49:16 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 02/27] perf tools: Fix jump label always changing during
 tracing
Message-ID: <20140728104916.GA14215@gmail.com>
References: <1406302629-11790-1-git-send-email-acme@kernel.org>
 <1406302629-11790-3-git-send-email-acme@kernel.org>
 <20140728065844.GK6758@twins.programming.kicks-ass.net>
 <20140728081948.GA1124@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140728081948.GA1124@krava.brq.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Olsa <jolsa@redhat.com> wrote:

> On Mon, Jul 28, 2014 at 08:58:44AM +0200, Peter Zijlstra wrote:
> > On Fri, Jul 25, 2014 at 12:36:44PM -0300, Arnaldo Carvalho de Melo wrote:
> > > From: Adrian Hunter <adrian.hunter@intel.com>
> > > 
> > > Intel PT decoding walks the object code to reconstruct the trace.  A
> > > jump label change during tracing causes decoding errors.
> > > 
> > > The "Enable close-on-exec flag on perf file descriptor" patch caused
> > > there to be always a jump label change.
> > > 
> > > It was found that using a per-cpu context instead of a per-thread
> > > context for the probe of the close-on-exec feature, made the problem go
> > > away.
> > 
> > per-cpu events are privileged, wouldn't this change make CLOEXEC always
> > undetected for normal users?
> > 
> > Also, the $subject doesn't related to CLOEXEC at all.
> 
> right, it would.. Ingo, still any chance to skip this one?
> 
> [jolsa@dhcp-26-214 perf]$ ./perf record sleep 1
> perf_event_open(..., PERF_FLAG_FD_CLOEXEC) failed with unexpected error 13 (Permission denied)
> perf_event_open(..., 0) failed unexpectedly with error 13 (Permission denied)
> 
> jirka

No, sorry - mind any of you please send a pull request with a fix or a 
revert?

Thanks,

	Ingo
