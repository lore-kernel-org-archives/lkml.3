Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbaG2P00 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 11:26:26 -0400
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:39126
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753842AbaG2P0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 11:26:25 -0400
Date: Tue, 29 Jul 2014 10:26:08 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Tejun Heo <tj@kernel.org>
cc: Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sasha.levin@oracle.com>, akpm@linux-foundation.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, Mike Frysinger <vapier@gentoo.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, hughd@google.com,
        viresh.kumar@linaro.org, hpa@zytor.com, mingo@kernel.org,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: vmstat: On demand vmstat workers V8
In-Reply-To: <20140729151415.GF4791@htj.dyndns.org>
Message-ID: <alpine.DEB.2.11.1407291024300.21390@gentwo.org>
References: <alpine.DEB.2.11.1407100903130.12483@gentwo.org> <53D31101.8000107@oracle.com> <alpine.DEB.2.11.1407281353450.15405@gentwo.org> <20140729075637.GA19379@twins.programming.kicks-ass.net> <20140729120525.GA28366@mtj.dyndns.org> <20140729122303.GA3935@laptop>
 <20140729131226.GS7462@htj.dyndns.org> <alpine.DEB.2.11.1407291009320.21102@gentwo.org> <20140729151415.GF4791@htj.dyndns.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jul 2014, Tejun Heo wrote:

> > mm/vmstat.c already has cpu down hooks. See vmstat_cpuup_callback().
>
> Hmmm, well, then it's something else.  Either a bug in workqueue or in
> the caller.  Given the track record, the latter is more likely.
> e.g. it looks kinda suspicious that the work func is cleared after
> cancel_delayed_work_sync() is called.  What happens if somebody tries

Ok we can clear it before then.

Just looked at the current upstream code. It also does a __this_cpu_read()
in refresh_cpu_stats() without triggering the preemption check. What
changed in -next that made the test trigger now?

