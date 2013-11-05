Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab3KEJmo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 04:42:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51607 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752839Ab3KEJmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 04:42:42 -0500
Date: Tue, 5 Nov 2013 10:42:20 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V3 06/11] perf record: Add an option to force per-cpu
 mmaps
Message-ID: <20131105094220.GA1071@krava.brq.redhat.com>
References: <1383313899-15987-1-git-send-email-adrian.hunter@intel.com>
 <1383313899-15987-7-git-send-email-adrian.hunter@intel.com>
 <20131104152942.GA4004@krava.brq.redhat.com>
 <5278AC36.1020702@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5278AC36.1020702@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 05, 2013 at 10:28:38AM +0200, Adrian Hunter wrote:
> On 04/11/13 17:29, Jiri Olsa wrote:
> > On Fri, Nov 01, 2013 at 03:51:34PM +0200, Adrian Hunter wrote:
> >> By default, when tasks are specified (i.e. -p, -t
> >> or -u options) per-thread mmaps are created.  Add
> >> an option to override that and force per-cpu mmaps.
> >>
> >> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> >> ---
> >>  tools/perf/Documentation/perf-record.txt | 6 ++++++
> >>  tools/perf/builtin-record.c              | 2 ++
> >>  tools/perf/util/evlist.c                 | 4 +++-
> >>  tools/perf/util/evsel.c                  | 4 ++--
> >>  tools/perf/util/target.h                 | 1 +
> >>  5 files changed, 14 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
> >> index f10ab63..2ea6685 100644
> >> --- a/tools/perf/Documentation/perf-record.txt
> >> +++ b/tools/perf/Documentation/perf-record.txt
> >> @@ -189,6 +189,12 @@ abort events and some memory events in precise mode on modern Intel CPUs.
> >>  --transaction::
> >>  Record transaction flags for transaction related events.
> >>  
> >> +--force-per-cpu::
> >> +Force the use of per-cpu mmaps.  By default, when tasks are specified (i.e. -p,
> >> +-t or -u options) per-thread mmaps are created.  This option overrides that and
> >> +forces per-cpu mmaps.  A side-effect of that is that inheritance is
> >> +automatically enabled.  Add the -i option also to disable inheritance.
> > 
> > I recently sent out patch that actually force perf cpu mmaps for -p,-t,-u
> > http://marc.info/?l=linux-kernel&m=138332119912433&w=2
> > 
> > Is there a reason why would you want to keep single
> > mmap (in record command) and cut yourself from inherited
> > events?
> 
> Not sure I understand the question.
> 
> perf supports having a single context for a thread.  That is a
> feature.  You seem to be removing perf tools support for it.
> 
> I image a case where the user has hundreds of CPUs but just
> wants to record one thread.  Currently -t does that. i.e.
> one file descriptor and one mmap saving megabytes of memory.
> 
> Another advantage of per-thread mmaps is that you do not
> need to sample time (nor cpu), because the events are recorded
> in order.
> 
> I was adding a feature.  Users can choose per-cpu mmaps if
> they want.

right, I haven't considered the hundreds CPU machine.. I just
saw that it disables inherited events in my test ;-) maybe we
could mentioned that somewhere, because it's not clear

jirka
