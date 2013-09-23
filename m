Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab3IWPKM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 11:10:12 -0400
Received: from a9-46.smtp-out.amazonses.com ([54.240.9.46]:36140 "EHLO
	a9-46.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752655Ab3IWPKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 11:10:09 -0400
Date: Mon, 23 Sep 2013 15:10:07 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Thomas Gleixner <tglx@linutronix.de>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>, Tejun Heo <tj@kernel.org>,
        John Stultz <johnstul@us.ibm.com>, Mike Frysinger <vapier@gentoo.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux-MM <linux-mm@kvack.org>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: RFC vmstat: On demand vmstat threads
In-Reply-To: <alpine.DEB.2.02.1309201930590.4089@ionos.tec.linutronix.de>
Message-ID: <000001414b5ebafe-a82f870f-283a-4210-a1d8-4035e2720c4f-000000@email.amazonses.com>
References: <00000140e9dfd6bd-40db3d4f-c1be-434f-8132-7820f81bb586-000000@email.amazonses.com> <CAOtvUMdfqyg80_9J8AnOaAdahuRYGC-bpemdo_oucDBPguXbVA@mail.gmail.com> <0000014109b8e5db-4b0f577e-c3b4-47fe-b7f2-0e5febbcc948-000000@email.amazonses.com>
 <20130918150659.5091a2c3ca94b99304427ec5@linux-foundation.org> <alpine.DEB.2.02.1309190033440.4089@ionos.tec.linutronix.de> <000001413796641f-017482d3-1194-499b-8f2a-d7686c1ae61f-000000@email.amazonses.com> <alpine.DEB.2.02.1309201238560.4089@ionos.tec.linutronix.de>
 <20130920164201.GB30381@localhost.localdomain> <alpine.DEB.2.02.1309201930590.4089@ionos.tec.linutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.09.23-54.240.9.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Sep 2013, Thomas Gleixner wrote:

> Now when a cpu becomes isolated we stop the callback scheduling on
> that cpu and assign it to the cpu with the smallest NUMA
> distance. So that cpu will process the data for itself and for the
> newly isolated cpu.

That is not possible for many percpu threads since they rely on running on
a specific cpu for optimization purposes. Running on a different processor
makes these threads racy.

What is needed is to be able to switch these things off and on. Something
on a different cpu may monitor if processing on that specific cpu is
needed or not but it cannot perform the vmstat updates.

