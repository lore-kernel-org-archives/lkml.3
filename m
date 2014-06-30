Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbaF3PC3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 11:02:29 -0400
Received: from mail.kernel.org ([198.145.19.201]:41563 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754130AbaF3PC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 11:02:26 -0400
Date: Mon, 30 Jun 2014 12:02:21 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 05/18] perf tools: Add ordered_events_(get|put) interface
Message-ID: <20140630150221.GB4762@kernel.org>
References: <1403103539-16807-1-git-send-email-jolsa@kernel.org>
 <1403103539-16807-6-git-send-email-jolsa@kernel.org>
 <53ADF8FC.5030604@gmail.com>
 <20140629163933.GA1407@krava.redhat.com>
 <53B043D0.4040009@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53B043D0.4040009@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, Jun 29, 2014 at 10:50:24AM -0600, David Ahern escreveu:
> On 6/29/14, 10:39 AM, Jiri Olsa wrote:
> >On Fri, Jun 27, 2014 at 05:06:36PM -0600, David Ahern wrote:
> >>On 6/18/14, 8:58 AM, Jiri Olsa wrote:
> >>>+static struct ordered_event*
> >>>+ordered_events_get(struct ordered_events_queue *q, u64 timestamp)
> >>>+{
> >>>+	struct ordered_event *new;
> >>>+
> >>>+	new = alloc_event(q);
> >>>+	if (new) {
> >>>+		new->timestamp = timestamp;
> >>>+		queue_event(q, new);
> >>>+	}
> >>>+
> >>>+	return new;
> >>>+}

> >>The _get name does not really correlate with what is happening -- ie.,
> >>allocate a new event and add it to the queue. There is no reference taken
> >>either.

> >ook.. so how about ordered_events_alloc ordered_events_free

ordered_events__new() and ordered_events__delete(), to be consistent
with general naming for constructors and destructors in tools/perf/ :-)

I would also not use "new" as the name of the new instance, as above,
but would rather use 'oe', shortcut for ordered event, or even oevent,
as elsewhere suggested in this thread.

> >>>+static void
> >>>+ordered_event_put(struct ordered_events_queue *q, struct ordered_event *iter)
> >>>+{
> >>>+	list_del(&iter->list);
> >>>+	list_add(&iter->list, &q->cache);
> >>>+	q->nr_events--;
> >>>+}
> >>
> >>Similarly here with the _put. In this case the function is moving the event
> >>from one list to another. And how about something else for the name besides
> >>iter -- oe, or oevent?
> >
> >how about 'event' ?
> 
> Already a heavily used keyword in perf, that's why I was thinking oe or
> oevent -- besides it is a struct ordered_event not an event.

Agreed on all counts.
 
> The bigger thing to me with this patch is the _get/_put names.

Agreed, those are for reference counting.

- Arnaldo
