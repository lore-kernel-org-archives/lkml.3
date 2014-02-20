Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbaBTImP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 03:42:15 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:54941 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031AbaBTImO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 03:42:14 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-1b-5305bfe3dcad
From: Alexey Perevalov <a.perevalov@samsung.com>
To: linux-kernel@vger.kernel.org, tglx@linutronix.de, john.stultz@linaro.org
Cc: Alexey Perevalov <a.perevalov@samsung.com>, anton@nomsg.org,
        kyungmin.park@samsung.com, cw00.choi@samsung.com,
        akpm@linux-foundation.org
Subject: [PATCH v3 0/6] Deferrable timers support for hrtimers/timerfd API
Date: Thu, 20 Feb 2014 12:40:27 +0400
Message-id: <1392885633-7787-1-git-send-email-a.perevalov@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGJMWRmVeSWpSXmKPExsVy+t/xa7qP97MGG5w5J2wx9+55Fos569ew
	WfT/6mS1uP7lOavFmd+6Fmeb3rBbXN41h81i86apzA4cHneu7WHzeHfuHLvHiRm/WTy+7NnL
	7NG3ZRWjx+dNcgFsUVw2Kak5mWWpRfp2CVwZ9+ZdZC5YxFWxfc8OtgbGD+xdjJwcEgImEh/3
	nYeyxSQu3FvP1sXIxSEksJRR4u8JGKeHSaLp1TGgKg4ONgEDiX33bEEaRAR8JHZN/MgEUsMs
	0Mco0df+ihkkISzgJTF30iqwqSwCqhLn389nBbF5Bdwk/vzsYgSZIyGgIDFnks0ERu4FjAyr
	GEVTS5MLipPSc430ihNzi0vz0vWS83M3MULC5usOxqXHrA4xCnAwKvHwRlxnCRZiTSwrrsw9
	xCjBwawkwsuTyRosxJuSWFmVWpQfX1Sak1p8iJGJg1OqgfHcZ26W6y5/91seNRGeqLw0hTPH
	KHzFymYOU7ezW+++FuP8Mfn35P/buT9rsZ8yFPmycMaLBXrL/Kec3jVhZsGS/Gczd0X31O6a
	FthT8jtKpcX6p6Z5TcKTX9tVLny+dkhLR7o/u9Ip6KrjukVthT+sXZuPbWrq0L4x5d16wQNf
	3PRvFN+MnPhciaU4I9FQi7moOBEAhof72fkBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

This is a combo patch set for support defferability in timerfd.
Due implementation of timerfd is based on hrtimers and only on hrtimers,
it was necessary to add such deferrability into hrtimers too.

It brings benefits for user-land application which don't want to break idle state and for
in-kernel users who want to use hrtimer advantages. 

Alexey Perevalov (2):
  tracing/trivial: Add CLOCK_BOOTIME and CLOCK_TAI for human readable
    clockid trace
  tracing/trivial: Add CLOCK_*_DEFERRABLE for tracing clockids

Anton Vorontsov (3):
  kernel/time: Add new helpers to convert ktime to/from jiffies
  timerfd: Factor out timer-type unspecific timerfd_expire()
  timerfd: Add support for deferrable timers

Thomas Gleixner (1):
  hrtimer: Add support for deferrable timer into the hrtimer

 fs/timerfd.c                 |   47 ++++++++++++++++----------------
 include/linux/hrtimer.h      |    3 ++
 include/linux/jiffies.h      |    4 ++-
 include/linux/ktime.h        |    3 +-
 include/trace/events/timer.h |   11 +++++++-
 include/uapi/linux/time.h    |    3 ++
 kernel/hrtimer.c             |   62 +++++++++++++++++++++++++++++++++---------
 kernel/time.c                |   23 ++++++++++++++++
 8 files changed, 117 insertions(+), 39 deletions(-)

-- 
1.7.9.5

