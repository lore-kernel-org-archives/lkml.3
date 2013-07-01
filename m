Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab3GAQEm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 12:04:42 -0400
Received: from multi.imgtec.com ([194.200.65.239]:10408 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752123Ab3GAQEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 12:04:41 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, James Hogan <james.hogan@imgtec.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Kirill Tkhai <tkhai@yandex.ru>, Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 0/5] metag: smp/hotplug fixes
Date: Mon, 1 Jul 2013 17:04:14 +0100
Message-ID: <1372694659-30176-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01192__2013_07_01_17_04_39
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kirill Tkhai kindly pointed out a bug in the metag SMP code, prompting
me to give it a bashing and weed out the hotplug bugs that have crept in
(or been around for a while). This patchset fixes various issues noticed
that I intend to apply for v3.11.

They're all short patches so please do give them a glance over in case
I've misunderstood anything.

James Hogan (5):
  metag: use clear_tasks_mm_cpumask()
  metag: smp: enable irqs after set_cpu_online
  metag: smp: don't spin waiting for CPU to start
  metag: kick: prevent nested kick handlers
  metag: cpu hotplug: route_irq: preserve irq mask

 arch/metag/kernel/irq.c  |  5 +++--
 arch/metag/kernel/kick.c |  9 +++++++++
 arch/metag/kernel/smp.c  | 35 +++++++++++++----------------------
 3 files changed, 25 insertions(+), 24 deletions(-)

Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Kirill Tkhai <tkhai@yandex.ru>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
-- 
1.8.1.2


