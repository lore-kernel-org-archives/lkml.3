Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751714AbaKKRI3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 12:08:29 -0500
Received: from resqmta-po-03v.sys.comcast.net ([96.114.154.162]:39352 "EHLO
	resqmta-po-03v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751218AbaKKRI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 12:08:27 -0500
Date: Tue, 11 Nov 2014 11:08:23 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
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
In-Reply-To: <20141111153653.GB3216@lerouge>
Message-ID: <alpine.DEB.2.11.1411111107400.6018@gentwo.org>
References: <alpine.DEB.2.11.1410311058500.32582@gentwo.org> <alpine.DEB.2.11.1411012003390.5308@nanos> <alpine.DEB.2.11.1411011646280.7732@gentwo.org> <alpine.DEB.2.11.1411012313320.5308@nanos> <alpine.DEB.2.11.1411061057470.5591@gentwo.org>
 <20141110224306.GC29741@lerouge> <alpine.DEB.2.11.1411110857480.5148@gentwo.org> <20141111153653.GB3216@lerouge>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Nov 2014, Frederic Weisbecker wrote:

> "there" here is the syscall/exception/interrupt entry path. And like I said, updating
> timekeeping from these places is overkill (although we do it in interrupt entry on
> dynticks-idle, but we don't have timekeeping when all system is idle).

Well that is going to extremes I would think. Lets keep one processor
alive so that the rest can be as noise free as possible.

