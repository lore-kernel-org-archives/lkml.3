Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbaJTJFc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 05:05:32 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:43755 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264AbaJTJFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 05:05:22 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-21-5444d04ff73a
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Jonathan Corbet <corbet@lwn.net>,
        Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        linux-pm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH v8 1/5] PM / Runtime: Add getter for querying the IRQ safe
 option
Date: Mon, 20 Oct 2014 11:04:44 +0200
Message-id: <1413795888-18559-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1413795888-18559-1-git-send-email-k.kozlowski@samsung.com>
References: <1413795888-18559-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsVy+t/xa7r+F1xCDHatV7HYOGM9q8WTA+2M
	FtOnXmC0WD31L6vF6xeGFmeb3rBbLJk8n9Vi1pS9TBYL25awWFzeNYfN4nPvEUaL25d5LdYe
	uctu8e5lhMXdU0fZLM6cvsRqMeH3BTaL42vDLV727WdxEPZoae5h81i85yWTx51re4Csvsms
	HkveHGL12HK1ncVj9t0fjB59W1YxeqxY/Z3d4/MmOY+9n3+zBHBHcdmkpOZklqUW6dslcGVs
	/7CQraBVqOL9lS1MDYy9/F2MnBwSAiYS1z83M0PYYhIX7q1n62Lk4hASWMoocavxJTOE08ck
	8ffIUVaQKjYBY4nNy5eAVYkIHGeRWNxzAcxhFpjCKNE8aSkTSJWwQLDEjZMH2EBsFgFViS/z
	DjOC2LwC7hIv/6xghNgnJ3Hy2GSwqZwCHhLTWx6DxYWAaroXrmKawMi7gJFhFaNoamlyQXFS
	eq6hXnFibnFpXrpecn7uJkZIHHzZwbj4mNUhRgEORiUeXgFLlxAh1sSy4srcQ4wSHMxKIrxM
	R4FCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGGeeYt+tNsMocpFW5uVPVduFtpa3+C7d+9L67VLB
	3lJVweNl8dEeU7e8PLrGqD+auZO7X+nuP5lKc5uIf51r+dcUNAXd/+4wve+zOsPaG1LRSl+e
	JeVeZmlMzKmxe9892WfT9VfvjSb0bMk8tfl2/FTNL0E9p/a52SllHan5En9E732b6r2b+5RY
	ijMSDbWYi4oTAVT7N45hAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a simple getter pm_runtime_is_irq_safe() for querying whether runtime
PM IRQ safe was set or not.

Various bus drivers implementing runtime PM may use choose to suspend
differently based on IRQ safeness status of child driver (e.g. do not
unprepare the clock if IRQ safe is not set).

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 Documentation/power/runtime_pm.txt | 4 ++++
 include/linux/pm_runtime.h         | 6 ++++++
 2 files changed, 10 insertions(+)

diff --git a/Documentation/power/runtime_pm.txt b/Documentation/power/runtime_pm.txt
index f32ce5419573..397b81593142 100644
--- a/Documentation/power/runtime_pm.txt
+++ b/Documentation/power/runtime_pm.txt
@@ -468,6 +468,10 @@ drivers/base/power/runtime.c and include/linux/pm_runtime.h:
     - set the power.irq_safe flag for the device, causing the runtime-PM
       callbacks to be invoked with interrupts off
 
+  bool pm_runtime_is_irq_safe(struct device *dev);
+    - return true if power.irq_safe flag was set for the device, causing
+      the runtime-PM callbacks to be invoked with interrupts off
+
   void pm_runtime_mark_last_busy(struct device *dev);
     - set the power.last_busy field to the current time
 
diff --git a/include/linux/pm_runtime.h b/include/linux/pm_runtime.h
index 367f49b9a1c9..44d74f0f182e 100644
--- a/include/linux/pm_runtime.h
+++ b/include/linux/pm_runtime.h
@@ -128,6 +128,11 @@ static inline void pm_runtime_mark_last_busy(struct device *dev)
 	ACCESS_ONCE(dev->power.last_busy) = jiffies;
 }
 
+static inline bool pm_runtime_is_irq_safe(struct device *dev)
+{
+	return dev->power.irq_safe;
+}
+
 #else /* !CONFIG_PM_RUNTIME */
 
 static inline int __pm_runtime_idle(struct device *dev, int rpmflags)
@@ -167,6 +172,7 @@ static inline bool pm_runtime_enabled(struct device *dev) { return false; }
 
 static inline void pm_runtime_no_callbacks(struct device *dev) {}
 static inline void pm_runtime_irq_safe(struct device *dev) {}
+static inline bool pm_runtime_is_irq_safe(struct device *dev) { return false; }
 
 static inline bool pm_runtime_callbacks_present(struct device *dev) { return false; }
 static inline void pm_runtime_mark_last_busy(struct device *dev) {}
-- 
1.9.1

