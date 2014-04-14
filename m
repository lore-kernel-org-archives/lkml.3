Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436AbaDNRJg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 13:09:36 -0400
Received: from one.firstfloor.org ([193.170.194.197]:53017 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755188AbaDNRJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 13:09:34 -0400
Date: Mon, 14 Apr 2014 19:09:32 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, acme@infradead.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org, eranian@google.com,
        namhyung@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/2] perf, tools: Support spark lines in perf stat
Message-ID: <20140414170931.GF22728@two.firstfloor.org>
References: <1395768699-16060-1-git-send-email-andi@firstfloor.org>
 <1395768699-16060-2-git-send-email-andi@firstfloor.org>
 <20140414085028.GA1433@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140414085028.GA1433@krava.brq.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> fput could go into print_stat_spark

I wanted to keep the function generic, so that it can be easily
used in other places. Adding the space is somewhat specific
to stat.

Also the rest of the stat code has the white space printing 
centralized in the caller too. I suppose makes it easier to change.

> > +	len = n;
> > +	if (len > NUM_SPARK_VALS)
> > +		len = NUM_SPARK_VALS;
> > +	if (all_the_same(stat->svals, len))
> > +		return;
> > +	print_spark(f, stat->svals, len);
> > +	if (stat->n > NUM_SPARK_VALS)
> > +		fputs("..", f);
> > +}
> 
> whats the reason for 'n' in here?  looks like you could do only with 'len'

len is capped to NUM_SPARK_VALS, but the test needs to be on the
uncapped value. Otherwise exactly NUM_SPARK_VALS entries would
get a .. incorrectly.

-Andi
