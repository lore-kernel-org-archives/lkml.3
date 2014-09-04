Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbaIDQbT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 12:31:19 -0400
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:49853 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751410AbaIDQbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 12:31:17 -0400
X-Yandex-Uniq: 4bcdfb89-517e-4ed6-80e3-3b501b5c3222
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: klamm@yandex-team.ru
To: peterz@infradead.org, mingo@redhat.com, linux-kernel@vger.kernel.org
Cc: stfomichev@yandex-team.ru, Roman Gushchin <klamm@yandex-team.ru>
Subject: [PATCH 02/19] smart: add config option for SMART-related code
Date: Thu,  4 Sep 2014 20:30:48 +0400
Message-Id: <1409848265-17150-2-git-send-email-klamm@yandex-team.ru>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409848265-17150-1-git-send-email-klamm@yandex-team.ru>
References: <77161409833206@webcorp01h.yandex-team.ru>
 <1409848265-17150-1-git-send-email-klamm@yandex-team.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roman Gushchin <klamm@yandex-team.ru>

All the SMART-related code will use CONFIG_SMART config option.

Signed-off-by: Roman Gushchin <klamm@yandex-team.ru>
---
 init/Kconfig | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/init/Kconfig b/init/Kconfig
index 5d6feba..98dd173 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -802,6 +802,17 @@ config NUMA_BALANCING
 
 	  This system will be inactive on UMA systems.
 
+config SMART
+	bool "Enable SMART rt scheduler extension"
+	default y
+	depends on SMP
+	help
+	  This option enables SMART (Simultaneous Multithreading-Aware Real-Time)
+	  scheduler exitension. SMART allows efficiently use of real-time
+	  scheduler for runtime tasks on modern multi-cores CPUs with
+	  enabled hyper-threading.
+	  Do not use for hard real-time purposes.
+
 menuconfig CGROUPS
 	boolean "Control Group support"
 	depends on EVENTFD
-- 
1.9.3

