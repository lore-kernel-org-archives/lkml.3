Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593AbaDQRoA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 13:44:00 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:34501 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489AbaDQRnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 13:43:43 -0400
Date: Thu, 17 Apr 2014 10:43:34 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, tj@kernel.org
Cc: cl@linux.com, mingo@kernel.org, grygorii.strashko@ti.com,
        peterz@infradead.org
Subject: [PATCH] percpu: Fix raw_cpu_inc_return()
Message-ID: <20140417174334.GA20303@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14041717-0928-0000-0000-0000013B50CC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a build bug triggered by one of the RCU commits
queued for 3.16.

The definition for raw_cpu_add_return() uses the operation prefix
"raw_add_return_", but the definitions in the various percpu.h files
expect "raw_cpu_add_return_".  This commit therefore appropriately
adjusts the definition of raw_cpu_add_return().

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Christoph Lameter <cl@linux.com>

diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index e7a0b95ed527..495c6543a8f2 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -639,7 +639,7 @@ do {									\
 #  define raw_cpu_add_return_8(pcp, val)	raw_cpu_generic_add_return(pcp, val)
 # endif
 # define raw_cpu_add_return(pcp, val)	\
-	__pcpu_size_call_return2(raw_add_return_, pcp, val)
+	__pcpu_size_call_return2(raw_cpu_add_return_, pcp, val)
 #endif
 
 #define raw_cpu_sub_return(pcp, val)	raw_cpu_add_return(pcp, -(typeof(pcp))(val))

