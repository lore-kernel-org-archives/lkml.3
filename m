Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113Ab3J3DPj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 23:15:39 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:58805 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573Ab3J3DPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 23:15:38 -0400
Subject: [PATCH V2 0/2] sched: Cleanups,fixes in nohz_kick_needed()
To: peterz@infradead.org, mikey@neuling.org, svaidy@linux.vnet.ibm.com,
        mingo@kernel.org
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: vincent.guittot@linaro.org, bitbucket@online.de, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org, anton@samba.org,
        linuxppc-dev@lists.ozlabs.org, Morten.Rasmussen@arm.com,
        pjt@google.com
Date: Wed, 30 Oct 2013 08:42:33 +0530
Message-ID: <20131030031145.23426.22930.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13103003-5806-0000-0000-0000234206F4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from V1:https://lkml.org/lkml/2013/10/21/248

1. Swapped the order of PATCH1 and PATCH2 in V1 so as to not mess with the
nr_busy_cpus parameter computation during asymmetric balancing, while fixing
it.

2. nohz_busy_cpus parameter is to be updated and queried at only one level of
the sched domain-sd_busy where it is relevant.

3. Introduce sd_asym to represent the sched domain where asymmetric load
balancing has to be done.
---

Preeti U Murthy (1):
      sched: Remove un-necessary iteration over sched domains to update nr_busy_cpus

Vaidyanathan Srinivasan (1):
      sched: Fix asymmetric scheduling for POWER7


 kernel/sched/core.c  |    6 ++++++
 kernel/sched/fair.c  |   38 ++++++++++++++++++++------------------
 kernel/sched/sched.h |    2 ++
 3 files changed, 28 insertions(+), 18 deletions(-)

