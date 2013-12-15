Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921Ab3LOT32 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 14:29:28 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:60028 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631Ab3LOT31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 14:29:27 -0500
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        linux-mmc@vger.kernel.org, josh@joshtriplett.org
Subject: =?UTF-8?q?=5BPATCH=20v2=5D=20drivers=3A=20mmc=3A=20Mark=20the=20function=20sdhci=5Fdisable=5Firq=5Fwakeups=28=29=20as=20static=20in=20sdhci=2Ec?=
Date: Mon, 16 Dec 2013 00:59:16 +0530
Message-Id: <1387135756-27057-1-git-send-email-rashika.kheria@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20131214131631.GA8543@rashika>
References: <20131214131631.GA8543@rashika>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch marks the function sdhci_disable_irq_wakeups() as static in
host/sdhci.c because it is not used outside this file. It also removes
the EXPORT_SYMBOL_GPL because no other file in kernel uses this
function.

Thus, it also eliminates the following warning in host/sdhci.c:
drivers/mmc/host/sdhci.c:2553:6: warning: no previous prototype for ‘sdhci_disable_irq_wakeups’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/mmc/host/sdhci.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index bd8a098..5fcf200 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -2550,7 +2550,7 @@ void sdhci_enable_irq_wakeups(struct sdhci_host *host)
 }
 EXPORT_SYMBOL_GPL(sdhci_enable_irq_wakeups);
 
-void sdhci_disable_irq_wakeups(struct sdhci_host *host)
+static void sdhci_disable_irq_wakeups(struct sdhci_host *host)
 {
 	u8 val;
 	u8 mask = SDHCI_WAKE_ON_INSERT | SDHCI_WAKE_ON_REMOVE
@@ -2560,7 +2560,6 @@ void sdhci_disable_irq_wakeups(struct sdhci_host *host)
 	val &= ~mask;
 	sdhci_writeb(host, val, SDHCI_WAKE_UP_CONTROL);
 }
-EXPORT_SYMBOL_GPL(sdhci_disable_irq_wakeups);
 
 int sdhci_suspend_host(struct sdhci_host *host)
 {
-- 
1.7.9.5

