Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933188AbaEGOXj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 10:23:39 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:38676 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933142AbaEGOXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 10:23:36 -0400
Date: Wed, 7 May 2014 16:23:21 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 3/4 v2] nohz: Fix idle/iowait counts going backwards
Message-ID: <20140507142321.GA2844@laptop.programming.kicks-ass.net>
References: <1399470094-8070-1-git-send-email-dvlasenk@redhat.com>
 <1399470094-8070-3-git-send-email-dvlasenk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399470094-8070-3-git-send-email-dvlasenk@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 03:41:33PM +0200, Denys Vlasenko wrote:
> With this change, "iowait-ness" of every idle period is decided
> at the moment it starts:
> if this CPU's run-queue had tasks waiting on I/O, then this idle
> period's duration will be added to iowait_sleeptime.
> 
> This fixes the bug where iowait and/or idle counts could go backwards,
> but iowait accounting is not precise (it can show more iowait
> that there really is).
> 

NAK on this, the thing going backwards is a symptom of the bug, not an
actual bug itself.
