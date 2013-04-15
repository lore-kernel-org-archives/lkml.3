Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934926Ab3DOJbJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 05:31:09 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:37381 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932601Ab3DOJbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 05:31:07 -0400
Date: Mon, 15 Apr 2013 11:31:03 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Paul Mundt <lethal@linux-sh.org>, Prasad <prasad@linux.vnet.ibm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] ptrace/x86: Revert "hw_breakpoints: Fix racy access
 to ptrace breakpoints"
Message-ID: <20130415093103.GB17715@gmail.com>
References: <20130414160501.GA7612@redhat.com>
 <20130414160526.GA7635@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130414160526.GA7635@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@redhat.com> wrote:

> This reverts commit 87dc669ba25777b67796d7262c569429e58b1ed4.
> 
> The patch was fine but we can no longer race with SIGKILL after
> 9899d11f "ptrace: ensure arch_ptrace/ptrace_request can never race
> with SIGKILL", the __TASK_TRACED tracee can't be woken up and
> ->ptrace_bps[] can't go away.
> 
> The patch only removes ptrace_get_breakpoints/ptrace_put_breakpoints
> and does a couple of "while at it" cleanups, it doesn't remove other
> changes from the reverted commit.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  arch/x86/kernel/ptrace.c |   28 +++++-----------------------
>  1 files changed, 5 insertions(+), 23 deletions(-)

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
