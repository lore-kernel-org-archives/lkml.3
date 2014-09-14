Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbaINJWF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 05:22:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:41886 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504AbaINJWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 05:22:03 -0400
Date: Sun, 14 Sep 2014 11:22:00 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: riel@redhat.com
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, prarit@redhat.com,
        oleg@redhat.com, sgruszka@redhat.com
Subject: Re: [PATCH -tip 0/2] fix lock inversion in lockless sys_times()
Message-ID: <20140914092200.GQ346@worktop.programming.kicks-ass.net>
References: <1410527535-9814-1-git-send-email-riel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410527535-9814-1-git-send-email-riel@redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 09:12:13AM -0400, riel@redhat.com wrote:
> The sig->stats_lock nests inside the tasklist_lock and the
> sighand->siglock in __exit_signal and wait_task_zombie.
> 
> However, both of those locks can be taken from irq context,
> which means we need to use the interrupt safe variant of
> read_seqbegin_or_lock. This blocks interrupts when the "lock"
> branch is taken (seq is odd), preventing the lock inversion.
> 
> On the first (lockless) pass through the loop, irqs are not
> blocked.
> 
> This fixes the lockdep complaints that Stanislaw reported.
> 

Thanks Rik
