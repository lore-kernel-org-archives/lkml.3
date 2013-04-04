Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250Ab3DDJKF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 05:10:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756857Ab3DDJKB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 05:10:01 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, hpa@zytor.com,
        rostedt@goodmis.org, akpm@linux-foundation.org, tglx@linutronix.de,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH -tip 0/4] do not make cputime scaling in kernel
Date: Thu,  4 Apr 2013 11:10:31 +0200
Message-Id: <1365066635-2959-1-git-send-email-sgruszka@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series removes cputime scaling from kernel. It can be easily
done in user space using floating point if we provide sum_exec_runtime,
what patches 2/4 and 3/4 do. I have procps patch which utilize that:

http://people.redhat.com/sgruszka/procps-use-sum_exec_runtime.patch

I will post it, if this patch set will be queued.

Change affect also getrusage() and times() syscals, but I don't think
kernel give guarantees about utime/stime precision, in a matter of fact
before commit b27f03d4bdc145a09fb7b0c0e004b29f1ee555fa, we do not
perform any scaling and we provided raw cputime values to user space.

Providing sum_exec_runtime via proc is done against malware that utilize
lot of cpu time but hide itself from top program.

This affect kernels not compiled with CONFIG_VIRT_CPU_ACCOUNTING_{GEN,NATIVE},
if user choose to compile kernel with some of those options, he/she will
have more precise cputime accounting, what is documented in Kconfig.

