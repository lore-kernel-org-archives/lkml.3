Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003AbaGTGnk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 02:43:40 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:61188 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbaGTGnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 02:43:39 -0400
Message-ID: <1405838616.6512.42.camel@marge.simpson.net>
Subject: 143e1e28 sched: Rework sched_domain topology definition
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Date: Sun, 20 Jul 2014 08:43:36 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

+/*
+ * Topology list, bottom-up.
+ */
+static struct sched_domain_topology_level default_topology[] = {
+#ifdef CONFIG_SCHED_SMT
+	{ cpu_smt_mask, cpu_smt_flags, SD_INIT_NAME(SMT) },
+#endif
+#ifdef CONFIG_SCHED_MC
+	{ cpu_coregroup_mask, cpu_core_flags, SD_INIT_NAME(MC) },
+#endif
+#ifdef CONFIG_SCHED_BOOK
+	{ cpu_book_mask, SD_INIT_NAME(BOOK) },
+#endif
+	{ cpu_cpu_mask, SD_INIT_NAME(DIE) },
+	{ NULL, },
+};

Why did this commit rename the CPU domain to DIE?

-Mike

