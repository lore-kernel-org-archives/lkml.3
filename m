Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806Ab3F1K6s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 06:58:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40397 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755788Ab3F1K6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 06:58:47 -0400
Date: Fri, 28 Jun 2013 03:58:24 -0700
From: tip-bot for Sachin Kamat <tipbot@zytor.com>
Message-ID: <tip-b8394dee787bbd7d52614b7ca44ea7aa05feb9ad@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, sachin.kamat@linaro.org, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, sachin.kamat@linaro.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <1372246597-32323-2-git-send-email-sachin.kamat@linaro.org>
References: <1372246597-32323-2-git-send-email-sachin.kamat@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] irqchip: exynos-combiner: Staticize combiner_init
Git-Commit-ID: b8394dee787bbd7d52614b7ca44ea7aa05feb9ad
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 28 Jun 2013 03:58:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b8394dee787bbd7d52614b7ca44ea7aa05feb9ad
Gitweb:     http://git.kernel.org/tip/b8394dee787bbd7d52614b7ca44ea7aa05feb9ad
Author:     Sachin Kamat <sachin.kamat@linaro.org>
AuthorDate: Wed, 26 Jun 2013 17:06:37 +0530
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 28 Jun 2013 12:56:03 +0200

irqchip: exynos-combiner: Staticize combiner_init

combiner_init() is referenced only in this file. Make it
static.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com
Cc: t.figa@samsung.com
Cc: arnd@arndb.de
Cc: patches@linaro.org
Link: http://lkml.kernel.org/r/1372246597-32323-2-git-send-email-sachin.kamat@linaro.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/irqchip/exynos-combiner.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/exynos-combiner.c b/drivers/irqchip/exynos-combiner.c
index a9d2b2f..4c68265 100644
--- a/drivers/irqchip/exynos-combiner.c
+++ b/drivers/irqchip/exynos-combiner.c
@@ -204,10 +204,10 @@ static unsigned int combiner_lookup_irq(int group)
 	return 0;
 }
 
-void __init combiner_init(void __iomem *combiner_base,
-			  struct device_node *np,
-			  unsigned int max_nr,
-			  int irq_base)
+static void __init combiner_init(void __iomem *combiner_base,
+				 struct device_node *np,
+				 unsigned int max_nr,
+				 int irq_base)
 {
 	int i, irq;
 	unsigned int nr_irq;
