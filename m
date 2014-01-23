Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbaAWTeY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:34:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604AbaAWTeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:34:22 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, eparis@redhat.com, sgrubb@redhat.com,
        akpm@linux-foundation.org, peterz@infradead.org, oleg@redhat.com
Subject: [PATCH 0/7][RFC] pid: changes to support audit
Date: Thu, 23 Jan 2014 14:32:33 -0500
Message-Id: <cover.1390495874.git.rgb@redhat.com>
In-Reply-To: <ae3d74e79649d9e4962d0da030fb4852ddc5b8d1.1387227114.git.rgb@redhat.com>
References: <ae3d74e79649d9e4962d0da030fb4852ddc5b8d1.1387227114.git.rgb@redhat.com>
In-Reply-To: <20131220140417.GE14884@madcap2.tricolour.ca>
References: <20131220140417.GE14884@madcap2.tricolour.ca> <8aa73d2b884439496f87d5f34c12ba9b4b40f7e5.1377032086.git.rgb@redhat.com> <ae3d74e79649d9e4962d0da030fb4852ddc5b8d1.1387227114.git.rgb@redhat.com> <20131217095801.GF21999@twins.programming.kicks-ass.net> <20131220044826.GF14944@madcap2.tricolour.ca> <20131220085846.GA21999@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are a number of patches inspired by ebiederman's container work that were
included by me 2013-08-20 as the patchset:
	RFC: steps to make audit pid namespace-safe

They have been seperated out for the pid maintainer since there are no direct
dependencies from the audit pid namespace patchset with the exception of:
	pid: get pid_t ppid of task in init_pid_ns

Andrew, are you willing to adopt these?

In particular, there is discussion around read-only task_struct::pid here:
	https://lkml.org/lkml/2013/12/16/552

Richard Guy Briggs (7):
  pid: change task_struct::pid to read-only
  compiler: CONST_CAST makes writing const vars easier and obvious
  pid: use the CONST_CAST macro instead to write to const
    task_struct::pid
  pid: modify task_tgid_nr to work without task->tgid.
  pid: rewrite task helper function is_global_init() avoiding task->pid
  pid: mark struct task const in helper functions
  pid: get pid_t ppid of task in init_pid_ns

 arch/x86/kernel/process.c |    2 +-
 fs/exec.c                 |    2 +-
 include/linux/compiler.h  |    8 ++++++
 include/linux/sched.h     |   60 +++++++++++++++++++++++++++++---------------
 kernel/fork.c             |    5 ++-
 kernel/pid.c              |    4 +-
 6 files changed, 54 insertions(+), 27 deletions(-)

