Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935AbaG2POU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 11:14:20 -0400
Received: from mail-qg0-f45.google.com ([209.85.192.45]:64812 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764AbaG2POT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 11:14:19 -0400
Date: Tue, 29 Jul 2014 11:14:15 -0400
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@gentwo.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
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
Message-ID: <20140729151415.GF4791@htj.dyndns.org>
References: <alpine.DEB.2.11.1407100903130.12483@gentwo.org>
 <53D31101.8000107@oracle.com>
 <alpine.DEB.2.11.1407281353450.15405@gentwo.org>
 <20140729075637.GA19379@twins.programming.kicks-ass.net>
 <20140729120525.GA28366@mtj.dyndns.org>
 <20140729122303.GA3935@laptop>
 <20140729131226.GS7462@htj.dyndns.org>
 <alpine.DEB.2.11.1407291009320.21102@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1407291009320.21102@gentwo.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 10:10:11AM -0500, Christoph Lameter wrote:
> On Tue, 29 Jul 2014, Tejun Heo wrote:
> 
> > I agree this can be improved, but at least for now, please add cpu
> > down hooks.  We need them right now and they'll be helpful when later
> > separating out the correctness ones.
> 
> mm/vmstat.c already has cpu down hooks. See vmstat_cpuup_callback().

Hmmm, well, then it's something else.  Either a bug in workqueue or in
the caller.  Given the track record, the latter is more likely.
e.g. it looks kinda suspicious that the work func is cleared after
cancel_delayed_work_sync() is called.  What happens if somebody tries
to schedule it inbetween?

Thanks.

-- 
tejun
