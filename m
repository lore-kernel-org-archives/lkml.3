Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550AbaAGIrw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 03:47:52 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51680 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbaAGIrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 03:47:51 -0500
Date: Tue, 7 Jan 2014 09:47:34 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Kevin Hilman <khilman@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [LNG] Re: [Query] Ticks happen in pair for NO_HZ_FULL cores ?
Message-ID: <20140107084734.GP30183@twins.programming.kicks-ass.net>
References: <CAKohponch=o3nBKTmakA87OiN=HbgnEwJUL23mGkjQiNoJWjWw@mail.gmail.com>
 <20131211132212.GA7862@localhost.localdomain>
 <CAKohponKxw8F6djaXaw0MEzGRWGTSQ=peiYuTGBCOHE0VaJR5Q@mail.gmail.com>
 <87wqj34eqs.fsf@linaro.org>
 <CAKohpo=Btb8ChRJ4Be9gbDE-nOxSaCVkQ_Qg5g7AVRxOMbXEQQ@mail.gmail.com>
 <87r49al12j.fsf@linaro.org>
 <CAKohpokDBga18BhZm=r+EOoY40=+E7Ndtfooq9rXbqc=wUg2Ng@mail.gmail.com>
 <CAKohpo=bzfnb6aBDRX6AfjVoRquTaboO5wmiHfjb=bD0bAgBcA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpo=bzfnb6aBDRX6AfjVoRquTaboO5wmiHfjb=bD0bAgBcA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 23, 2013 at 01:48:02PM +0530, Viresh Kumar wrote:
> *But wouldn't it make sense if we can tell scheduler that don't queue
> these works on a CPU that is running in NO_HZ_FULL mode?*

No,.. that's the wrong way around.

> Also any suggestions on how to get rid of __prandom_timer events on
> such CPUs?

That looks to be a normal unpinned timer, it should migrate to a 'busy'
cpu once the one its running on it going idle.

ISTR people trying to make that active and also migrating on nohz full
or somesuch, just like the workqueues. Forgot what happened with that;
if it got dropped it should probably be ressurected.
