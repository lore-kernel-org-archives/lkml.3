Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751507Ab3LKVOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 16:14:12 -0500
Received: from mail-yh0-f45.google.com ([209.85.213.45]:33984 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab3LKVOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 16:14:07 -0500
Date: Wed, 11 Dec 2013 16:14:00 -0500
From: Tejun Heo <tj@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, Kevin Hilman <khilman@linaro.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        bsd@redhat.com, laijs@cn.fujitsu.com
Subject: Re: [Query] Ticks happen in pair for NO_HZ_FULL cores ?
Message-ID: <20131211211400.GB7683@mtj.dyndns.org>
References: <CAKohponch=o3nBKTmakA87OiN=HbgnEwJUL23mGkjQiNoJWjWw@mail.gmail.com>
 <20131211132212.GA7862@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131211132212.GA7862@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, guys.

On Wed, Dec 11, 2013 at 02:22:14PM +0100, Frederic Weisbecker wrote:
> I fear I don't understand your question. Do you mean why don't we prevent from
> that bdi writeback work to run when we are in full dynticks mode?
> 
> We can't just ignore workqueues and timers callback when they are scheduled
> otherwise the kernel is going to behave randomly.
> 
> OTOH what we can do is to work on these per cpu workqueues and timers and do
> what's necessary to avoid them to fire, as explained in detail there Documentation/kernel-per-CPU-kthreads.txt

Hmmm... some per-cpu workqueues can be turned into unbound ones and
the writeback is one of those.  Currently, this is used for
powersaving on mobile but could also be useful for jitter control.  In
the long term, it could be beneficial to strictly distinguish the
workqueues which really need per-cpu behavior and the ones which are
per-cpu just for optimization.

> There is also the problem of unbound workqueues for which we don't
> have a solution yet. But the idea is that we could tweak their
> affinity from sysfs.

Yes, this is a long term todo item but I'm currently a bit too swamped
to tackle it myself.  cc'ing Lai, who has pretty good knowledge of
workqueue internals, and Bandan, who seemed interested in working on
implementing default attrs.

Thanks.

-- 
tejun
