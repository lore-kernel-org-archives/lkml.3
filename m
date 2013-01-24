Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab3AXT2e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 14:28:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893Ab3AXT2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 14:28:31 -0500
Date: Thu, 24 Jan 2013 16:28:01 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] tools lib traceevent: Handle dynamic array's element
 size properly
Message-ID: <20130124192801.GB14382@infradead.org>
References: <1358772251-4411-1-git-send-email-jolsa@redhat.com>
 <1358829942.21576.49.camel@gandalf.local.home>
 <20130122131646.GB1037@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130122131646.GB1037@krava.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jan 22, 2013 at 02:16:47PM +0100, Jiri Olsa escreveu:
> On Mon, Jan 21, 2013 at 11:45:42PM -0500, Steven Rostedt wrote:
> > This is only used in this function (the field_dynamic_elem_size() is
> > only called here). Can we not add the field->type_dyn, and just use a
> > local variable here. You just need to make sure you free it correctly.
> 
> ook, will send v2

Waiting for this fix, just got 'perf test' crashing on it again :-)

Till then I implemented 'perf test --skip':


[root@sandy ~]# perf test 
 1: vmlinux symtab matches kallsyms                        : Ok
 2: detect open syscall event                              : Ok
 3: detect open syscall event on all cpus                  : Ok
 4: read samples using the mmap interface                  : Ok
 5: parse events tests                                     :  Warning:
bad op token {
  Warning: bad op token {
  Warning: bad op token {
  Warning: bad op token {
  Warning: bad op token {
  Warning: function is_writable_pte not defined
Segmentation fault (core dumped)
[root@sandy ~]# perf test -s 5
 1: vmlinux symtab matches kallsyms                        : Ok
 2: detect open syscall event                              : Ok
 3: detect open syscall event on all cpus                  : Ok
 4: read samples using the mmap interface                  : Ok
 5: parse events tests                                     : Skip (user override)
 6: x86 rdpmc test                                         : Ok
 7: Validate PERF_RECORD_* events & perf_sample fields     : Ok
 8: Test perf pmu format parsing                           : Ok
 9: Test dso data interface                                : Ok
10: roundtrip evsel->name check                            : Ok
11: Check parsing of sched tracepoints fields              : Ok
12: Generate and check syscalls:sys_enter_open event fields: Ok
13: struct perf_event_attr setup                           : Ok
14: Test matching and linking mutliple hists               : Ok
15: Try 'use perf' in python, checking link problems       : Ok
[root@sandy ~]#

:-)

- Arnaldo
