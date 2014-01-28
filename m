Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864AbaA1WT3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 17:19:29 -0500
Received: from mail-qc0-f172.google.com ([209.85.216.172]:39548 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755315AbaA1WT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 17:19:27 -0500
Date: Tue, 28 Jan 2014 17:19:22 -0500
From: Tejun Heo <tj@kernel.org>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>, linux-tegra@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] arm, pm, vmpressure: add missing slab.h includes
Message-ID: <20140128221922.GC16060@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/arm/mach-tegra/pm.c, kernel/power/console.c and mm/vmpressure.c
were somehow getting slab.h indirectly through cgroup.h which in turn
was getting it indirectly through xattr.h.  A scheduled cgroup change
drops xattr.h inclusion from cgroup.h and breaks compilation of these
three files.  Add explicit slab.h includes to the three files.

A pending cgroup patch depends on this change and it'd be great if
this can be routed through cgroup/for-3.14-fixes branch.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: linux-tegra@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-pm@vger.kernel.org
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: cgroups@vger.kernel.org
---
If you guys are okay with this going through cgroup/for-3.14-fixes,
can you please ack it?

Thanks!

 arch/arm/mach-tegra/pm.c |    1 +
 kernel/power/console.c   |    1 +
 mm/vmpressure.c          |    1 +
 3 files changed, 3 insertions(+)

--- a/arch/arm/mach-tegra/pm.c
+++ b/arch/arm/mach-tegra/pm.c
@@ -24,6 +24,7 @@
 #include <linux/cpu_pm.h>
 #include <linux/suspend.h>
 #include <linux/err.h>
+#include <linux/slab.h>
 #include <linux/clk/tegra.h>
 
 #include <asm/smp_plat.h>
--- a/kernel/power/console.c
+++ b/kernel/power/console.c
@@ -9,6 +9,7 @@
 #include <linux/kbd_kern.h>
 #include <linux/vt.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 #include "power.h"
 
 #define SUSPEND_CONSOLE	(MAX_NR_CONSOLES-1)
--- a/mm/vmpressure.c
+++ b/mm/vmpressure.c
@@ -19,6 +19,7 @@
 #include <linux/mm.h>
 #include <linux/vmstat.h>
 #include <linux/eventfd.h>
+#include <linux/slab.h>
 #include <linux/swap.h>
 #include <linux/printk.h>
 #include <linux/vmpressure.h>
