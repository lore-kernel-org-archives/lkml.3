Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbaBTIy1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 03:54:27 -0500
Received: from merlin.infradead.org ([205.233.59.134]:53769 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527AbaBTIy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 03:54:26 -0500
Date: Thu, 20 Feb 2014 09:54:18 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Adrian Hunter <adrian.hunter@intel.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: perf test failure on 3.14rc3
Message-ID: <20140220085418.GM6835@laptop.programming.kicks-ass.net>
References: <20140220033142.GA7687@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140220033142.GA7687@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 10:31:42PM -0500, Dave Jones wrote:
>  1: vmlinux symtab matches kallsyms                        : Ok
>  2: detect open syscall event                              : Ok
>  3: detect open syscall event on all cpus                  : Ok
>  4: read samples using the mmap interface                  : Ok
>  5: parse events tests                                     :  Warning: function __le16_to_cpup not defined
>   Warning: function __le16_to_cpup not defined
>   Warning: function __le16_to_cpup not defined
>   Warning: bad op token {
>   Warning: bad op token {
>   Warning: bad op token {
>   Warning: bad op token {
>   Warning: function is_writable_pte not defined
>   Warning: function scsi_trace_parse_cdb not defined
>   Warning: function scsi_trace_parse_cdb not defined
>   Warning: function scsi_trace_parse_cdb not defined
>   Warning: function scsi_trace_parse_cdb not defined
>   Warning: unknown op '->'
>   Warning: function jiffies_to_msecs not defined
>   Warning: function jiffies_to_msecs not defined
>   Warning: unknown op '{'
>   Warning: unknown op '{'
>  Ok
>  6: x86 rdpmc test                                         : Ok
>  7: Validate PERF_RECORD_* events & perf_sample fields     : Ok
>  8: Test perf pmu format parsing                           : Ok
>  9: Test dso data interface                                : Ok
> 10: roundtrip evsel->name check                            : Ok
> 11: Check parsing of sched tracepoints fields              : Ok
> 12: Generate and check syscalls:sys_enter_open event fields: Ok
> 13: struct perf_event_attr setup                           : Ok
> 14: Test matching and linking multiple hists               : Ok
> 15: Try 'use perf' in python, checking link problems       : FAILED!
> 16: Test breakpoint overflow signal handler                : Ok
> 17: Test breakpoint overflow sampling                      : Ok
> 18: Test number of exit event of a simple workload         : Ok
> 19: Test software clock events have valid period values    : Ok
> 20: Test converting perf time to TSC                       : Ok
> 21: Test object code reading                               : FAILED!
> 22: Test sample parsing                                    : Ok
> 23: Test using a dummy software event to keep tracking     : Ok
> 24: Test parsing with no sample_id_all bit set             : Ok
> 
> 
> I see '5' failing in similar ways in 3.13 too, so it's been broken
> for a while.

We'll have to ask acme and jolsa, I'm sure I've never looked at that
before.

> Is 21 due to CONFIG_RANDOMIZE_BASE perhaps ?
> Might that also explain why perf top isn't showing me kernel
> function names any more ?

There were some KASLR fails, but I thought most of those were cured, I
think Adrian was involved.
