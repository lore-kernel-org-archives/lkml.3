Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406Ab3EaMHe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 08:07:34 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:49797 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755722Ab3EaMHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 08:07:24 -0400
Date: Fri, 31 May 2013 14:07:20 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Robert Richter <rric@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@calxeda.com>
Subject: Re: [PATCH 0/4] perf tools: Persistent events, changes for perf tool
 integration
Message-ID: <20130531120720.GA7885@gmail.com>
References: <1369991785-10499-1-git-send-email-rric@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369991785-10499-1-git-send-email-rric@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robert Richter <rric@kernel.org> wrote:

> From: Robert Richter <robert.richter@calxeda.com>
> 
> This patch set contains userland changes necessary for out-of-the-box
> support of persistent events. These patches are follow on patches of
> the kernel patches I sent out today:
> 
>  [PATCH 00/16] perf, persistent: Kernel updates for perf tool integration
> 
> Persistent events are always enabled kernel events. Buffers are mapped
> readonly and multiple users are allowed. The persistent event flag of
> the event attribute must be set to specify such an event.
> 
> The following changes to perf tools are necessary to support
> persistent events. A way is needed to specify sysfs entries to set
> event flags. For this a new syntax 'attr<num>' was added to the event
> parser, see patch #3. We also need to change perf tools to mmap
> persistent event buffers readonly.

Nice progress - one fundamental thing I'm missing from this series is 
actual everyday utility: it would be nice if it was easy to just create a 
persistent event of any sort and then use it.

For example I might want to instrument a global aspect of the system: 
fork()s performed (-e sched:sched_process_fork).

For that I'd like to create a persistent event that just keeps running, 
and to which I can occasionally attach to read-only to see what's going on 
and maybe attach to it read-write to drain the trace entries. I.e. 
basically a global trace buffer. How do I achieve that with this new 
tooling?

Thanks,

	Ingo
