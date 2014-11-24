Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751310AbaKXXnw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 18:43:52 -0500
Received: from lgeamrelo04.lge.com ([156.147.1.127]:64829 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbaKXXnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 18:43:51 -0500
X-Original-SENDERIP: 10.177.222.213
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Tue, 25 Nov 2014 08:46:44 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan@kernel.org>, Dave Hansen <dave@sr71.net>,
        Michal Nazarewicz <mina86@mina86.com>,
        Jungsoo Son <jungsoo.son@lge.com>, Ingo Molnar <mingo@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 5/8] stacktrace: introduce snprint_stack_trace for
 buffer output
Message-ID: <20141124234644.GB7824@js1304-P5Q-DELUXE>
References: <1416816926-7756-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1416816926-7756-6-git-send-email-iamjoonsoo.kim@lge.com>
 <20141124145752.ab64fd85.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141124145752.ab64fd85.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 02:57:52PM -0800, Andrew Morton wrote:
> On Mon, 24 Nov 2014 17:15:23 +0900 Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> 
> > Current stacktrace only have the function for console output.
> > page_owner that will be introduced in following patch needs to print
> > the output of stacktrace into the buffer for our own output format
> > so so new function, snprint_stack_trace(), is needed.
> > 
> > ...
> >
> > +int snprint_stack_trace(char *buf, size_t size,
> > +			struct stack_trace *trace, int spaces)
> > +{
> > +	int i;
> > +	unsigned long ip;
> > +	int generated;
> > +	int total = 0;
> > +
> > +	if (WARN_ON(!trace->entries))
> > +		return 0;
> > +
> > +	for (i = 0; i < trace->nr_entries; i++) {
> > +		ip = trace->entries[i];
> > +		generated = snprintf(buf, size, "%*c[<%p>] %pS\n",
> > +				1 + spaces, ' ', (void *) ip, (void *) ip);
> > +
> > +		total += generated;
> > +
> > +		/* Assume that generated isn't a negative number */
> > +		if (generated >= size) {
> > +			buf += size;
> > +			size = 0;
> 
> Seems strange to keep looping around doing nothing.  Would it be better
> to `break' here?

generated will be added to total in each iteration even if size is 0.
snprint_stack_trace() could return accurate generated string length
by this looping.

Thanks.
