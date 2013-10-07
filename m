Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287Ab3JGHfl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 03:35:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:6035 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752160Ab3JGHfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 03:35:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1048,1371106800"; 
   d="scan'208";a="406412183"
Message-ID: <525263F3.1000804@intel.com>
Date: Mon, 07 Oct 2013 10:34:11 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: Ramkumar Ramachandra <artagnon@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [BUG] Junk output from perf test
References: <20131007072124.GA1013@krava.brq.redhat.com>
In-Reply-To: <20131007072124.GA1013@krava.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/13 10:21, Jiri Olsa wrote:
> On Mon, Oct 07, 2013 at 11:47:13AM +0530, Ramkumar Ramachandra wrote:
>> Hi,
>>
>> `perf test` doesn't give me a clean run; it seems to be out-of-date. I
>> spent many hours on tracing "parse events tests" with gdb, but
>> preprocessor macros and other complexity make my job very difficult. I
>> haven't determined where the warnings in #5 are coming from exactly,
>> but it seems to be the codepath starting from test__all_tracepoints().
>> Before I spend more hours debugging this, I want to make sure that I'm
>> not wasting my time; can you reproduce this?
> 
> heya,
> yep.. some of them are known to be broken, for some you'd
> need the very last kernel to work properly, let's see..
> 
>>
>> Thanks.
>>
>> -- 8< --
>> $ perf test
>>  1: vmlinux symtab matches kallsyms                        : FAILED!
>>  2: detect open syscall event                              : Ok
>>  3: detect open syscall event on all cpus                  : Ok
>>  4: read samples using the mmap interface                  : Ok
>>  5: parse events tests                                     :  Warning:
>> bad op token {
>>   Warning: bad op token {
>>   Warning: bad op token {
>>   Warning: bad op token {
>>   Warning: function is_writable_pte not defined
>>   Warning: function jiffies_to_msecs not defined
>>   Warning: function jiffies_to_msecs not defined
>>   Warning: function scsi_trace_parse_cdb not defined
>>   Warning: function scsi_trace_parse_cdb not defined
>>   Warning: function scsi_trace_parse_cdb not defined
>>   Warning: function scsi_trace_parse_cdb not defined
>>   Warning: unknown op '{'
>>   Warning: unknown op '{'
>>   Warning: function xen_hypercall_name not defined
>>   Warning: function xen_hypercall_name not defined
>>   Warning: function sizeof not defined
>>   Warning: function sizeof not defined
>>   Warning: function sizeof not defined
>>   Warning: function sizeof not defined
>>   Warning: function sizeof not defined
>>   Warning: function sizeof not defined
>>   Warning: function sizeof not defined
>>   Warning: function sizeof not defined
>>   Warning: function sizeof not defined
>>  Ok
> 
> this one is libtracevent issue, and is fixed by adding
> plugins support posted in here:
>   http://marc.info/?l=linux-kernel&m=137803257921043&w=2
> 
> I need to update and repost it..
> 
> 
>>  6: x86 rdpmc test                                         : Ok
>>  7: Validate PERF_RECORD_* events & perf_sample fields     : Ok
>>  8: Test perf pmu format parsing                           : Ok
>>  9: Test dso data interface                                : Ok
>> 10: roundtrip evsel->name check                            : Ok
>> 11: Check parsing of sched tracepoints fields              : Ok
>> 12: Generate and check syscalls:sys_enter_open event fields: Ok
>> 13: struct perf_event_attr setup                           : Ok
>> 14: Test matching and linking multiple hists               : Ok
>> 15: Try 'use perf' in python, checking link problems       : Ok
>> 16: Test breakpoint overflow signal handler                : Ok
>> 17: Test breakpoint overflow sampling                      : Ok
>> 18: Test number of exit event of a simple workload         : Ok
>> 19: Test software clock events have valid period values    : Ok
>> 20: Test converting perf time to TSC                       : (not supported) Ok
>> 21: Test object code reading                               :[btrfs]
>> with build id 97dc0c1d4aab8c3aba31c776c8c6137ccce5428a not found,
>> continuing without symbols
>>  FAILED!
> 
> not sure why those failed.. Adrian?

Looks like it can't find object code for btrfs.  Please run with the -v
option to see.

> 
>> 22: Test sample parsing                                    : Ok
>> 23: Test using a dummy software event to keep tracking     : (not supported) Ok
> 
> I think you need latest kernel for this one
> 
> thanks,
> jirka
> 
> 

