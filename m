Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763000Ab3IDPfP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 11:35:15 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:38077 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762986Ab3IDPfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 11:35:13 -0400
Date: Wed, 4 Sep 2013 17:35:08 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, sergey.senozhatsky@gmail.com, bp@alien8.de,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de, sgruszka@redhat.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/urgent] sched/cputime: Do not scale when utime == 0
Message-ID: <20130904153507.GC2308@somewhere>
References: <20130904131602.GC2564@redhat.com>
 <tip-5a8e01f8fa51f5cbce8f37acc050eb2319d12956@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-5a8e01f8fa51f5cbce8f37acc050eb2319d12956@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 04, 2013 at 07:37:22AM -0700, tip-bot for Stanislaw Gruszka wrote:
> Commit-ID:  5a8e01f8fa51f5cbce8f37acc050eb2319d12956
> Gitweb:     http://git.kernel.org/tip/5a8e01f8fa51f5cbce8f37acc050eb2319d12956
> Author:     Stanislaw Gruszka <sgruszka@redhat.com>
> AuthorDate: Wed, 4 Sep 2013 15:16:03 +0200
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Wed, 4 Sep 2013 16:31:25 +0200
> 
> sched/cputime: Do not scale when utime == 0
> 
> scale_stime() silently assumes that stime < rtime, otherwise
> when stime == rtime and both values are big enough (operations
> on them do not fit in 32 bits), the resulting scaling stime can
> be bigger than rtime. In consequence utime = rtime - stime
> results in negative value.
> 
> User space visible symptoms of the bug are overflowed TIME
> values on ps/top, for example:
> 
>  $ ps aux | grep rcu
>  root         8  0.0  0.0      0     0 ?        S    12:42   0:00 [rcuc/0]
>  root         9  0.0  0.0      0     0 ?        S    12:42   0:00 [rcub/0]
>  root        10 62422329  0.0  0     0 ?        R    12:42 21114581:37 [rcu_preempt]
>  root        11  0.1  0.0      0     0 ?        S    12:42   0:02 [rcuop/0]
>  root        12 62422329  0.0  0     0 ?        S    12:42 21114581:35 [rcuop/1]
>  root        10 62422329  0.0  0     0 ?        R    12:42 21114581:37 [rcu_preempt]
> 
> or overflowed utime values read directly from /proc/$PID/stat
> 
> Reference:
> 
>   https://lkml.org/lkml/2013/8/20/259
> 
> Reported-and-tested-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> Cc: stable@vger.kernel.org
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Link: http://lkml.kernel.org/r/20130904131602.GC2564@redhat.com
> Signed-off-by: Ingo Molnar <mingo@kernel.org>

Thanks a lot guys!
