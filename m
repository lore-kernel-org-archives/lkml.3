Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205Ab3LSIDq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 03:03:46 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:37328 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab3LSIDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 03:03:44 -0500
Message-ID: <52B2A85C.9060303@gmail.com>
Date: Thu, 19 Dec 2013 16:03:40 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>
CC: linux-metag@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arch: metag: kernel: export 'cpu_core_map' in "topology.c"
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need export 'cpu_core_map', or cann't pass compiling with allmodconfig,
the related error:

    MODPOST 2909 modules
  ERROR: "cpu_core_map" [drivers/staging/lustre/lustre/libcfs/libcfs.ko] undefined!


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 arch/metag/kernel/topology.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/metag/kernel/topology.c b/arch/metag/kernel/topology.c
index bec3dec..4ba5957 100644
--- a/arch/metag/kernel/topology.c
+++ b/arch/metag/kernel/topology.c
@@ -19,6 +19,7 @@
 DEFINE_PER_CPU(struct cpuinfo_metag, cpu_data);
 
 cpumask_t cpu_core_map[NR_CPUS];
+EXPORT_SYMBOL(cpu_core_map);
 
 static cpumask_t cpu_coregroup_map(unsigned int cpu)
 {
-- 
1.7.11.7
