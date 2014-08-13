Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbaHMUrp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 16:47:45 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:48242 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbaHMUrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 16:47:43 -0400
MIME-Version: 1.0
In-Reply-To: <20140813203739.GL2718@kernel.org>
References: <1407831366-28892-1-git-send-email-namhyung@kernel.org>
	<1407831366-28892-2-git-send-email-namhyung@kernel.org>
	<CABPqkBRirVbT05OhS4CVedpzt44hGijFSgdL+4XqjVW-ixcp7g@mail.gmail.com>
	<20140813203739.GL2718@kernel.org>
Date: Wed, 13 Aug 2014 22:47:43 +0200
Message-ID: <CABPqkBTLgcoDvL9stCOpa7tE3eobN0Us5pfquWKGRy-d88cvjg@mail.gmail.com>
Subject: Re: [PATCH 2/2] perf top: Handle 'z' key for toggle zeroing samples
 in TUI
From: Stephane Eranian <eranian@google.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 10:37 PM, Arnaldo Carvalho de Melo
<acme@kernel.org> wrote:
>
> Em Wed, Aug 13, 2014 at 01:07:30AM +0200, Stephane Eranian escreveu:
> > On Tue, Aug 12, 2014 at 10:16 AM, Namhyung Kim <namhyung@kernel.org> wrote:
> > > The perf top TUI lacks 'z' key support to toggle sample zeroing.
> > > Add it.
> > >
> > Works for me.
> > Tested-by: Stephane Eranian <eranian@google.com>
>
> One thing that can be improved: Make it trigger a refresh in the right
> after 'z' is pressed.
>
> Also, this toggles the zeroing before each sample, it would be nice to
> have a visual cue that this is in effect, probably in the first line in
> the screen, perhaps on the far right, something like [z] when this is in
> effect and nothing when not.
>
I agree. Had to run a test on the side to verify that it was actually doing
the right thing.

>
> Right now the way to figure this out is to observe the number of
> samples, if it increases monotonically, zeroing before refresh is not in
> effect, if it goes from a high number to a smaller or vice versa,
> zeroing is in effect :-)
>
> Anyway, applied, people wanting this feature can figure this out, what I
> suggested is just polishing.
>
We need to visual cue.

>
> Thanks!
>
> - Arnaldo
>
> > > Reported-by: Stephane Eranian <eranian@google.com>
> > > Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> > > ---
> > >  tools/perf/ui/browsers/hists.c | 9 +++++++++
> > >  1 file changed, 9 insertions(+)
> > >
> > > diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
> > > index 045c1e16ac59..381c085a41b8 100644
> > > --- a/tools/perf/ui/browsers/hists.c
> > > +++ b/tools/perf/ui/browsers/hists.c
> > > @@ -10,6 +10,7 @@
> > >  #include "../../util/pstack.h"
> > >  #include "../../util/sort.h"
> > >  #include "../../util/util.h"
> > > +#include "../../util/top.h"
> > >  #include "../../arch/common.h"
> > >
> > >  #include "../browser.h"
> > > @@ -1530,6 +1531,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
> > >         "P             Print histograms to perf.hist.N\n"
> > >         "t             Zoom into current Thread\n"
> > >         "V             Verbose (DSO names in callchains, etc)\n"
> > > +       "z             Toggle zeroing of samples\n"
> > >         "/             Filter symbol by name";
> > >
> > >         if (browser == NULL)
> > > @@ -1630,6 +1632,13 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
> > >                 case 'F':
> > >                         symbol_conf.filter_relative ^= 1;
> > >                         continue;
> > > +               case 'z':
> > > +                       if (!is_report_browser(hbt)) {
> > > +                               struct perf_top *top = hbt->arg;
> > > +
> > > +                               top->zero = !top->zero;
> > > +                       }
> > > +                       continue;
> > >                 case K_F1:
> > >                 case 'h':
> > >                 case '?':
> > > --
> > > 2.0.0
> > >
