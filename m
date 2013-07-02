Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab3GBDIE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 23:08:04 -0400
Received: from mout.gmx.net ([212.227.15.15]:58255 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323Ab3GBDIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 23:08:01 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX196rkg6Lwd6Jklik6OWpsADHEsoVtp0Bzou19fNsB
	AFznP93tfvhxEm
Message-ID: <1372734474.7363.66.camel@marge.simpson.net>
Subject: Re: [PATCH] sched: fix cpu utilization account error
From: Mike Galbraith <efault@gmx.de>
To: Xie XiuQi <xiexiuqi@huawei.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        Zhang Hang <bob.zhanghang@huawei.com>,
        Li Bin <huawei.libin@huawei.com>
Date: Tue, 02 Jul 2013 05:07:54 +0200
In-Reply-To: <51D16777.5000703@huawei.com>
References: <51D12570.9070100@huawei.com>
	 <1372664187.7678.45.camel@marge.simpson.net> <51D16777.5000703@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-01 at 19:26 +0800, Xie XiuQi wrote:

> Here is the kthread main logic. Although it's not a good idea, but it does
> exist:

Why not fix this instead?

> while (!kthread_should_stop()) {
> 	/* call schedule every 1 sec */
> 	if (HZ <= jiffies - last) {
> 		last = jiffies;
> 		schedule();
> 	}

Hanging out in the kernel for ages is not cool.  That doesn't mean
something else might not pop up that forces the issue, but to date it
has not, and sacrificing precious fastpath cycles is not attractive.

-Mike

