Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004Ab3FZLJW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 07:09:22 -0400
Received: from mail-qe0-f43.google.com ([209.85.128.43]:32888 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279Ab3FZLJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 07:09:19 -0400
MIME-Version: 1.0
Date: Wed, 26 Jun 2013 19:09:18 +0800
Message-ID: <CAAfg0W5BoDLN_O9PwGTQC-0uFp+ZEgqAH2A9sSbbvOHsHutPkQ@mail.gmail.com>
Subject: 3.10-rc6 "perf test" seems unhappy
From: Andy Green <andy.green@linaro.org>
To: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

Running perf test on 3.10-rc6 gives some unexpected behaviours.

This is on a dual Cortex A9 board with perf userland cross-built from
same tree as the kernel.

root@aa9-eb:~# perf test
 1: vmlinux symtab matches kallsyms                        : FAILED!
 2: detect open syscall event                              : Ok
 3: detect open syscall event on all cpus                  : Ok
 4: read samples using the mmap interface                  : Ok
 5: parse events tests                                     :  Warning:
function sizeof not defined
  Warning: function sizeof not defined
  Warning: function scsi_trace_parse_cdb not defined
  Warning: function scsi_trace_parse_cdb not defined
  Warning: function scsi_trace_parse_cdb not defined
  Warning: function scsi_trace_parse_cdb not defined
  Warning: function jiffies_to_msecs not defined
  Warning: function jiffies_to_msecs not defined
  Warning: bad op token {
  Warning: bad op token {
  Warning: bad op token {
  Warning: Error: expected type 4 but read 0
  Warning: bad op token {
  Warning: Error: expected type 4 but read 0
  Warning: bad op token {
  Warning: bad op token {
  Warning: bad op token {
  Warning: bad op token {
  Warning: bad op token {
  Warning: unknown op '{'
  Warning: unknown op '{'
 Ok
 6: Validate PERF_RECORD_* events & perf_sample fields     : FAILED!
 7: Test perf pmu format parsing                           : Ok
 8: Test dso data interface                                : Ok
 9: roundtrip evsel->name check                            : Ok
10: Check parsing of sched tracepoints fields              : FAILED!
11: Generate and check syscalls:sys_enter_open event fields: Ok
12: struct perf_event_attr setup                           : (omitted) Ok
13: Test matching and linking mutliple hists               : Ok
14: Try 'use perf' in python, checking link problems       : FAILED!
15: Test breakpoint overflow signal handler                : FAILED!
16: Test breakpoint overflow sampling                      : FAILED!
17: Test number of exit event of a simple workload         : FAILED!
18: Test software clock events have valid period values    : Ok


I started tracing the first failure... it stops because it can't find
"_stext" in /proc/kallsyms.  But it is there

root@aa9-eb:~# cat /proc/kallsyms | grep _stext
800081c0 T _stext

test 5 (parse event tests) seems to be badly broken.

The others may be due to missing some config somewhere.

Any ideas what I am (or perf is) doing wrong?

-Andy
