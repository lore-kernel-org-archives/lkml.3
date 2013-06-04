Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500Ab3FDJnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 05:43:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48490 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388Ab3FDJni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 05:43:38 -0400
Date: Tue, 4 Jun 2013 11:19:21 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Robert Richter <rric@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@calxeda.com>
Subject: Re: [PATCH 16/16] perf, persistent: Allow multiple users for an event
Message-ID: <20130604091921.GC1103@krava.brq.redhat.com>
References: <1369990056-10310-1-git-send-email-rric@kernel.org>
 <1369990056-10310-17-git-send-email-rric@kernel.org>
 <20130603134925.GA13548@krava.brq.redhat.com>
 <20130604082042.GB23640@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130604082042.GB23640@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 04, 2013 at 10:20:42AM +0200, Borislav Petkov wrote:
> On Mon, Jun 03, 2013 at 03:49:25PM +0200, Jiri Olsa wrote:
> > maybe check for valid cpu, since perf_get_persistent_event_fd is
> > called directly from syscall allowing anything in cpu
> 
> That should be fine - we're traversing a per-cpu list of events there.

hum, can't see it:

perf SYSCALL:
...
	return perf_get_persistent_event_fd(cpu, &attr);

...
int perf_get_persistent_event_fd(unsigned cpu, struct perf_event_attr *attr)
{
        struct pers_event_desc *desc;
        struct perf_event *event;
        int event_fd = -ENODEV;

        mutex_lock(&per_cpu(pers_events_lock, cpu));
...

'cpu' did not pass ay check here..

jirka
