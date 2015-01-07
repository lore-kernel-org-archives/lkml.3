Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833AbbAGHtN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 02:49:13 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:37024 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755165AbbAGHtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 02:49:12 -0500
X-Original-SENDERIP: 10.177.220.203
X-Original-MAILFROM: namhyung@kernel.org
Date: Wed, 7 Jan 2015 16:47:06 +0900
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 5/5] perf diff: Fix -o/--order option behavior
Message-ID: <20150107074706.GF849@sejong>
References: <1419656793-32756-1-git-send-email-namhyung@kernel.org>
 <1419656793-32756-5-git-send-email-namhyung@kernel.org>
 <20150104182656.GC29388@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20150104182656.GC29388@krava.brq.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 04, 2015 at 07:26:56PM +0100, Jiri Olsa wrote:
> On Sat, Dec 27, 2014 at 02:06:33PM +0900, Namhyung Kim wrote:
> 
> SNIP
> 
> > +		return 0;
> > +
> > +	fmt = zalloc(sizeof(*fmt));
> > +	if (fmt == NULL) {
> > +		pr_err("Memory allocation failed\n");
> > +		return -1;
> > +	}
> > +
> > +	fmt->cmp      = hist_entry__cmp_nop;
> > +	fmt->collapse = hist_entry__cmp_nop;
> > +
> > +	switch (compute) {
> > +	case COMPUTE_DELTA:
> > +		fmt->sort = hist_entry__cmp_delta_idx;
> > +		break;
> > +	case COMPUTE_RATIO:
> > +		fmt->sort = hist_entry__cmp_ratio_idx;
> > +		break;
> > +	case COMPUTE_WEIGHTED_DIFF:
> > +		fmt->sort = hist_entry__cmp_wdiff_idx;
> > +		break;
> > +	default:
> > +		BUG_ON(1);
> > +	}
> > +
> > +	list_add(&fmt->sort_list, &perf_hpp__sort_list);
> > +	return 0;
> 
> so the first 'fmt' which gets to sorting is the one for
> data__files[sort_idx] file, that sounds good..
> 
> but as the sorting goes through all the perf_hpp__sort_list list,
> it will hit the 'sort_idx' data again.. should you disable sort
> function for its 'fmt' then?

Do you really think it's needed?

Yes, it'll be called twice but I think it's a relatively rare case as
most entries will be sorted by the sort_idx and baseline columns.

Thanks,
Namhyung
