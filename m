Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932363Ab3GBHD7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 03:03:59 -0400
Received: from mga14.intel.com ([143.182.124.37]:64908 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932219Ab3GBHDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 03:03:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,979,1363158000"; 
   d="scan'208";a="262946311"
Message-ID: <51D27CC6.1050209@intel.com>
Date: Tue, 02 Jul 2013 10:09:58 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V2 12/15] perf tools: allow non-matching sample types
References: <1372319707-13892-1-git-send-email-adrian.hunter@intel.com> <1372319707-13892-13-git-send-email-adrian.hunter@intel.com> <51CC6AAF.4030404@gmail.com> <51D14CB6.206@intel.com> <51D1D043.5030509@gmail.com>
In-Reply-To: <51D1D043.5030509@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/13 21:53, David Ahern wrote:
> On 7/1/13 3:32 AM, Adrian Hunter wrote:
>> Snip
>>
>>>
>>> While this works for a combined S/W and tracepoint events session, I do not
>>> like promoting sample types to the minimum compatible level for all events
>>> in the session. perf needs to allow each event to have its own sample_type
>>> and not force a minimal compatibility.
>>
>> Why?  The impact is small. The kernel API is completely unchanged.
> 
> I'd like to see libperf become a stable, usable library - usable by more
> than the perf binary and its builtin commands. I have already done this once
> for a daemon, and it was a PITA to get the specific use functional without
> memory leaks/growth in the libperf part.
> 
> With respect to this specific patch it means appropriate flexibility in the
> data collected for events. ie., each event can have its own sample_type. For
> example if the tracepoint already contains task information TID is not
> needed - and IP may not be wanted either. The code processing the samples
> should not require all events to have some minimum data format - that just
> wastes buffer space.

It would be more compelling to provide a use-case where that "waste"
actually makes any difference.

