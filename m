Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751419Ab3IHM1G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 08:27:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10937 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab3IHM1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 08:27:02 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=E-kABC6sUUQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Zvybn3zlWHMA:10 a=VwQbUJbxAAAA:8 a=Dy9FSkG8L0gs_orUxm0A:9 a=U62fhAwekXMA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130908122545.421180629@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sun, 08 Sep 2013 08:25:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT 00/10] 3.8.13-rt16-rc1 stable review
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

This is the RT stable review cycle of patch 3.8.13-rt16-rc1.

Please scream at me if I messed something up. Please test the patches too.

The -rc release will be uploaded to kernel.org and will be deleted when
the final release is out. This is just a review release (or release candidate).

The pre-releases will not be pushed to the git repository, only the
final release is.

If all goes well, this patch will be converted to the next main release
on 9/11/2013.

Enjoy,

-- Steve


To build 3.8.13-rt16-rc1 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.8.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.8.13.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.8/patch-3.8.13-rt16-rc1.patch.xz

You can also build from 3.8.13-rt15 by applying the incremental patch:

http://www.kernel.org/pub/linux/kernel/projects/rt/3.8/incr/patch-3.8.13-rt15-rt16-rc1.patch.xz


Changes from 3.8.13-rt15:

---


John Kacur (1):
      hpsa: fix warning with smp_processor_id() in preemptible section

Sebastian Andrzej Siewior (2):
      powerpc: 52xx: provide a default in mpc52xx_irqhost_map()
      genirq: do not invoke the affinity callback via a workqueue

Steven Rostedt (4):
      rt,ntp: Move call to schedule_delayed_work() to helper thread
      hwlat-detector: Update hwlat_detector to add outer loop detection
      hwlat-detector: Use trace_clock_local if available
      hwlat-detector: Use thread instead of stop machine

Steven Rostedt (Red Hat) (2):
      hwlat-detect/trace: Export trace_clock_local for hwlat-detector
      Linux 3.8.13-rt16-rc1

Thomas Gleixner (1):
      sched: Distangle worker accounting from rqlock

----
 arch/powerpc/platforms/52xx/mpc52xx_pic.c |    3 +-
 drivers/misc/hwlat_detector.c             |  117 ++++++++++++++++++-----------
 drivers/scsi/hpsa.c                       |    2 +-
 include/linux/interrupt.h                 |    1 +
 kernel/irq/manage.c                       |   79 ++++++++++++++++++-
 kernel/sched/core.c                       |   70 ++++-------------
 kernel/time/ntp.c                         |   40 ++++++++++
 kernel/trace/trace_clock.c                |    1 +
 kernel/workqueue.c                        |   63 +++++++---------
 kernel/workqueue_sched.h                  |    5 +-
 localversion-rt                           |    2 +-
 11 files changed, 240 insertions(+), 143 deletions(-)
