Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412AbaFSGhE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 02:37:04 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:52678 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272AbaFSGhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 02:37:01 -0400
Message-ID: <53A28505.90406@hitachi.com>
Date: Thu, 19 Jun 2014 15:36:53 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Tom Zanussi <tom.zanussi@intel.com>
Subject: Re: Re: [PATCH v2 0/5] Add glob pattern matching support on trigger
 and kprobe-event
References: <20130522021903.4299.85911.stgit@mhiramat-M0-7522> <20140618212707.3b6e3172@gandalf.local.home>
In-Reply-To: <20140618212707.3b6e3172@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/06/19 10:27), Steven Rostedt wrote:
> 
> A blast from the past! (I'm cleaning out my inbox).
> 
> On Wed, 22 May 2013 11:19:03 +0900
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
>> Hi,
>>
>> Here is a series of ftrace/perf updates to support multiple
>> event select operation by glob-based wild cards.
>>
>> I've ported strglobmatch from perf-tools (with recursive call
>> limitation) for this use. It is easier to use (just replacing
>> strcmp) but slower than current parser-based matching.
>> I don't care about the speed of matching because the all of
>> the matching which I've introduced in this series are done
>> on slow-path.
>>
>> Changes in v2:
>>  - Update the comment of patch [2/5] for explaining more
>>    detail of the backgroud.
>>
>> ---
>>
>> Masami Hiramatsu (5):
>>       [BUGFIX] tracing: Returns -EBUSY when event_enable_func fails to get module
> 
> This is applied.
> 
> 
>>       perf: Swap the parameters of strglobmatch
>>       lib/string: Add a generic wildcard string matching function
>>       tracing/kprobes: Allow user to delete kprobe events by wild cards
>>       tracing: Support enable/disable multiple events trigger by wild cards
> 
> These don't look to be applied. Looks like this patch series was lost.
> 
> Masami, are these still relevant?

These are separated enhancement. Feel free to apply the 1st bugfix patch.
I'll update the series :)

Thank you,

> 
> -- Steve
> 
> 
>>
>>
>>  Documentation/trace/ftrace.txt      |   12 ++-
>>  Documentation/trace/kprobetrace.txt |   19 +++--
>>  include/linux/string.h              |    8 ++
>>  kernel/trace/trace_events.c         |  121 +++++++++++++++++++++++++----------
>>  kernel/trace/trace_kprobe.c         |   97 ++++++++++++++++++++--------
>>  lib/string.c                        |   91 ++++++++++++++++++++++++++
>>  tools/perf/util/parse-events.c      |   14 ++--
>>  tools/perf/util/probe-event.c       |    2 -
>>  tools/perf/util/strfilter.c         |    2 -
>>  tools/perf/util/string.c            |   16 ++---
>>  tools/perf/util/util.h              |    4 +
>>  11 files changed, 295 insertions(+), 91 deletions(-)
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


