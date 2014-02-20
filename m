Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbaBTDcP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 22:32:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25974 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813AbaBTDcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 22:32:14 -0500
Date: Wed, 19 Feb 2014 22:31:42 -0500
From: Dave Jones <davej@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: perf test failure on 3.14rc3
Message-ID: <20140220033142.GA7687@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 1: vmlinux symtab matches kallsyms                        : Ok
 2: detect open syscall event                              : Ok
 3: detect open syscall event on all cpus                  : Ok
 4: read samples using the mmap interface                  : Ok
 5: parse events tests                                     :  Warning: function __le16_to_cpup not defined
  Warning: function __le16_to_cpup not defined
  Warning: function __le16_to_cpup not defined
  Warning: bad op token {
  Warning: bad op token {
  Warning: bad op token {
  Warning: bad op token {
  Warning: function is_writable_pte not defined
  Warning: function scsi_trace_parse_cdb not defined
  Warning: function scsi_trace_parse_cdb not defined
  Warning: function scsi_trace_parse_cdb not defined
  Warning: function scsi_trace_parse_cdb not defined
  Warning: unknown op '->'
  Warning: function jiffies_to_msecs not defined
  Warning: function jiffies_to_msecs not defined
  Warning: unknown op '{'
  Warning: unknown op '{'
 Ok
 6: x86 rdpmc test                                         : Ok
 7: Validate PERF_RECORD_* events & perf_sample fields     : Ok
 8: Test perf pmu format parsing                           : Ok
 9: Test dso data interface                                : Ok
10: roundtrip evsel->name check                            : Ok
11: Check parsing of sched tracepoints fields              : Ok
12: Generate and check syscalls:sys_enter_open event fields: Ok
13: struct perf_event_attr setup                           : Ok
14: Test matching and linking multiple hists               : Ok
15: Try 'use perf' in python, checking link problems       : FAILED!
16: Test breakpoint overflow signal handler                : Ok
17: Test breakpoint overflow sampling                      : Ok
18: Test number of exit event of a simple workload         : Ok
19: Test software clock events have valid period values    : Ok
20: Test converting perf time to TSC                       : Ok
21: Test object code reading                               : FAILED!
22: Test sample parsing                                    : Ok
23: Test using a dummy software event to keep tracking     : Ok
24: Test parsing with no sample_id_all bit set             : Ok


I see '5' failing in similar ways in 3.13 too, so it's been broken
for a while.

Is 21 due to CONFIG_RANDOMIZE_BASE perhaps ?
Might that also explain why perf top isn't showing me kernel
function names any more ?

	Dave

