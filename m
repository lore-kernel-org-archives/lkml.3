Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab3F0T5j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 15:57:39 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:57331 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466Ab3F0T5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 15:57:34 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v3 09/45] CPU hotplug: Convert preprocessor macros to static
 inline functions
To: tglx@linutronix.de, peterz@infradead.org, tj@kernel.org, oleg@redhat.com,
        paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au, mingo@kernel.org,
        akpm@linux-foundation.org, namhyung@kernel.org, walken@google.com,
        vincent.guittot@linaro.org, laijs@cn.fujitsu.com,
        David.Laight@aculab.com
Cc: rostedt@goodmis.org, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, sbw@mit.edu, fweisbec@gmail.com,
        zhong@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        srivatsa.bhat@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-arch@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Fri, 28 Jun 2013 01:24:11 +0530
Message-ID: <20130627195411.29830.50898.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130627195136.29830.10445.stgit@srivatsabhat.in.ibm.com>
References: <20130627195136.29830.10445.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062719-2000-0000-0000-00000CACA989
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the macros in the CPU hotplug code to static inline C functions.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 include/linux/cpu.h |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index a57b25a..85431a0 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -202,10 +202,8 @@ static inline void cpu_hotplug_driver_unlock(void)
 
 #else		/* CONFIG_HOTPLUG_CPU */
 
-#define get_online_cpus()	do { } while (0)
-#define put_online_cpus()	do { } while (0)
-#define cpu_hotplug_disable()	do { } while (0)
-#define cpu_hotplug_enable()	do { } while (0)
+static inline void get_online_cpus(void) {}
+static inline void put_online_cpus(void) {}
 
 static inline unsigned int get_online_cpus_atomic(void)
 {
@@ -222,6 +220,9 @@ static inline void put_online_cpus_atomic(void)
 	preempt_enable();
 }
 
+static inline void cpu_hotplug_disable(void) {}
+static inline void cpu_hotplug_enable(void) {}
+
 #define hotcpu_notifier(fn, pri)	do { (void)(fn); } while (0)
 /* These aren't inline functions due to a GCC bug. */
 #define register_hotcpu_notifier(nb)	({ (void)(nb); 0; })

