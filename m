Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247AbaKJWA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 17:00:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52874 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbaKJWAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 17:00:23 -0500
Date: Mon, 10 Nov 2014 22:59:59 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aaron Tomlin <atomlin@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Roland McGrath <roland@hack.frob.com>,
        Sterling Alexander <stalexan@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] exit: reparent zombie fix + cleanups/optimizations
Message-ID: <20141110215959.GA31106@redhat.com>
References: <20141107201424.GA22209@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141107201424.GA22209@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 11/07, Oleg Nesterov wrote:
>
> I tried to optimize the usage of tasklist_lock in exit_notify() paths
> but found the bug which should be fixed first: the EXIT_DEAD setting
> in reparent_leader() can break the task_ppid_nr_ns()-like code and
> ptrace_parent().
>
> I am still thinking about the "right" fix, but whatever we do we need
> to cleanup these users, probably before the fix.

Yes, we need to cleanup these users but lets fix the bug first. See the
changelog in 2/5.

Plus cleanups + initial (micro)optimizations, more to come.

Oleg.

 include/linux/ptrace.h |    2 +-
 kernel/exit.c          |   51 +++++++++++++++++++----------------------------
 kernel/ptrace.c        |   23 ++------------------
 kernel/sched/core.c    |    4 ++-
 4 files changed, 28 insertions(+), 52 deletions(-)

