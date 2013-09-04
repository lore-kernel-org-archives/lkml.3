Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762820Ab3IDObx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 10:31:53 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:44372 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762603Ab3IDObw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 10:31:52 -0400
Date: Wed, 4 Sep 2013 16:31:48 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip v2] sched/cputime: do not scale when utime == 0
Message-ID: <20130904143148.GA11282@gmail.com>
References: <20130902122845.GA2457@swordfish.minsk.epam.com>
 <20130902130744.GB2378@somewhere>
 <20130902135033.GA1686@redhat.com>
 <20130902140015.GB2368@swordfish.minsk.epam.com>
 <20130903084306.GA2694@redhat.com>
 <20130903180912.GA2340@swordfish>
 <20130903183229.GB30757@gmail.com>
 <20130904120857.GB2564@redhat.com>
 <20130904123350.GA9773@gmail.com>
 <20130904131602.GC2564@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130904131602.GC2564@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> scale_stime() silently assumes that stime < rtime, otherwise when
> stime == rtime and both values are big enough (operations on them do
> not fit in 32 bits), the resulting scaling stime can be bigger than
> rtime. In consequence utime = rtime - stime results in negative value.
> 
> User space visible symptoms of the bug are overflowed TIME values on
> ps/top, for example:
> 
> ps aux | grep rcu
> root         8  0.0  0.0      0     0 ?        S    12:42   0:00 [rcuc/0]
> root         9  0.0  0.0      0     0 ?        S    12:42   0:00 [rcub/0]
> root        10 62422329  0.0  0     0 ?        R    12:42 21114581:37 [rcu_preempt]
> root        11  0.1  0.0      0     0 ?        S    12:42   0:02 [rcuop/0]
> root        12 62422329  0.0  0     0 ?        S    12:42 21114581:35 [rcuop/1]
> root        10 62422329  0.0  0     0 ?        R    12:42 21114581:37 [rcu_preempt]
> 
> or overflowed utime values read directly from /proc/$PID/stat
> 
> Reference:
> https://lkml.org/lkml/2013/8/20/259
> 
> Reported-and-tested-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
> v1 -> v2 : describe user visible symptoms of the bug
> 
>  kernel/sched/cputime.c |   19 +++++++++++--------
>  1 files changed, 11 insertions(+), 8 deletions(-)

Applied, thanks!

	Ingo
