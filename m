Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934358Ab3DOWzm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 18:55:42 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:37823 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932397Ab3DOWzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 18:55:40 -0400
Date: Tue, 16 Apr 2013 00:55:36 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Paul Mundt <lethal@linux-sh.org>, Prasad <prasad@linux.vnet.ibm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] ptrace/x86: Revert "hw_breakpoints: Fix racy access
 to ptrace breakpoints"
Message-ID: <20130415225534.GC17561@somewhere.redhat.com>
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

On Sun, Apr 14, 2013 at 06:05:26PM +0200, Oleg Nesterov wrote:
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

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

Thanks a lot for removing that horrid cruft!
