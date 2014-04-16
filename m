Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161063AbaDPSqL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 14:46:11 -0400
Received: from one.firstfloor.org ([193.170.194.197]:32772 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756464AbaDPSqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 14:46:08 -0400
Date: Wed, 16 Apr 2014 20:46:06 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, jolsa@redhat.com, acme@infradead.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] perf, tools: Support spark lines in perf stat v2
Message-ID: <20140416184606.GI22728@two.firstfloor.org>
References: <1397491771-19473-1-git-send-email-andi@firstfloor.org>
 <87wqerrtfs.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wqerrtfs.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +void print_stat_spark(FILE *f, struct stats *stat)
> > +{
> > +	int n = stat->n, len;
> > +
> > +	if (n <= 1)
> > +		return;
> > +	len = n;
> 
> It seems the 'n' is not needed at all - just use 'len'.

This would break ".." for n == NUM_SPARK_VALS
> 
> 
> > +	if (len > NUM_SPARK_VALS)
> > +		len = NUM_SPARK_VALS;
> > +	if (all_the_same(stat->svals, len))
> > +		return;
> 
> Why does it skip printing if all values are same?  I think you wanted to
> skip the "all zero" (uncounted) case, right?

A spark line is meaningless if all values are the same.

-Andi
