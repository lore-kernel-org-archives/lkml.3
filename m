Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734Ab3DNQJX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 12:09:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752208Ab3DNQIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 12:08:12 -0400
Date: Sun, 14 Apr 2013 18:05:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Paul Mundt <lethal@linux-sh.org>, Prasad <prasad@linux.vnet.ibm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] kill ptrace_{get,put}_breakpoints()
Message-ID: <20130414160501.GA7612@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Kill ptrace_{get,put}_breakpoints and task_struct->ptrace_bp_refcnt,
9899d11f "ptrace: ensure arch_ptrace/ptrace_request can never race
with SIGKILL" made this all unneeded.

Benjamin, Paul, arch_dup_task_struct()->flush_ptrace_hw_breakpoint(src)
on powerpc looks "obviously wrong". Don't we need

	- flush_ptrace_hw_breakpoint(src);
	+ dst->thread->ptrace_bps[0] = NULL;

?

Oleg.

