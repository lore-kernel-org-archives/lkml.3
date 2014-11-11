Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751307AbaKKPhA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 10:37:00 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:45257 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbaKKPg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 10:36:59 -0500
Date: Tue, 11 Nov 2014 16:36:55 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>, Tejun Heo <tj@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qti.qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Hugh Dickins <hughd@google.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [NOHZ] Remove scheduler_tick_max_deferment
Message-ID: <20141111153653.GB3216@lerouge>
References: <alpine.DEB.2.11.1410311058500.32582@gentwo.org>
 <alpine.DEB.2.11.1411012003390.5308@nanos>
 <alpine.DEB.2.11.1411011646280.7732@gentwo.org>
 <alpine.DEB.2.11.1411012313320.5308@nanos>
 <alpine.DEB.2.11.1411061057470.5591@gentwo.org>
 <20141110224306.GC29741@lerouge>
 <alpine.DEB.2.11.1411110857480.5148@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1411110857480.5148@gentwo.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 08:58:35AM -0600, Christoph Lameter wrote:
> On Mon, 10 Nov 2014, Frederic Weisbecker wrote:
> 
> > Ok, I confess we moved part of that housekeeping to the syscall/exception/interrupt
> > entry path. We did that for cputime accounting and RCU. And it's possible to
> > even do that for timekeeping. But then the kernel entrypoint is going to be extremely
> > costly. It's worth CPU 0 as a sacrificial lamb.
> 
> Well we can redirect to the scheduler setting the task flag and handle
> costly stuff there if necessary?

"there" here is the syscall/exception/interrupt entry path. And like I said, updating
timekeeping from these places is overkill (although we do it in interrupt entry on
dynticks-idle, but we don't have timekeeping when all system is idle).
