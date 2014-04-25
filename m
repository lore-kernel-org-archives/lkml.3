Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888AbaDYLRb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 07:17:31 -0400
Received: from forward-corp1f.mail.yandex.net ([95.108.130.40]:38605 "EHLO
	forward-corp1f.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752000AbaDYLR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 07:17:29 -0400
X-Greylist: delayed 314 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Apr 2014 07:17:29 EDT
From: Roman Gushchin <klamm@yandex-team.ru>
To: Kirill Tkhai <tkhai@yandex.ru>, Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
        Artyom Tarasenko <atar4qemu@gmail.com>
In-Reply-To: <968281398370612@web21g.yandex.ru>
References: <36851398363372@webcorp2g.yandex-team.ru> <20140424185858.GB26782@laptop.programming.kicks-ass.net> <968281398370612@web21g.yandex.ru>
Subject: Re: Real-time scheduling policies and hyper-threading
MIME-Version: 1.0
Message-Id: <9501398424331@webcorp1f.yandex-team.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Fri, 25 Apr 2014 15:12:11 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

25.04.2014, 00:16, "Kirill Tkhai" <tkhai@yandex.ru>:
> 24.04.2014, 22:59, "Peter Zijlstra" <peterz@infradead.org>:
>
> [snip]
>
>>> ššDoes anyone use rt-scheduler for runtime-like cpu-bound tasks?
>> šSo in general cpu bound tasks in the RT classes (FIFO/RR/DEADLINE) are
>> šbad and can make the system go funny.
>>
>> šFor general system health it is important that various system tasks
>> š(kthreads usually) can run. Many of these kthreads run at !rt prios, and
>> šby having cpu bound tasks in rt prios they don't get to run.
>
> One more word to this. I had such expirience on 2.6.33 kernel with RT patch
> and weak hardware (sparc32).
>
> Networking was actively used and application did not use any IO operations.
>
> User needs to set all RT priorities by himself. It's necessary to set RT
> priorities at least for softirqs and rcus. RT bandwidth must be switched
> off.

I disable RT bandwidth sharing and change rt_period/rt_runtime to 1/100 ms
respectively.

Thanks,
Roman
