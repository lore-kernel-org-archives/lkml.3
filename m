Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933572AbaE3Nwt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 09:52:49 -0400
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:35792 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932299AbaE3Nwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 09:52:47 -0400
Date: Fri, 30 May 2014 08:52:42 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        John Stultz <johnstul@us.ibm.com>, Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, hughd@google.com,
        viresh.kumar@linaro.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, Mike Frysinger <vapier@gentoo.org>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH] vmstat: on demand updates from differentials V7
In-Reply-To: <20140530000610.GB25555@localhost.localdomain>
Message-ID: <alpine.DEB.2.10.1405300851490.8240@gentwo.org>
References: <alpine.DEB.2.10.1405291453260.2899@gentwo.org> <20140530000610.GB25555@localhost.localdomain>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 May 2014, Frederic Weisbecker wrote:

> > +	cpu_stat_off = kmalloc(cpumask_size(), GFP_KERNEL);
> > +	cpumask_copy(cpu_stat_off, cpu_online_mask);
>
> Actually looks like you can as well remove that cpumask and use
> cpu_online_mask directly.

That would mean I would offline cpus that do not need the
vmstat worker?
