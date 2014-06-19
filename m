Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996AbaFSBmB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 21:42:01 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:29909 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756944AbaFSBl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 21:41:59 -0400
Message-Id: <20140619014036.116976241@goodmis.org>
User-Agent: quilt/0.63-1
Date: Wed, 18 Jun 2014 21:40:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [for-next][PATCH 0/3] [3.16 and stable] tracing: Fixes to syscall tracing
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: 72fa1a896d8ef355e81270667803ceb16a3dd13f


Oleg Nesterov (3):
      tracing: Fix syscall_*regfunc() vs copy_process() race
      tracing: Change syscall_*regfunc() to check PF_KTHREAD and use for_each_process_thread()
      tracing: syscall_regfunc() should not skip kernel threads

----
 include/trace/syscall.h | 15 +++++++++++++++
 kernel/fork.c           |  2 ++
 kernel/tracepoint.c     | 26 +++++++++++---------------
 3 files changed, 28 insertions(+), 15 deletions(-)
