Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbaCSUZf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 16:25:35 -0400
Received: from mail-yh0-f43.google.com ([209.85.213.43]:55514 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212AbaCSUZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 16:25:32 -0400
Date: Wed, 19 Mar 2014 17:25:23 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 3/9] perf hists: Add support for showing relative
 percentage
Message-ID: <20140319202523.GH6482@ghostprotocols.net>
References: <1394437440-11609-1-git-send-email-namhyung@kernel.org>
 <1394437440-11609-4-git-send-email-namhyung@kernel.org>
 <20140318200837.GG6482@ghostprotocols.net>
 <CAM9d7cgkpFr7z+CXwYxaPJtssr6CRA7uX-Z6tpLAQ2qoic4FOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM9d7cgkpFr7z+CXwYxaPJtssr6CRA7uX-Z6tpLAQ2qoic4FOg@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Mar 19, 2014 at 12:18:00AM +0000, Namhyung Kim escreveu:
> Hi Arnaldo,
> 
> On Tue, Mar 18, 2014 at 8:08 PM, Arnaldo Carvalho de Melo
> <acme@ghostprotocols.net> wrote:
> > Em Mon, Mar 10, 2014 at 04:43:54PM +0900, Namhyung Kim escreveu:
> >> @@ -695,12 +695,17 @@ static void hists__remove_entry_filter(struct hists *hists, struct hist_entry *h
> >>       if (h->filtered)
> >>               return;
> >>
> >> -     ++hists->nr_entries;
> >> -     if (h->ms.unfolded)
> >> +     hists->nr_entries++;
> >> +     hists->nr_non_filtered_entries++;
> >
> > Why not keep existing practice? prefix or suffix generates the same
> > code, changing it from prefix to suffix increment just adds noise to the
> > patch :-\
> 
> Argh, sorry - I couldn't resist changing it.  Won't do that in the future. :-/

We should strive to be as minimalistic as possible. Reviewing is hard,
we shouldn't make it harder :-)

Cleanup/cosmetic patches, when deemed necessary should be done
separatetly and stated as such.
 
> > Also, this is why I was asking about nr_entries and total_period being
> > invariant, looking at this function we can see it is _not_ invariant, as
> > when we apply/remove filters we touch them.
> >
> > This is why I made the comment (in a private conversation) about having
> > a invariant_total_period invariant_nr_entries pair (I think I used some
> > other naming) while knowing that the existing variables nr_entries and
> > total_period are actually subjected to the filters being used.
> >
> > I.e. to avoid confusion we need to make total_entries and nr_entries
> > never change when a filter is applied, touching only two new variables
> > for non_filtered total_period and nr_entries.
> >
> > I'll try doing it if you don't do it first, but will first process some
> > more patches and submit what I already processed.
> 
> Please see the next patch 4/9 ("perf report: Add --percentage option")
> doing that.  What I did in this patch is just adding new
> non_filtered_* fields and not changing existing behavior.  And in the
> next patch, the total_period and nr_entries will become invariant.
> 
> Do you want to split the patch 4/9 or merge a part of it into this?

The point is that I don't look at all the patches (nor should I, I
think) to figure out what one wants to do after a series is applied.

So each patch should stand on its own, each one should be meaningful
without requiring reading what is coming next.

- Arnaldo
