Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab3JGGRz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 02:17:55 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:44037 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698Ab3JGGRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 02:17:54 -0400
MIME-Version: 1.0
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Mon, 7 Oct 2013 11:47:13 +0530
Message-ID: <CALkWK0=JXd5KJ1NAEiKJtTm3EKGqBVPLB=3hqYwfGsp6SRrLyA@mail.gmail.com>
Subject: [BUG] Junk output from perf test
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

`perf test` doesn't give me a clean run; it seems to be out-of-date. I
spent many hours on tracing "parse events tests" with gdb, but
preprocessor macros and other complexity make my job very difficult. I
haven't determined where the warnings in #5 are coming from exactly,
but it seems to be the codepath starting from test__all_tracepoints().
Before I spend more hours debugging this, I want to make sure that I'm
not wasting my time; can you reproduce this?

Thanks.

-- 8< --
$ perf test
 1: vmlinux symtab matches kallsyms                        : FAILED!
 2: detect open syscall event                              : Ok
 3: detect open syscall event on all cpus                  : Ok
 4: read samples using the mmap interface                  : Ok
 5: parse events tests                                     :  Warning:
bad op token {
  Warning: bad op token {
  Warning: bad op token {
  Warning: bad op token {
  Warning: function is_writable_pte not defined
  Warning: function jiffies_to_msecs not defined
  Warning: function jiffies_to_msecs not defined
  Warning: function scsi_trace_parse_cdb not defined
  Warning: function scsi_trace_parse_cdb not defined
  Warning: function scsi_trace_parse_cdb not defined
  Warning: function scsi_trace_parse_cdb not defined
  Warning: unknown op '{'
  Warning: unknown op '{'
  Warning: function xen_hypercall_name not defined
  Warning: function xen_hypercall_name not defined
  Warning: function sizeof not defined
  Warning: function sizeof not defined
  Warning: function sizeof not defined
  Warning: function sizeof not defined
  Warning: function sizeof not defined
  Warning: function sizeof not defined
  Warning: function sizeof not defined
  Warning: function sizeof not defined
  Warning: function sizeof not defined
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
15: Try 'use perf' in python, checking link problems       : Ok
16: Test breakpoint overflow signal handler                : Ok
17: Test breakpoint overflow sampling                      : Ok
18: Test number of exit event of a simple workload         : Ok
19: Test software clock events have valid period values    : Ok
20: Test converting perf time to TSC                       : (not supported) Ok
21: Test object code reading                               :[btrfs]
with build id 97dc0c1d4aab8c3aba31c776c8c6137ccce5428a not found,
continuing without symbols
 FAILED!
22: Test sample parsing                                    : Ok
23: Test using a dummy software event to keep tracking     : (not supported) Ok
24: Test parsing with no sample_id_all bit set             : Ok
