Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758219Ab3IHP51 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 11:57:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8228 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757345Ab3IHP4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 11:56:50 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=eIhxMilvRf8A:10 a=OSl8rswoWxQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Zvybn3zlWHMA:10 a=VwQbUJbxAAAA:8 a=G2CG-BG8zpKb4Sx9keIA:9 a=U62fhAwekXMA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130908151355.362583092@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sun, 08 Sep 2013 11:13:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT 00/19] 3.6.11.8-rt41-rc1 stable review
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

This is the RT stable review cycle of patch 3.6.11.8-rt41-rc1.

Please scream at me if I messed something up. Please test the patches too.

The -rc release will be uploaded to kernel.org and will be deleted when
the final release is out. This is just a review release (or release candidate).

The pre-releases will not be pushed to the git repository, only the
final release is.

If all goes well, this patch will be converted to the next main release
on 9/11/2013.

Enjoy,

-- Steve


To build 3.6.11.8-rt41-rc1 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.6.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.6.11.8.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/patch-3.6.11.8-rt41-rc1.patch.xz

You can also build from 3.6.11.8-rt40 by applying the incremental patch:

http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/incr/patch-3.6.11.8-rt40-rt41-rc1.patch.xz


Changes from 3.6.11.8-rt40:

---


Ivo Sieben (1):
      genirq: Set irq thread to RT priority on creation

John Kacur (1):
      hpsa: fix warning with smp_processor_id() in preemptible section

Mike Galbraith (1):
      x86/mce: fix mce timer interval

Paul Gortmaker (1):
      list_bl.h: make list head locking RT safe

Sebastian Andrzej Siewior (5):
      kernel/cpu: fix cpu down problem if kthread's cpu is going down
      kernel/hotplug: restore original cpu mask oncpu/down
      gpu: i915: allow the user not to do the wbinvd
      drm/i915: drop trace_i915_gem_ring_dispatch on rt
      genirq: do not invoke the affinity callback via a workqueue

Steven Rostedt (5):
      sched/workqueue: Only wake up idle workers if not blocked on sleeping spin lock
      rt,ntp: Move call to schedule_delayed_work() to helper thread
      hwlat-detector: Update hwlat_detector to add outer loop detection
      hwlat-detector: Use trace_clock_local if available
      hwlat-detector: Use thread instead of stop machine

Steven Rostedt (Red Hat) (2):
      hwlat-detect/trace: Export trace_clock_local for hwlat-detector
      Linux 3.6.11.8-rt41-rc1

Thomas Gleixner (1):
      sched: Distangle worker accounting from rqlock

Uwe Kleine-König (1):
      list_bl.h: fix it for for !SMP && !DEBUG_SPINLOCK

Zhao Hongjiang (1):
      timers: prepare for full preemption improve

----
 arch/x86/kernel/cpu/mcheck/mce.c           |    2 +-
 drivers/gpu/drm/i915/i915_gem.c            |   17 +++-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |    2 +
 drivers/misc/hwlat_detector.c              |  117 +++++++++++++++++-----------
 drivers/scsi/hpsa.c                        |    2 +-
 include/linux/interrupt.h                  |    1 +
 include/linux/list_bl.h                    |   28 ++++++-
 kernel/cpu.c                               |   29 ++++++-
 kernel/irq/manage.c                        |   90 +++++++++++++++++++--
 kernel/sched/core.c                        |   68 ++++------------
 kernel/time/ntp.c                          |   40 ++++++++++
 kernel/timer.c                             |    8 +-
 kernel/trace/trace_clock.c                 |    1 +
 kernel/workqueue.c                         |   59 +++++++-------
 kernel/workqueue_sched.h                   |    5 +-
 localversion-rt                            |    2 +-
 16 files changed, 319 insertions(+), 152 deletions(-)
