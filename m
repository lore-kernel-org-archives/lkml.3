Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876AbaFSB1O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 21:27:14 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:49670 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754686AbaFSB1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 21:27:09 -0400
Date: Wed, 18 Jun 2014 21:27:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Tom Zanussi <tom.zanussi@intel.com>
Subject: Re: [PATCH v2 0/5] Add glob pattern matching support on trigger and
 kprobe-event
Message-ID: <20140618212707.3b6e3172@gandalf.local.home>
In-Reply-To: <20130522021903.4299.85911.stgit@mhiramat-M0-7522>
References: <20130522021903.4299.85911.stgit@mhiramat-M0-7522>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A blast from the past! (I'm cleaning out my inbox).

On Wed, 22 May 2013 11:19:03 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> Hi,
> 
> Here is a series of ftrace/perf updates to support multiple
> event select operation by glob-based wild cards.
> 
> I've ported strglobmatch from perf-tools (with recursive call
> limitation) for this use. It is easier to use (just replacing
> strcmp) but slower than current parser-based matching.
> I don't care about the speed of matching because the all of
> the matching which I've introduced in this series are done
> on slow-path.
> 
> Changes in v2:
>  - Update the comment of patch [2/5] for explaining more
>    detail of the backgroud.
> 
> ---
> 
> Masami Hiramatsu (5):
>       [BUGFIX] tracing: Returns -EBUSY when event_enable_func fails to get module

This is applied.


>       perf: Swap the parameters of strglobmatch
>       lib/string: Add a generic wildcard string matching function
>       tracing/kprobes: Allow user to delete kprobe events by wild cards
>       tracing: Support enable/disable multiple events trigger by wild cards

These don't look to be applied. Looks like this patch series was lost.

Masami, are these still relevant?

-- Steve


> 
> 
>  Documentation/trace/ftrace.txt      |   12 ++-
>  Documentation/trace/kprobetrace.txt |   19 +++--
>  include/linux/string.h              |    8 ++
>  kernel/trace/trace_events.c         |  121 +++++++++++++++++++++++++----------
>  kernel/trace/trace_kprobe.c         |   97 ++++++++++++++++++++--------
>  lib/string.c                        |   91 ++++++++++++++++++++++++++
>  tools/perf/util/parse-events.c      |   14 ++--
>  tools/perf/util/probe-event.c       |    2 -
>  tools/perf/util/strfilter.c         |    2 -
>  tools/perf/util/string.c            |   16 ++---
>  tools/perf/util/util.h              |    4 +
>  11 files changed, 295 insertions(+), 91 deletions(-)
> 

