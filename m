Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408AbaJOTRa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 15:17:30 -0400
Received: from mail.kernel.org ([198.145.19.201]:60633 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbaJOTR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 15:17:29 -0400
Date: Wed, 15 Oct 2014 16:17:25 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Yasser Shalabi <yassershalabi@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@redhat.com, paulus@samba.org, a.p.zijlstra@chello.nl
Subject: Re: [PATCH] perf: fix for double free in tools/perf stat
Message-ID: <20141015191725.GQ3198@kernel.org>
References: <1412437077-13109-1-git-send-email-yassershalabi@gmail.com>
 <871tqkgus2.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871tqkgus2.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Oct 07, 2014 at 05:15:41PM +0900, Namhyung Kim escreveu:
> Hi Yasser,
> 
> On Sat,  4 Oct 2014 11:37:57 -0400, Yasser Shalabi wrote:
> > Fix for double free bug in tools/perf due to dangling thread_map pointer in perf_evlist struct.
> > Code path excercised when perf stat -C switch is used but not set and is followed by another switch.
> > Example: perf stat -C -e. 
> > Signed-off-by: Yasser Shalabi <yassershalabi@gmail.com>
> >
> > ---
> >  tools/perf/util/evlist.c |    1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
> > index 814e954..09af633 100644
> > --- a/tools/perf/util/evlist.c
> > +++ b/tools/perf/util/evlist.c
> > @@ -845,6 +845,7 @@ int perf_evlist__create_maps(struct perf_evlist *evlist, struct target *target)
> >  
> >  out_delete_threads:
> >  	thread_map__delete(evlist->threads);
> > +	evlist->threads = 0;
> 
> Nitpick - I think NULL is preferred rather than 0.

yeah, I fixed that.
 
> Other than that,
> 
> Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks, applied!
 
> Thanks,
> Namhyung
> 
> 
> >  	return -1;
> >  }
