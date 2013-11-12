Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211Ab3KLQzu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 11:55:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36408 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753728Ab3KLQzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 11:55:47 -0500
Date: Tue, 12 Nov 2013 17:56:43 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        David Rientjes <rientjes@google.com>
Cc: David Laight <David.Laight@ACULAB.COM>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ingo Molnar <mingo@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: oom-kill && frozen()
Message-ID: <20131112165643.GA31278@redhat.com>
References: <1384264396-14550-1-git-send-email-geert@linux-m68k.org> <20131112141314.GQ5056@laptop.programming.kicks-ass.net> <AE90C24D6B3A694183C094C60CF0A2F6026B7405@saturn3.aculab.com> <20131112145243.GU5056@laptop.programming.kicks-ass.net> <20131112162136.GA29065@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131112162136.GA29065@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12, Oleg Nesterov wrote:
>
> I am also wondering if it makes any sense to turn PF_FROZEN into
> TASK_FROZEN, something like (incomplete, probably racy) patch below.
> Note that it actually adds the new state, not the the qualifier.

As for the current usage of PF_FROZEN... David, it seems that
oom_scan_process_thread()->__thaw_task() is dead? Probably this
was fine before, when __thaw_task() cleared the "need to freeze"
condition, iirc it was PF_FROZEN.

But today __thaw_task() can't help, no? the task will simply
schedule() in D state again.

Oleg.

