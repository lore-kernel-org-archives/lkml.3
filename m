Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750994Ab3HTJee (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 05:34:34 -0400
Received: from service87.mimecast.com ([91.220.42.44]:34587 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab3HTJaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 05:30:15 -0400
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Sudeep.KarkadaNagesha@arm.com, Viresh Kumar <viresh.kumar@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jonas Bonn <jonas@southpole.se>, Michal Simek <monstr@monstr.eu>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
Subject: [PATCH v4 07/19] of/device: add helper to get cpu device node from logical cpu index
Date: Tue, 20 Aug 2013 10:30:09 +0100
Message-Id: <1376991021-12160-8-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376991021-12160-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
References: <1374492747-13879-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
 <1376991021-12160-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-OriginalArrivalTime: 20 Aug 2013 09:30:12.0490 (UTC) FILETIME=[DED3EEA0:01CE9D87]
X-MC-Unique: 113082010301304201
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r7K9ZZqA012361

From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>

Multiple drivers need to get the cpu device node from the cpu logical
index and then access the of_node.

This patch adds helper function to fetch the device node directly.

Acked-by: Rob Herring <rob.herring@calxeda.com>
Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
---
 include/linux/of_device.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/include/linux/of_device.h b/include/linux/of_device.h
index 9d27475..82ce324 100644
--- a/include/linux/of_device.h
+++ b/include/linux/of_device.h
@@ -1,6 +1,7 @@
 #ifndef _LINUX_OF_DEVICE_H
 #define _LINUX_OF_DEVICE_H
 
+#include <linux/cpu.h>
 #include <linux/platform_device.h>
 #include <linux/of_platform.h> /* temporary until merge */
 
@@ -43,6 +44,15 @@ static inline void of_device_node_put(struct device *dev)
 	of_node_put(dev->of_node);
 }
 
+static inline struct device_node *of_cpu_device_node_get(int cpu)
+{
+	struct device *cpu_dev;
+	cpu_dev = get_cpu_device(cpu);
+	if (!cpu_dev)
+		return NULL;
+	return of_node_get(cpu_dev->of_node);
+}
+
 #else /* CONFIG_OF */
 
 static inline int of_driver_match_device(struct device *dev,
@@ -67,6 +77,11 @@ static inline const struct of_device_id *of_match_device(
 {
 	return NULL;
 }
+
+static inline struct device_node *of_cpu_device_node_get(int cpu)
+{
+	return NULL;
+}
 #endif /* CONFIG_OF */
 
 #endif /* _LINUX_OF_DEVICE_H */
-- 
1.8.1.2


