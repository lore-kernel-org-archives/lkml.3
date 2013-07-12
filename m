Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933081Ab3GLMtg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 08:49:36 -0400
Received: from mga03.intel.com ([143.182.124.21]:31224 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932951Ab3GLMtf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 08:49:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,652,1367996400"; 
   d="scan'208";a="267409360"
Message-ID: <51DFFCE1.1070203@intel.com>
Date: Fri, 12 Jul 2013 15:56:01 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH V5 09/12] perf: make events stream always parsable
References: <1373548341-24119-1-git-send-email-adrian.hunter@intel.com> <1373548341-24119-10-git-send-email-adrian.hunter@intel.com> <20130712095600.GT25631@dyad.programming.kicks-ass.net>
In-Reply-To: <20130712095600.GT25631@dyad.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/13 12:56, Peter Zijlstra wrote:
> On Thu, Jul 11, 2013 at 04:12:18PM +0300, Adrian Hunter wrote:
>> The event stream is not always parsable because the format of a sample
>> is dependent on the sample_type of the selected event.  When there
>> is more than one selected event and the sample_types are not the
>> same then parsing becomes problematic.  A sample can be matched to its
>> selected event using the ID that is allocated when the event is opened.
>> Unfortunately, to get the ID from the sample means first parsing it.
>>
>> This patch adds a new sample format bit PERF_SAMPLE_IDENTIFER that puts
>> the ID at a fixed position so that the ID can be retrieved without
>> parsing the sample.  For sample events, that is the first position
>> immediately after the header.  For non-sample events, that is the last
>> position.
> 
> There's events where this isn't a possible location; take PERF_RECORD_MMAP for
> instance; the tail is the complete filename.

PERF_RECORD_MMAP falls in the category I have called non-sample events.
Those events are appended with an ID sample.  perf tools parses the ID
sample backwards from header.size.  So the ID is at the last position
relative to header.size

> 
> Why not always insert right after the header?

It is for sample events i.e. PERF_RECORD_SAMPLE

> 
> Also; you forgot to update include/uapi/linux/perf_event.h:enum perf_event_type
> That's the format documentation.
> 

OK

