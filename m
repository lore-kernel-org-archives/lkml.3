Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab3KNRM2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 12:12:28 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:58522 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832Ab3KNRMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 12:12:21 -0500
Date: Thu, 14 Nov 2013 12:20:35 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Peter Zijlstra <peterz@infradead.org>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: perf/tracepoint: another fuzzer generated lockup
In-Reply-To: <20131114152304.GC5364@laptop.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1311141217470.8746@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1311081440440.7281@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1311081504400.7281@vincent-weaver-1.um.maine.edu> <20131108200244.GB14606@localhost.localdomain> <alpine.DEB.2.10.1311081515210.16519@vincent-weaver-1.um.maine.edu>
 <20131108204839.GD14606@localhost.localdomain> <alpine.DEB.2.10.1311081612190.16519@vincent-weaver-1.um.maine.edu> <20131108223657.GF14606@localhost.localdomain> <20131109151014.GN16117@laptop.programming.kicks-ass.net>
 <20131114152304.GC5364@laptop.programming.kicks-ass.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


possibly not an issue with your patch, but found in nearby code:

in perf_trace_init:

        int event_id = p_event->attr.config;

	...

                if (tp_event->event.type == event_id &&


note that "attr.config" is 64-bit but "event_id" is only 32-bit,
so things like 0xffffffff00000018 will map to irq_work_exit.

I'm not sure if your PERM code properly handles this case, I don't have 
time to work through the macro-magic in your patch.

Vince


