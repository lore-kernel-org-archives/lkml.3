Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789AbaAXHBG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 02:01:06 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:33562 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbaAXHBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 02:01:04 -0500
Subject: [PATCH V2 0/2] time/cpuidle: Support in tick broadcast framework in
 absence of external clock device
To: daniel.lezcano@linaro.org, peterz@infradead.org, fweisbec@gmail.com,
        galak@kernel.crashing.org, paul.gortmaker@windriver.com,
        paulus@samba.org, mingo@kernel.org, mikey@neuling.org,
        shangw@linux.vnet.ibm.com, rafael.j.wysocki@intel.com, agraf@suse.de,
        benh@kernel.crashing.org, paulmck@linux.vnet.ibm.com, arnd@arndb.de,
        linux-pm@vger.kernel.org, rostedt@goodmis.org, michael@ellerman.id.au,
        john.stultz@linaro.org, anton@samba.org, tglx@linutronix.de,
        chenhui.zhao@freescale.com, deepthi@linux.vnet.ibm.com,
        r58472@freescale.com, geoff@infradead.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, svaidy@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Date: Fri, 24 Jan 2014 12:27:08 +0530
Message-ID: <20140124065501.17564.39363.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012407-9332-0000-0000-000002DECABB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This earlier version of this patchset can be found here:
https://lkml.org/lkml/2013/12/12/687. This version has been based on the
discussion in http://www.kernelhub.org/?p=2&msg=399516.

This patchset provides the hooks that the architectures without an external
clock device and deep idle states where the local timers stop can make use of.

Presently we are in need of this support on certain implementations of
PowerPC. This patchset has been used on PowerPC for testing with

---

Preeti U Murthy (1):
      time: Change the return type of clockevents_notify() to integer

Thomas Gleixner (1):
      tick/cpuidle: Initialize hrtimer mode of broadcast


 include/linux/clockchips.h           |   15 ++++-
 kernel/time/Makefile                 |    2 -
 kernel/time/clockevents.c            |    8 ++-
 kernel/time/tick-broadcast-hrtimer.c |  102 ++++++++++++++++++++++++++++++++++
 kernel/time/tick-broadcast.c         |   51 ++++++++++++++++-
 kernel/time/tick-internal.h          |    6 +-
 6 files changed, 171 insertions(+), 13 deletions(-)
 create mode 100644 kernel/time/tick-broadcast-hrtimer.c

-- 

