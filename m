Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbaCYMIz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 08:08:55 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58877 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272AbaCYMIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 08:08:53 -0400
MIME-Version: 1.0
In-Reply-To: <1395691522-3561-1-git-send-email-zoran.markovic@linaro.org>
References: <1395691522-3561-1-git-send-email-zoran.markovic@linaro.org>
Date: Tue, 25 Mar 2014 17:38:53 +0530
Message-ID: <CAM4v1pPZ_+mw0x8iugha0dagaxXov58gG1je0_iZ2+DmZSW9SQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] sched: proposal for idlestat scheduler
 benchmarking tool
From: Preeti Murthy <preeti.lkml@gmail.com>
To: Zoran Markovic <zoran.markovic@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Rob Landley <rob@landley.net>,
        mingo@redhat.com, Peter Zijlstra <peterz@infradead.org>,
        rostedt@goodmis.org, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Zoran,

I understand that this approach is non-intrusive with the
running workload.

However it would be nice to know how my system is behaving
in terms of power efficiency at a given instance of time and
accordingly I can take action to kill a few applications to save
power, as against knowing how my system did a a minute ago
for example.
   For this I would require a tool which shows me say
every 5seconds how my system is doing. Just like top or
turbostat, which have a time interval for polling and show
results over the polling period. This would enable the
user to take immediate action along with seeing the result
of it from the same tool.

Would it not be possible to parse the /proc stats and the
/sys/devices/cpu/cpu*/cpufreq_or_cpuidle stats to get the
information about the idle and pstates just like you do to
get the topology information but continuously through
periodic polling ? Would this be too intrusive considering
top and such commonly used tools do it this way?

You could also perhaps say that the intention of this
is to verify the  correctness of power aware algorithms
like the power aware scheduler in which case this approach
of collecting the trace after a given duration will be of use.
Having said that, a tool that gives the running power efficiency
image of my system would be more useful in the long run.

Regards
Preeti U Murthy

On Tue, Mar 25, 2014 at 1:35 AM, Zoran Markovic
<zoran.markovic@linaro.org> wrote:
> Conclusions from Energy Aware Scheduling sessions at the latest Kernel Summit
> identified a need for tools that would assess power consumption of the system
> These tools would be used to prove efficiency of scheduler patches by
> comparing power consumption before and after they were applied.
>
> Attached is the proposal for the idlestat tool. The purpose of this patch
> is to solicit feedback on tool's features, possible enhancements, etc.
>
> Source code and sample idlestat report are provided for reference.
>
> Please review and provide comments in anticipation of further development.
>
> Regards, Zoran
>
> Zoran Markovic (2):
>   power: Add idlestat tool for benchmarking energy-aware scheduler
>   sched: Add documentation for idlestat scheduler benchmarking tool
>
>  Documentation/scheduler/idlestat.txt |   79 +++
>  tools/power/idlestat/.gitignore      |   50 ++
>  tools/power/idlestat/Makefile        |   34 +
>  tools/power/idlestat/idlestat.c      | 1229 ++++++++++++++++++++++++++++++++++
>  tools/power/idlestat/idlestat.h      |  106 +++
>  tools/power/idlestat/list.h          |  588 ++++++++++++++++
>  tools/power/idlestat/topology.c      |  503 ++++++++++++++
>  tools/power/idlestat/topology.h      |   77 +++
>  tools/power/idlestat/trace.c         |   87 +++
>  tools/power/idlestat/trace.h         |   43 ++
>  tools/power/idlestat/utils.c         |  115 ++++
>  tools/power/idlestat/utils.h         |   35 +
>  12 files changed, 2946 insertions(+)
>  create mode 100644 Documentation/scheduler/idlestat.txt
>  create mode 100644 tools/power/idlestat/.gitignore
>  create mode 100644 tools/power/idlestat/Makefile
>  create mode 100644 tools/power/idlestat/idlestat.c
>  create mode 100644 tools/power/idlestat/idlestat.h
>  create mode 100644 tools/power/idlestat/list.h
>  create mode 100644 tools/power/idlestat/topology.c
>  create mode 100644 tools/power/idlestat/topology.h
>  create mode 100644 tools/power/idlestat/trace.c
>  create mode 100644 tools/power/idlestat/trace.h
>  create mode 100644 tools/power/idlestat/utils.c
>  create mode 100644 tools/power/idlestat/utils.h
>
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
