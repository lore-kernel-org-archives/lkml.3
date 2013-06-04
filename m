Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab3FDJhi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 05:37:38 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57566 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752566Ab3FDJff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 05:35:35 -0400
Date: Tue, 4 Jun 2013 11:35:22 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Robert Richter <rric@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@calxeda.com>
Subject: Re: [PATCH 16/16] perf, persistent: Allow multiple users for an event
Message-ID: <20130604093522.GD23640@pd.tnic>
References: <1369990056-10310-1-git-send-email-rric@kernel.org>
 <1369990056-10310-17-git-send-email-rric@kernel.org>
 <20130603134925.GA13548@krava.brq.redhat.com>
 <20130604082042.GB23640@pd.tnic>
 <20130604091921.GC1103@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130604091921.GC1103@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 04, 2013 at 11:19:21AM +0200, Jiri Olsa wrote:
> hum, can't see it:
> 
> perf SYSCALL:
> ...
> 	return perf_get_persistent_event_fd(cpu, &attr);
> 
> ...
> int perf_get_persistent_event_fd(unsigned cpu, struct perf_event_attr *attr)
> {
>         struct pers_event_desc *desc;
>         struct perf_event *event;
>         int event_fd = -ENODEV;
> 
>         mutex_lock(&per_cpu(pers_events_lock, cpu));
> ...
> 
> 'cpu' did not pass ay check here..

Oh, I see.

You mean something like

	if (cpu < NR_CPUS && cpu_online(cpu))

?

I guess that should cover your concerns...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
