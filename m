Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935068Ab3DOW7c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 18:59:32 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:44701 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934768Ab3DOW7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 18:59:31 -0400
Date: Tue, 16 Apr 2013 00:59:27 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Paul Mundt <lethal@linux-sh.org>, Prasad <prasad@linux.vnet.ibm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] ptrace: Revert "Prepare to fix racy accesses on task
 breakpoints"
Message-ID: <20130415225926.GD17561@somewhere.redhat.com>
References: <20130414160501.GA7612@redhat.com>
 <20130414160541.GA7660@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130414160541.GA7660@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 14, 2013 at 06:05:41PM +0200, Oleg Nesterov wrote:
> This reverts commit bf26c018490c2fce7fe9b629083b96ce0e6ad019.
> 
> The patch was fine but we can no longer race with SIGKILL after
> 9899d11f "ptrace: ensure arch_ptrace/ptrace_request can never race
> with SIGKILL", the __TASK_TRACED tracee can't be woken up and
> ->ptrace_bps[] can't go away.
> 
> Now that ptrace_get_breakpoints/ptrace_put_breakpoints have no
> callers, we can kill them and remove task->ptrace_bp_refcnt.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

Thanks a lot!
