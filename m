Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbaF2Qjw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 12:39:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34877 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558AbaF2Qjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 12:39:51 -0400
Date: Sun, 29 Jun 2014 18:39:33 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 05/18] perf tools: Add ordered_events_(get|put) interface
Message-ID: <20140629163933.GA1407@krava.redhat.com>
References: <1403103539-16807-1-git-send-email-jolsa@kernel.org>
 <1403103539-16807-6-git-send-email-jolsa@kernel.org>
 <53ADF8FC.5030604@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53ADF8FC.5030604@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 05:06:36PM -0600, David Ahern wrote:
> On 6/18/14, 8:58 AM, Jiri Olsa wrote:
> >
> >+static struct ordered_event*
> >+ordered_events_get(struct ordered_events_queue *q, u64 timestamp)
> >+{
> >+	struct ordered_event *new;
> >+
> >+	new = alloc_event(q);
> >+	if (new) {
> >+		new->timestamp = timestamp;
> >+		queue_event(q, new);
> >+	}
> >+
> >+	return new;
> >+}
> 
> The _get name does not really correlate with what is happening -- ie.,
> allocate a new event and add it to the queue. There is no reference taken
> either.

ook.. so how about ordered_events_alloc ordered_events_free

> 
> >+
> >+static void
> >+ordered_event_put(struct ordered_events_queue *q, struct ordered_event *iter)
> >+{
> >+	list_del(&iter->list);
> >+	list_add(&iter->list, &q->cache);
> >+	q->nr_events--;
> >+}
> 
> Similarly here with the _put. In this case the function is moving the event
> from one list to another. And how about something else for the name besides
> iter -- oe, or oevent?

how about 'event' ?

jirka
