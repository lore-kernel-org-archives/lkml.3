Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032Ab3FNHUk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 03:20:40 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:50906 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514Ab3FNHUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 03:20:39 -0400
Date: Fri, 14 Jun 2013 09:20:34 +0200
From: Robert Richter <rric@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH v2 03/14] perf: Add persistent event facilities
Message-ID: <20130614072034.GS12218@rric.localhost>
References: <1370968960-22527-1-git-send-email-rric@kernel.org>
 <1370968960-22527-4-git-send-email-rric@kernel.org>
 <87ehc530b2.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ehc530b2.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.06.13 11:15:13, Namhyung Kim wrote:
> > +int perf_get_persistent_event_fd(unsigned cpu, struct perf_event_attr *attr)
> > +{
> > +   struct pers_event_desc *desc;
> > +
> > +   if (cpu >= (unsigned)nr_cpu_ids)
> > +           return -EINVAL;  
> > +
> > +   list_for_each_entry(desc, &per_cpu(pers_events, cpu), plist)
> > +           if (desc->attr->config == attr->config)
> > +                   return __alloc_persistent_event_fd(desc);
> > +
>
> So it only supports tracepoint events.  Don't we need to add other types
> of event?

We have choosen tracepoints as initial implementation since they are
our first use case and its specifiers are unique already.

So this is for the initial implementation only. We can easily
implement support for other event types later. The only thing we need
to implement for this are unique identifiers for each persistent
event. Since all events are described in sysfs this change can be done
later without changing ABI or breaking userland.

The support for all event types is definitely on our list. We need
this also for a later implemention of registering all system wide
events as persistent events. This allows sharing events between
processes and is one of Ingos use cases to enable persistent events at
runtime.

-Robert
