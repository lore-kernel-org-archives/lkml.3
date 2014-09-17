Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370AbaIQWeK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 18:34:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:21563 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757056AbaIQWd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 18:33:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,542,1406617200"; 
   d="scan'208";a="604481310"
Subject: [RFC][PATCH 3/6] x86: use package_map instead of core_map for sysfs
To: a.p.zijlstra@chello.nl
Cc: mingo@kernel.org, hpa@linux.intel.com, brice.goglin@gmail.com,
        bp@alien8.de, linux-kernel@vger.kernel.org,
        Dave Hansen <dave@sr71.net>, dave.hansen@linux.intel.com
From: Dave Hansen <dave@sr71.net>
Date: Wed, 17 Sep 2014 15:33:15 -0700
References: <20140917223310.026BCC2C@viggo.jf.intel.com>
In-Reply-To: <20140917223310.026BCC2C@viggo.jf.intel.com>
Message-Id: <20140917223315.B48134C6@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

The /sys/devices/system/cpu/cpu*/topology/core_siblings*
files were previously built from the "cpu_core_map".  That
mask is deeply connected to the sched domains internal
multi-core (MC) level, which is now become disconnected from
the actual CPU package.

We have a new "cpu_package_map" which has the sole purpose of
tracking which package the CPU is in and is unconnected to the
scheduler.  We will now build those sysfs with information from
the new package map.

Note: this also realigns the sysfs files with their documentation
in Documentation/ABI.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 b/arch/x86/include/asm/topology.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/include/asm/topology.h~x86-use-package-map-instead-of-core-map arch/x86/include/asm/topology.h
--- a/arch/x86/include/asm/topology.h~x86-use-package-map-instead-of-core-map	2014-09-17 15:28:57.508571881 -0700
+++ b/arch/x86/include/asm/topology.h	2014-09-17 15:28:57.511572017 -0700
@@ -124,7 +124,7 @@ extern const struct cpumask *cpu_package
 #define topology_core_id(cpu)			(cpu_data(cpu).cpu_core_id)
 
 #ifdef ENABLE_TOPO_DEFINES
-#define topology_package_cpumask(cpu)		(per_cpu(cpu_core_map, cpu))
+#define topology_package_cpumask(cpu)		(per_cpu(cpu_package_map, cpu))
 #define topology_thread_cpumask(cpu)		(per_cpu(cpu_sibling_map, cpu))
 #endif
 
_
