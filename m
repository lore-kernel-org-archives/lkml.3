Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268Ab3JRL50 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 07:57:26 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:44799 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406Ab3JRLx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 07:53:59 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@kernel.org,
        pjt@google.com, Morten.Rasmussen@arm.com, cmetcalf@tilera.com,
        tony.luck@intel.com, alex.shi@intel.com, preeti@linux.vnet.ibm.com,
        linaro-kernel@lists.linaro.org
Cc: rjw@sisk.pl, paulmck@linux.vnet.ibm.com, corbet@lwn.net,
        tglx@linutronix.de, len.brown@intel.com, arjan@linux.intel.com,
        amit.kucheria@linaro.org, l.majewski@samsung.com,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [RFC][PATCH v5 11/14] sched: add a SCHED_PACKING_TASKS config
Date: Fri, 18 Oct 2013 13:52:24 +0200
Message-Id: <1382097147-30088-11-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1382097147-30088-1-git-send-email-vincent.guittot@linaro.org>
References: <1382097147-30088-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SCHED_PACKING_TASKS config is used to enable the packing tasks mecanism

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 init/Kconfig |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/init/Kconfig b/init/Kconfig
index 3ecd8a1..4d2b5db 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1178,6 +1178,17 @@ config SCHED_AUTOGROUP
 	  desktop applications.  Task group autogeneration is currently based
 	  upon task session.
 
+config SCHED_PACKING_TASKS
+	bool "Automatic tasks packing"
+	depends on SMP && SCHED_MC
+	default n
+	help
+	  This option enable the packing mode of the scheduler.
+	  This mode ensures that the minimal number of CPUs will
+	  be used to handle the activty of the system. The CPUs
+	  are selected to minimized the number of power domain
+	  that must be kept on
+
 config MM_OWNER
 	bool
 
-- 
1.7.9.5

