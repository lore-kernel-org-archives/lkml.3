Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933107AbaFCQ2Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 12:28:24 -0400
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:48641 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932469AbaFCQ2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 12:28:23 -0400
Date: Tue, 3 Jun 2014 11:28:18 -0500 (CDT)
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
In-Reply-To: <20140603160953.GF23860@localhost.localdomain>
Message-ID: <alpine.DEB.2.10.1406031127080.14380@gentwo.org>
References: <alpine.DEB.2.10.1405291453260.2899@gentwo.org> <20140603160953.GF23860@localhost.localdomain>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jun 2014, Frederic Weisbecker wrote:

> So after the cpumask_var_t conversion I have no other concern except
> perhaps that the scan may bring some overhead on workloads that don't
> care about isolation. You might want to make it optional. But I let you
> check that.

Testing so far indicates that typical loads have spurts of kernel usage
which need vmstat but otherwise there are large segments of processing
that do not need the vmstat worker. It seems that this change is generally
helpful.
