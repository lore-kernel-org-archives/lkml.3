Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356AbaKZH5i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 02:57:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51965 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752098AbaKZH5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 02:57:37 -0500
Date: Wed, 26 Nov 2014 08:57:21 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Tom Huynh <tom.huynh@freescale.com>, mingo@redhat.com, acme@kernel.org,
        namhyung@kernel.org, jolsa@kernel.org, a.p.zijlstra@chello.nl,
        paulus@samba.org, kim.phillips@freescale.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf hist browser: change print format from lu to llu to
 fit u64 type
Message-ID: <20141126075721.GC26946@krava.brq.redhat.com>
References: <1416351627-360-1-git-send-email-tom.huynh@freescale.com>
 <20141125235128.GA25625@hydra.tuxags.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141125235128.GA25625@hydra.tuxags.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 03:51:30PM -0800, Matt Mullins wrote:
> On Tue, Nov 18, 2014 at 05:00:27PM -0600, Tom Huynh wrote:
> > nr_events in tools/perf/ui/browsers/hists.c is of type u64, thus it should
> > be printed as %llu instead of %lu. The print format %lu causes perf report
> > to show 0 event count when running with 32-bit userspace without 
> > redirection. This patch fixes that problem.
> > 
> > Signed-off-by: Tom Huynh <tom.huynh@freescale.com>
> > ---
> >  tools/perf/ui/browsers/hists.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
> > index cfb976b..49b2471 100644
> > --- a/tools/perf/ui/browsers/hists.c
> > +++ b/tools/perf/ui/browsers/hists.c
> > @@ -1254,7 +1254,7 @@ static int hists__browser_title(struct hists *hists,
> >  
> >  	nr_samples = convert_unit(nr_samples, &unit);
> >  	printed = scnprintf(bf, size,
> > -			   "Samples: %lu%c of event '%s', Event count (approx.): %lu",
> > +			   "Samples: %lu%c of event '%s', Event count (approx.): %llu",
> >  			   nr_samples, unit, ev_name, nr_events);
> 
> If I enable __attribute__((format(printf, ...))) on scnprintf, on a 64-bit
> build this gives me:
> 
> ui/browsers/hists.c: In function ‘hists__browser_title’:
> ui/browsers/hists.c:1258:7: error: format ‘%llu’ expects argument of type ‘long long unsigned int’, but argument 7 has type ‘u64’ [-Werror=format=]
>        nr_samples, unit, ev_name, nr_events);
>        ^
> 
> I would usually suggest using the PRIu64 macro which should(TM) evaluate to the
> right string constant for the platform, but that appears to be a C99 thing.
> I'm not sure if that's kosher in tools/perf, but it does seem to build for me
> (on Fedora 20).

[jolsa@krava linux-perf]$ grep -rI PRIu64 tools/perf/ | wc -l
97

yep, it's kosher enough ;-)

jirka
