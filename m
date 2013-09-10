Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355Ab3IJI5Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 04:57:24 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:56336 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081Ab3IJI5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 04:57:22 -0400
X-AuditID: 9c93016f-b7cf0ae00000518f-f1-522edef18347
From: Namhyung Kim <namhyung@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCHv2 00/25] perf tool: Add support for multiple data file storage
References: <1378031796-17892-1-git-send-email-jolsa@redhat.com>
	<20130909111749.GP31370@twins.programming.kicks-ass.net>
Date: Tue, 10 Sep 2013 17:57:20 +0900
In-Reply-To: <20130909111749.GP31370@twins.programming.kicks-ass.net> (Peter
	Zijlstra's message of "Mon, 9 Sep 2013 13:17:49 +0200")
Message-ID: <877geprr4f.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter and Jiri,

On Mon, 9 Sep 2013 13:17:49 +0200, Peter Zijlstra wrote:
> On Sun, Sep 01, 2013 at 12:36:11PM +0200, Jiri Olsa wrote:
>> hi,
>> sending the support for multiple file storage. Initial
>> RFC is here:
>> http://marc.info/?l=linux-kernel&m=137408381902423&w=2
>> 
>> v2 changes:
>>   - reworked perf mmap size setup to be able to get
>>     the mmap size value easily later
>>   - added perf.data read/write test for v2 and v3
>>     for both endianity
>>   - added record '-M time' support
>
> So this 0/n post seems to have forgotten to list the rationale for doing
> all this.. 
>
> The only reason I wanted this is so that each thread can write its own
> data. The current one file thing is an immense bottle-neck for big
> machines.

Per-thread or per-cpu?  In my perf ftrace patchset, I used to per-cpu
data file for this reason.  Do you think per-thread approach is better
than per-cpu one?

Jiri, one of my colleagues asked me about the multiple file support
separated by time while ago.  At that time I just added --time-filter
option to perf report, but it'd better if perf record can support it.
(Unfortunately the patch seems to buried in the list).

Anyway, as Peter said, please consider per-thread or per-cpu multiple
file support with your series.  It will help further developments.

Thanks,
Namhyung
