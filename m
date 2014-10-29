Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170AbaJ2Izt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 04:55:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46713 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755504AbaJ2Izr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 04:55:47 -0400
Date: Wed, 29 Oct 2014 09:55:14 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 01/16] perf tools: Add id index
Message-ID: <20141029085514.GD3538@krava.brq.redhat.com>
References: <1414061124-26830-1-git-send-email-adrian.hunter@intel.com>
 <1414061124-26830-2-git-send-email-adrian.hunter@intel.com>
 <20141023210817.GN14687@kernel.org>
 <5449FECE.5020807@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5449FECE.5020807@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 10:25:02AM +0300, Adrian Hunter wrote:
> On 24/10/14 00:08, Arnaldo Carvalho de Melo wrote:
> > Em Thu, Oct 23, 2014 at 01:45:09PM +0300, Adrian Hunter escreveu:
> >> Add an index of the event identifiers.
> >>
> >> This is needed to queue Instruction
> >> Trace samples according to the mmap
> >> buffer from which they were recorded.
> > 
> > This gets difficult to review, I end up having to look at all the
> > patches together to figure out the use cases, to see if this here makes
> > sense...
> > 
> > Can you try to explain like to a seven year old?
> > 
> > Sigh.
> > 
> > 'id' is somethig super vague, what does this identifies? I want to make
> > progress processing these patches, but with so short explanations like
> > the above one, it gets difficult.
> 
> This is the event id (also called the sample id) which is a unique number
> allocated by the kernel to the event created by perf_event_open().  Events
> can include the event id by having a sample type including PERF_SAMPLE_ID or
> PERF_SAMPLE_IDENTIFIER.
> 
> Currently the main use of the event id is to match an event back to the
> evsel to which it belongs i.e. perf_evlist__id2evsel()
> 
> The purpose of this patch is to make it possible to match an event back to
> the mmap from which it was read.  The reason that is useful is because the
> mmap represents a time-ordered context (either for a cpu or for a thread).
> Intel PT decodes trace information on that basis.  In full-trace mode, that
> information can be recorded when the Intel PT trace is read, but in
> sample-mode the Intel PT trace data is embedded in a sample and it is in
> that case that the "id index" is needed.
> 
> So the mmaps are numbered (idx) and the cpu and tid recorded against the id
> by perf_evlist__set_sid_idx() which is called by perf_evlist__mmap_per_evsel().
> 
> That information is recorded on the perf.data file in the new "id index".
> idx, cpu and tid are added to struct perf_sample_id (which is the node of
> evlist's hash table to match ids to evsels).  The information can be
> retrieved using perf_evlist__id2sid().  Note however this all depends on
> having a sample type including PERF_SAMPLE_ID or PERF_SAMPLE_IDENTIFIER,
> otherwise ids are not recorded.
> 
> The "id index" is a synthesized event record which will be created when
> Intel PT sampling is used by calling perf_event__synthesize_id_index().

with above text in changelog:

Acked-by: Jiri Olsa <jolsa@kernel.org>

thanks,
jirka
