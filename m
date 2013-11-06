Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603Ab3KFNGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 08:06:55 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:40626 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756346Ab3KFNGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 08:06:54 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] random: Add missing linux/device.h include
Date: Wed,  6 Nov 2013 14:06:50 +0100
Message-Id: <1383743210-4290-1-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit f0ed2b943a53 (random: use device attach events for entropy) uses
a member of struct device, which isn't always available and therefore
causes the xcep_defconfig build to break on ARM.

Explicitly including the linux/device.h header fixes this issue.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/char/random.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 26649ba..4f172f9 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -257,6 +257,7 @@
 #include <linux/kmemcheck.h>
 #include <linux/irq.h>
 #include <linux/workqueue.h>
+#include <linux/device.h>
 
 #include <asm/processor.h>
 #include <asm/uaccess.h>
-- 
1.8.4

