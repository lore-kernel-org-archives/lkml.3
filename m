Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab3IJGP1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 02:15:27 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:33632 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab3IJGP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 02:15:26 -0400
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <00000140e9dfd6bd-40db3d4f-c1be-434f-8132-7820f81bb586-000000@email.amazonses.com>
References: <00000140e9dfd6bd-40db3d4f-c1be-434f-8132-7820f81bb586-000000@email.amazonses.com>
Date: Tue, 10 Sep 2013 09:15:24 +0300
Message-ID: <CAOtvUMdfqyg80_9J8AnOaAdahuRYGC-bpemdo_oucDBPguXbVA@mail.gmail.com>
Subject: Re: RFC vmstat: On demand vmstat threads
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        John Stultz <johnstul@us.ibm.com>, Mike Frysinger <vapier@gentoo.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux-MM <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 4, 2013 at 7:48 PM, Christoph Lameter <cl@linux.com> wrote:
>
> vmstat threads are used for folding counter differentials into the
> zone, per node and global counters at certain time intervals.
>
> They currently run at defined intervals on all processors which will
> cause some holdoff for processors that need minimal intrusion by the
> OS.
>
> This patch creates a vmstat sheperd task that monitors the
> per cpu differentials on all processors. If there are differentials
> on a processor then a vmstat thread local to the processors with
> the differentials is created. That process will then start
> folding the diffs in regular intervals. Should the vmstat
> process find that there is no work to be done then it will
> terminate itself and make the sheperd task monitor the differentials
> again.
>

I wasn't happy with the results of my own attempt to accomplish the same and I
like this much better. So, for what it's worth -

Reviewed-by: Gilad Ben-Yossef <gilad@benyossef.com>

Thanks,
Gilad


-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
