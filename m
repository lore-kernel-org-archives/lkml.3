Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab3CDBMm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 20:12:42 -0500
Received: from linux-sh.org ([111.68.239.195]:41136 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754654Ab3CDBMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 20:12:41 -0500
Date: Mon, 4 Mar 2013 10:12:35 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: james.hogan@imgtec.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] metag: Inhibit NUMA balancing.
Message-ID: <20130304011231.GA26475@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The metag NUMA implementation follows the SH model, using different nodes for
memories with different latencies. As such, we ensure that automated balancing
between nodes is inhibited, by way of the new ARCH_WANT_VARIABLE_LOCALITY.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

diff --git a/arch/metag/mm/Kconfig b/arch/metag/mm/Kconfig
index cd7f2f2..975f2f4 100644
--- a/arch/metag/mm/Kconfig
+++ b/arch/metag/mm/Kconfig
@@ -40,6 +40,7 @@ endchoice
 
 config NUMA
 	bool "Non Uniform Memory Access (NUMA) Support"
+	select ARCH_WANT_NUMA_VARIABLE_LOCALITY
 	help
 	  Some Meta systems have MMU-mappable on-chip memories with
 	  lower latencies than main memory. This enables support for
