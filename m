Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621Ab3LLN4b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 08:56:31 -0500
Received: from mga11.intel.com ([192.55.52.93]:14187 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989Ab3LLN4a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 08:56:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,878,1378882800"; 
   d="scan'208";a="448947683"
Message-ID: <52A9C08A.2050500@intel.com>
Date: Thu, 12 Dec 2013 15:56:26 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH v0 13/71] perf tools: Add machine__get_thread_pid()
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com> <1386765443-26966-14-git-send-email-alexander.shishkin@linux.intel.com> <52A8BCCE.9010300@gmail.com>
In-Reply-To: <52A8BCCE.9010300@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/13 21:28, David Ahern wrote:
> On 12/11/13, 5:36 AM, Alexander Shishkin wrote:
>> From: Adrian Hunter <adrian.hunter@intel.com>
>>
>> Add a function to get the pid from the tid.
>>
>> This is needed when using the sched_switch
>> tracepoint to follow object code execution.
>> sched_switch identifies the thread but, to
>> find the process mmaps, we need the process
>> pid.
> 
> Are you looking up the current or next task? If the former why not use
> sample->pid rather than parsing the sched_switch tracepoint?

Next pid unfortunately.

