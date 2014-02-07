Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023AbaBGIJh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 03:09:37 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:56912 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446AbaBGIJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 03:09:35 -0500
Subject: [PATCH V4 0/3] time/cpuidle: Support in tick broadcast framework in
 absence of external clock device
To: linux-pm@vger.kernel.org, peterz@infradead.org, benh@kernel.crashing.org,
        rafael.j.wysocki@intel.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, linuxppc-dev@lists.ozlabs.org, mingo@kernel.org
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: deepthi@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com, fweisbec@gmail.com,
        paulus@samba.org, srivatsa.bhat@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com
Date: Fri, 07 Feb 2014 13:35:56 +0530
Message-ID: <20140207075618.17187.20149.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14020708-7182-0000-0000-000009C6C01B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset provides support in the tick broadcast framework for such
architectures so as to enable the CPUs to get into deep idle.

Presently we are in need of this support on certain implementations of
PowerPC. This patchset has thus been tested on the same.

This patchset has been based on the idea discussed here:
http://www.kernelhub.org/?p=2&msg=399516

Changes in V4:
1. Cleared the stand by CPU from the oneshot mask. As a result PATCH 3/3
was simplified.
2. Fixed compile time warnings.
---

Preeti U Murthy (2):
      time: Change the return type of clockevents_notify() to integer
      time/cpuidle:Handle failed call to BROADCAST_ENTER on archs with CPUIDLE_FLAG_TIMER_STOP set

Thomas Gleixner (1):
      tick/cpuidle: Initialize hrtimer mode of broadcast


 drivers/cpuidle/cpuidle.c            |   14 +++--
 include/linux/clockchips.h           |   15 ++++-
 kernel/time/Makefile                 |    2 -
 kernel/time/clockevents.c            |    8 ++-
 kernel/time/tick-broadcast-hrtimer.c |  105 ++++++++++++++++++++++++++++++++++
 kernel/time/tick-broadcast.c         |   60 ++++++++++++++++++-
 kernel/time/tick-internal.h          |    6 +-
 7 files changed, 189 insertions(+), 21 deletions(-)
 create mode 100644 kernel/time/tick-broadcast-hrtimer.c

-- 

