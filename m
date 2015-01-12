Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbbALJcZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 04:32:25 -0500
Received: from mga11.intel.com ([192.55.52.93]:30564 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595AbbALJcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 04:32:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,742,1413270000"; 
   d="scan'208";a="649736844"
Message-ID: <54B39438.8010701@intel.com>
Date: Mon, 12 Jan 2015 11:30:32 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, markus.t.metzger@intel.com,
        mathieu.poirier@linaro.org, acme@infradead.org
Subject: Re: [PATCH v8 14/14] perf: add ITRACE_START record to indicate that
 tracing has started
References: <1415972627-37514-1-git-send-email-alexander.shishkin@linux.intel.com> <1415972627-37514-15-git-send-email-alexander.shishkin@linux.intel.com> <20150109141248.GO3337@twins.programming.kicks-ass.net> <20150109141318.GR10476@twins.programming.kicks-ass.net>
In-Reply-To: <20150109141318.GR10476@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/15 16:13, Peter Zijlstra wrote:
> On Fri, Jan 09, 2015 at 03:12:48PM +0100, Peter Zijlstra wrote:
>> On Fri, Nov 14, 2014 at 03:43:47PM +0200, Alexander Shishkin wrote:
>>> +++ b/include/uapi/linux/perf_event.h
>>> @@ -750,6 +750,17 @@ enum perf_event_type {
>>>  	 */
>>>  	PERF_RECORD_AUX				= 11,
>>>  
>>> +	/*
>>> +	 * Indicates that instruction trace has started
>>> +	 *
>>> +	 * struct {
>>> +	 *	struct perf_event_header	header;
>>> +	 *	u32				pid;
>>> +	 *	u32				tid;
>>
>> The below function suggests we should have:
>>
>> 		struct sample_id		sample_id;
>>
>>> +	 * };
>>> +	 */
>>> +	PERF_RECORD_ITRACE_START		= 12,
> 
> This also raises the question; why not use PERF_RECORD_COMM?

They mean slightly different things.

PERF_RECORD_COMM means the comm string has been set. We could infer that tid
was the currently running task but we don't at the moment, and it would be a
constraint that should be documented if we are going to rely on it.
Also it might mess up perf tools a little which calls the idle thread
"swapper" but the kernel calls it "swapper/n" on SMP where n is the cpu number.

PERF_RECORD_ITRACE_START just means that pid/tid was the currently running task.

