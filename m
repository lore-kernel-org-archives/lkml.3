Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934935AbaFCQzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 12:55:38 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:46128 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932800AbaFCQzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 12:55:32 -0400
Date: Tue, 3 Jun 2014 18:55:28 +0200
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
Message-ID: <20140603165526.GG23860@localhost.localdomain>
References: <alpine.DEB.2.10.1405291453260.2899@gentwo.org>
 <20140603160953.GF23860@localhost.localdomain>
 <alpine.DEB.2.10.1406031136390.14380@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1406031136390.14380@gentwo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 11:38:02AM -0500, Christoph Lameter wrote:
> On Tue, 3 Jun 2014, Frederic Weisbecker wrote:
> 
> > So after the cpumask_var_t conversion I have no other concern except
> 
> Is there some way to observe which worker threads are queued on which
> processor? I see nothing in /sys/devices/virtual/workqueues (urg should be
> /sys/kernel/workqueues) that shows that?

Yeah you can see that with workqueue tracing events.

Check out /sys/kernel/debug/tracing/events/workqueue/ and more specifically
workqueue_execute_start/ and workqueue_queue_work/.
