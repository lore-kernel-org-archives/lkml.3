Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751136AbaABK6X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 05:58:23 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:37224 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbaABK6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 05:58:22 -0500
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 0/5] perf tools: get --list-cmds for subcommands
Date: Thu,  2 Jan 2014 16:28:45 +0530
Message-Id: <1388660330-16781-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.5.2.227.g53f3478
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo et al,

In <20131216131628.GA2368@infradead.org>, Arnaldo Carvalho de Melo wrote:
> Don't do all those things open coded, introduce functions to print,
> concat, etc.
>
> The best thing tho, since we have all those sub sub commands in things
> like 'perf kvm', 'perf bench', etc, we could have some
> parse_options_subcmd, and make the parse options machinery aware of
> this, so that it could receive an array of subcmds and when asked for
> --list-cmds, would print that sublist, etc, i.e. make sub cmds a first
> class citizen.
>
> So I'd suggest that you first introduce functions for doing the concat
> to pass to the current infrastructure, so that we have what your patch
> provides, but prettified, then, as follow on patches, you could work on
> making the options parsing machinery aware of sub cmds.
>
> Ah, and try not using fixed sized arrays, or at least verify that space
> is available, i.e. never use strcat, use strncat, better, take a look at
> tools/perf/util/strbuf.h, I guess you can use it to build the string for
> you in a safe way and expanding the buffer as needed, etc.

Okay, so here's a first cut. util.c/ util.h might not have been the
best place to put the functions, but I couldn't think of a better
place at the moment. The series isn't ideal, but I think it's getting
close.

Thoughts?

Cc: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>

Ramkumar Ramachandra (5):
  perf kvm: introduce --list-cmds for use by scripts
  perf kmem: introduce --list-cmds
  perf lock: introduce --list-cmds
  perf mem: introduce --list-cmds
  perf sched: introduce --list-cmds

 tools/perf/builtin-kmem.c     | 15 +++++++++++----
 tools/perf/builtin-kvm.c      | 16 +++++++++++-----
 tools/perf/builtin-lock.c     | 14 ++++++++++----
 tools/perf/builtin-mem.c      | 15 ++++++++++-----
 tools/perf/builtin-sched.c    | 15 +++++++++++----
 tools/perf/perf-completion.sh |  6 +++---
 tools/perf/util/util.c        | 24 ++++++++++++++++++++++++
 tools/perf/util/util.h        |  4 ++++
 8 files changed, 84 insertions(+), 25 deletions(-)

-- 
1.8.5.2.227.g53f3478

