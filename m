Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216Ab3GOMDE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 08:03:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:2338 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755867Ab3GOMDB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 08:03:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,668,1367996400"; 
   d="scan'208";a="370441896"
Message-ID: <51E3E67E.2000302@intel.com>
Date: Mon, 15 Jul 2013 15:09:34 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH V5 09/12] perf: make events stream always parsable
References: <1373548341-24119-1-git-send-email-adrian.hunter@intel.com> <1373548341-24119-10-git-send-email-adrian.hunter@intel.com> <20130712095600.GT25631@dyad.programming.kicks-ass.net> <51DFFCE1.1070203@intel.com> <20130712145515.GI17211@twins.programming.kicks-ass.net> <51E3932C.5000905@intel.com> <CABPqkBSabGq=QQz4fvR3DuY2AyhKS6bYAsRugh4MgApLz0LqpA@mail.gmail.com>
In-Reply-To: <CABPqkBSabGq=QQz4fvR3DuY2AyhKS6bYAsRugh4MgApLz0LqpA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/07/13 14:53, Stephane Eranian wrote:
> On Mon, Jul 15, 2013 at 8:14 AM, Adrian Hunter <adrian.hunter@intel.com> wrote:
>> On 12/07/13 17:55, Peter Zijlstra wrote:
>>> On Fri, Jul 12, 2013 at 03:56:01PM +0300, Adrian Hunter wrote:
>>>>> There's events where this isn't a possible location; take PERF_RECORD_MMAP for
>>>>> instance; the tail is the complete filename.
>>>>
>>>> PERF_RECORD_MMAP falls in the category I have called non-sample events.
>>>> Those events are appended with an ID sample.  perf tools parses the ID
>>>> sample backwards from header.size.  So the ID is at the last position
>>>> relative to header.size
>>>
>>> But why? Why make it different per PERF_RECORD type?
>>
>> There have always been two formats:
>>
>>         1. PERF_RECORD_SAMPLE as defined by perf_output_sample()
>>
>>         2. everything else as defined by __perf_event__output_id_sample()
>>
>> The two formats are not the same, and there is no reason for them to be.
>>
>> PERF_RECORD_SAMPLE is parsed forwards, so the ID is at the first position.
>>
>> ID samples are parsed backwards, so the ID is at the last position (i.e. the
>> first position parsed).
>>
> I am missing something here.
> Why do we need an event ID for RECORD_MMAP records?
> I understand those are requested by events, but do we care which one?
> The information is global to the monitored process and not specific to an event.

The ID sample has, for example, the time, so you still have to parse it -
which means you need the sample_type which means you need the id.

