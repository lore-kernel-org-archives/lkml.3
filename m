Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751326AbaEQTYP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 15:24:15 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:63528 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbaEQTXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 15:23:45 -0400
From: Konrad Zapalowicz <bergo.torino@gmail.com>
To: gregkh@linuxfoundation.org
Cc: standby24x7@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Konrad Zapalowicz <bergo.torino@gmail.com>
Subject: [PATCH 1/2] staging: rtl8821ae: fix double const in sw.c
Date: Sat, 17 May 2014 21:23:37 +0200
Message-Id: <1400354618-13471-2-git-send-email-bergo.torino@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1400354618-13471-1-git-send-email-bergo.torino@gmail.com>
References: <1400354618-13471-1-git-send-email-bergo.torino@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit fixes the following sparse warning:

drivers/staging/rtl8821ae/rtl8821ae/sw.c:
    - 449:14: warning: duplicate const

Signed-off-by: Konrad Zapalowicz <bergo.torino@gmail.com>
---
 drivers/staging/rtl8821ae/rtl8821ae/sw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8821ae/rtl8821ae/sw.c b/drivers/staging/rtl8821ae/rtl8821ae/sw.c
index a8d1755..c24d426 100644
--- a/drivers/staging/rtl8821ae/rtl8821ae/sw.c
+++ b/drivers/staging/rtl8821ae/rtl8821ae/sw.c
@@ -446,7 +446,7 @@ MODULE_PARM_DESC(ips, "using no link power save (default 1 is open)\n");
 MODULE_PARM_DESC(fwlps, "using linked fw control power save (default 1 is open)\n");
 
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
-static const SIMPLE_DEV_PM_OPS(rtlwifi_pm_ops, rtl_pci_suspend, rtl_pci_resume);
+static SIMPLE_DEV_PM_OPS(rtlwifi_pm_ops, rtl_pci_suspend, rtl_pci_resume);
 #endif
 
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29))
-- 
1.8.1.2

