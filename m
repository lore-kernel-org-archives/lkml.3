Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966816AbaFTKrO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 06:47:14 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:32777 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S966593AbaFTKrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 06:47:12 -0400
Message-Id: <20140620104518.722157733@goodmis.org>
User-Agent: quilt/0.63-1
Date: Fri, 20 Jun 2014 06:45:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [for-next][PATCH v2 0/3] tracing: Fixes to syscall tracing
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't like to do this but I rebased my for-next branch to have
the first (for stable) patch not break other archs. This set passed my
cross compile test as well as my normal tests.

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: 0f6af1fe54b371ab6dfc05d963c0356a43c83226


Oleg Nesterov (3):
      tracing: Fix syscall_*regfunc() vs copy_process() race
      tracing: Change syscall_*regfunc() to check PF_KTHREAD and use for_each_process_thread()
      tracing: syscall_regfunc() should not skip kernel threads

----
 include/trace/syscall.h | 15 +++++++++++++++
 kernel/fork.c           |  2 ++
 kernel/tracepoint.c     | 26 +++++++++++---------------
 3 files changed, 28 insertions(+), 15 deletions(-)
