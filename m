Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638AbaDPGGa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 02:06:30 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:57963 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205AbaDPGG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 02:06:28 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v2] cpufreq, powernv: Fix build failure on UP
To: paul.gortmaker@windriver.com, rjw@rjwysocki.net
Cc: viresh.kumar@linaro.org, ego@linux.vnet.ibm.com, svaidy@linux.vnet.ibm.com,
        preeti@linux.vnet.ibm.com, linux-next@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Wed, 16 Apr 2014 11:35:38 +0530
Message-ID: <20140416060521.31321.98737.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14041606-9574-0000-0000-00000D1837FF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Gortmaker reported the following build failure of the powernv cpufreq
driver on UP configs:

drivers/cpufreq/powernv-cpufreq.c:241:2: error: implicit declaration of
function 'cpu_sibling_mask' [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors
make[3]: *** [drivers/cpufreq/powernv-cpufreq.o] Error 1
make[2]: *** [drivers/cpufreq] Error 2
make[1]: *** [drivers] Error 2
make: *** [sub-make] Error 2

The trouble here is that cpu_sibling_mask is defined only in <asm/smp.h>, and
<linux/smp.h> includes <asm/smp.h> only in SMP builds.

So fix this build failure by explicitly including <asm/smp.h> in the driver,
so that we get the definition of cpu_sibling_mask even in UP configurations.

Reported-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
---

 drivers/cpufreq/powernv-cpufreq.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpufreq/powernv-cpufreq.c b/drivers/cpufreq/powernv-cpufreq.c
index 9edccc6..af49688 100644
--- a/drivers/cpufreq/powernv-cpufreq.c
+++ b/drivers/cpufreq/powernv-cpufreq.c
@@ -29,6 +29,7 @@
 
 #include <asm/cputhreads.h>
 #include <asm/reg.h>
+#include <asm/smp.h> /* Required for cpu_sibling_mask() in UP configs */
 
 #define POWERNV_MAX_PSTATES	256
 

