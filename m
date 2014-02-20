Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386AbaBTQY0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 11:24:26 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:27626 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564AbaBTQYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 11:24:25 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-43-53062c36031d
From: Alexey Perevalov <a.perevalov@samsung.com>
To: linux-kernel@vger.kernel.org, tglx@linutronix.de, john.stultz@linaro.org
Cc: Alexey Perevalov <a.perevalov@samsung.com>, anton@enomsg.org,
        kyungmin.park@samsung.com, cw00.choi@samsung.com,
        akpm@linux-foundation.org
Subject: [PATCH v4 0/6] Deferrable timers support for hrtimers/timerfd API
Date: Thu, 20 Feb 2014 20:23:39 +0400
Message-id: <1392913425-29369-1-git-send-email-a.perevalov@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMJMWRmVeSWpSXmKPExsVy+t/xa7pmOmzBBlM6FSzm3j3PYjFn/Ro2
	i4NbNS2uf3nOanHmt67F2aY37BaXd81hs9i8aSqzA4fHhP5PjB53ru1h83h37hy7x4kZv1k8
	+rasYvT4vEkugC2KyyYlNSezLLVI3y6BK+PIdJuCuTwVPTdfMTcwPuDsYuTkkBAwkbi1fRoj
	hC0mceHeejYQW0hgKaPE8Qf1XYxcQHYPk8Tj85+BEhwcbAIGEvvu2YLUiAj4SOya+JEJpIZZ
	oJ9R4sybBWCDhAW8JDbc28QMYrMIqEo0tSxjB7F5BdwlXnb9ApsjIaAgMWeSzQRG7gWMDKsY
	RVNLkwuKk9JzjfSKE3OLS/PS9ZLzczcxQgLm6w7GpcesDjEKcDAq8fCelGILFmJNLCuuzD3E
	KMHBrCTC664CFOJNSaysSi3Kjy8qzUktPsTIxMEp1cC4u9fK4mD8gyl/p5oJfDBn/Hpkkt5l
	d30H5qkdxtsUXPy0HQ98dMjWWXe2d0av0/MZdrvKM94uPXmC1TWjbInRoV7ekyu/F3csjl65
	LG/KH7us12K6VSv2xGUtuHMiZcsFBW0XY42nz80O9TBc2NH4w8HvMN+d0BWszGJanoYnb2pr
	rPkp0vpZiaU4I9FQi7moOBEAFcpOZvYBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch set introduces deferrable functionality for hrtimers and add ability
to use it from timerfd_create syscall.
It means user-space processes are able to not wake up the system from cpuidle state
in case of periodic job. And it's the main goal of this patch set for us and for team
sent such patch set before.
I hope it will find users in kernel space too, cause it could avoid timer_list drawbacks,
such as worst case when many,many timers are gonna to be expired.


Kernel already has deferrable timer funcionality based on timer_list. But deferrable
functionality inside hrtimers makes timerfd implemenation trivial for such case.

It's based on github.com/torvalds/linux.git git repository on top of
e95003c3f9ccbfa7ab9d265e6eb703ee2fa4cfe7

Alexey Perevalov (3):
  Replace ternary operator to macro
  tracing/trivial: Add CLOCK_BOOTIME and CLOCK_TAI for human readable
    clockid trace
  tracing/trivial: Add CLOCK_*_DEFERRABLE for tracing clockids

Anton Vorontsov (2):
  timerfd: Move repeated logic into timerfd_rearm()
  timerfd: Add support for deferrable timers

Thomas Gleixner (1):
  hrtimer: Add support for deferrable timer into the hrtimer

 fs/timerfd.c                 |   47 ++++++++++++++++----------------
 include/linux/hrtimer.h      |    3 ++
 include/trace/events/timer.h |   25 ++++++++++++++---
 include/uapi/linux/time.h    |    3 ++
 kernel/hrtimer.c             |   62 +++++++++++++++++++++++++++++++++---------
 5 files changed, 100 insertions(+), 40 deletions(-)

-- 
1.7.9.5

