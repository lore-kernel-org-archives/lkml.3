Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364AbaI2SeE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 14:34:04 -0400
Received: from mail.kernel.org ([198.145.19.201]:35961 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602AbaI2SeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 14:34:01 -0400
Date: Mon, 29 Sep 2014 15:33:57 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/2] perf session: Add option to copy events when queueing
Message-ID: <20140929183357.GI3879@kernel.org>
References: <1411060059-23589-1-git-send-email-yarygin@linux.vnet.ibm.com>
 <1411060059-23589-2-git-send-email-yarygin@linux.vnet.ibm.com>
 <20140922070410.GA3108@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140922070410.GA3108@krava.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Sep 22, 2014 at 09:04:10AM +0200, Jiri Olsa escreveu:
> On Thu, Sep 18, 2014 at 09:07:38PM +0400, Alexander Yarygin wrote:
> > +++ b/tools/perf/util/session.c
> > @@ -542,7 +542,13 @@ int perf_session_queue_event(struct perf_session *s, union perf_event *event,
> >  		return -ENOMEM;

> >  	new->file_offset = file_offset;
> > -	new->event = event;

> > +	if (s->copy_on_queue) {
> > +		new->event = malloc(event->header.size);
> > +		memcpy(new->event, event, event->header.size);

> we have memdup, and you need to check for allocation failure

Right.
 
> hum.. how about allocation limits?
 
> Now have report.queue-size to keep track and limit the ordered_events
> memory size. I think we should add this allocation size under this
> limit as well.

Yup.
 
> > +	} else
> > +		new->event = event;
> > +
> 
> also the copy_on_queue flag and the logic above feels more like
> it belongs to 'ordered_events' object to me

Agreed.

- Arnaldo
