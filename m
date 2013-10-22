Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab3JVHgN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 03:36:13 -0400
Received: from mga14.intel.com ([143.182.124.37]:29895 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753385Ab3JVHgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 03:36:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="378142477"
Message-ID: <52662AC2.6070303@intel.com>
Date: Tue, 22 Oct 2013 10:35:30 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: David Ahern <dsahern@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 07/19] perf script: Set up output options for in-stream
 attributes
References: <1382099356-4918-1-git-send-email-adrian.hunter@intel.com> <1382099356-4918-8-git-send-email-adrian.hunter@intel.com> <526137E5.3050803@gmail.com> <20131018143206.GB4320@ghostprotocols.net>
In-Reply-To: <20131018143206.GB4320@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/10/13 17:32, Arnaldo Carvalho de Melo wrote:
> Em Fri, Oct 18, 2013 at 07:30:13AM -0600, David Ahern escreveu:
>> On 10/18/13 6:29 AM, Adrian Hunter wrote:
> 
>>> Attributes (struct perf_event_attr) are recorded separately in the perf.data
>>> file.  perf script uses them to set up output options.  However attributes
>>> can also be in the event stream, for example when the input is a pipe (i.e.
>>> live mode).  This patch makes perf script process in-stream attributes in
>>> the same way as on-file attributes.
>  
>> You have multiple changes in this patch -- expanding attribute
>> processing to set output options per the description above and you
>> are also making perf_script a stack variable. The latter should be a
>> separate patch.
> 
> Agreed, and this conversion of struct perf_script to be a stack variable is
> nice (killing globals, a favourite pastime, yeah!), I like it, but in the past
> one such conversion showed something nasty that made several people stare at
> the build seeing builtin-sched.o take ages to build...

Fixed in V2

> 
> Please consider testing before/after that specific stack move:
> 
> commit f36f83f947ede547833e462696893f866df77324
> Author: Namhyung Kim <namhyung.kim@lge.com>
> Date:   Tue Jun 4 14:46:19 2013 +0900
> 
>     perf sched: Move struct perf_sched definition out of cmd_sched()
>     
>     For some reason it consumed quite amount of compile time when declared
>     as local variable, and it disappeared when moved out of the function.
>     Moving other variables/tables didn't help.
>     
>     On my system this single-file-change build time reduced from 11s to 3s.
> 
> 

