Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758817Ab3GRO1b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 10:27:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11144 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756256Ab3GRO13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 10:27:29 -0400
Date: Thu, 18 Jul 2013 16:26:41 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 05/23] perf tests: Add simple session read/write test
Message-ID: <20130718142641.GA4406@krava.brq.redhat.com>
References: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
 <1374083403-14591-6-git-send-email-jolsa@redhat.com>
 <20130717193313.GA5127@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130717193313.GA5127@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 04:33:13PM -0300, Arnaldo Carvalho de Melo wrote:

SNIP

> > +
> > +static union perf_event *get_event_MMAP(void)
> > +{
> > +	static union perf_event event;
> > +	size_t size;
> > +
> > +	size = snprintf(event.mmap.filename, sizeof(event.mmap.filename),
> > +			"krava") + 1;
> > +	size = PERF_ALIGN(size, sizeof(u64));
> > +
> > +	event.header.type = PERF_RECORD_MMAP;
> > +	event.header.misc = PERF_RECORD_MISC_KERNEL;
> > +	event.header.size = sizeof(event.mmap) -
> > +			    (sizeof(event.mmap.filename) - size);
> > +
> > +	event.mmap.pgoff = 10;
> > +	event.mmap.start = 0;
> > +	event.mmap.len   = 10;
> > +	event.mmap.pid   = 123;
> > +
> > +	return &event;
> > +}
> 
> Don't use statics, here perhaps we can have another general purpose
> helper:
> 
> 	void perf_event__init_mmap(union perf_event *event)

well, the thing is that it makes the test simple, I can use it like:

	TEST_ASSERT_VAL("failed to store MMAP event",
			!store_event(fd, get_event_MMAP(), &size));

no need to call extra functions, just get the single event

jirka
