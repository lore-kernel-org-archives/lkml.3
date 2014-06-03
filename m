Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932904AbaFCPns (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 11:43:48 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:56172 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932172AbaFCPnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 11:43:47 -0400
Date: Tue, 3 Jun 2014 17:43:42 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christoph Lameter <cl@gentwo.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
Message-ID: <20140603154339.GE23860@localhost.localdomain>
References: <alpine.DEB.2.10.1405291453260.2899@gentwo.org>
 <20140530000610.GB25555@localhost.localdomain>
 <alpine.DEB.2.10.1405300851490.8240@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1405300851490.8240@gentwo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 08:52:42AM -0500, Christoph Lameter wrote:
> On Fri, 30 May 2014, Frederic Weisbecker wrote:
> 
> > > +	cpu_stat_off = kmalloc(cpumask_size(), GFP_KERNEL);
> > > +	cpumask_copy(cpu_stat_off, cpu_online_mask);
> >
> > Actually looks like you can as well remove that cpumask and use
> > cpu_online_mask directly.
> 
> That would mean I would offline cpus that do not need the
> vmstat worker?

I missed that works adaptively set or clear cpus from the mask. Nevermind,
just ignore what I said.
