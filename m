Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937Ab3BFJPN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 04:15:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57128 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752003Ab3BFJPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 04:15:09 -0500
From: Michal Hocko <mhocko@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Axel Lin <axel.lin@gmail.com>
Subject: [PATCH] da9030_battery: include notifier.h
Date: Wed,  6 Feb 2013 10:14:58 +0100
Message-Id: <1360142098-13124-1-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

randconfig complains about:
drivers/power/da9030_battery.c:113: error: field ‘nb’ has incomplete type

because there is no direct include for notifier.h which defines
struct notifier_block.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 drivers/power/da9030_battery.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/da9030_battery.c b/drivers/power/da9030_battery.c
index 94762e6..e8c5a39 100644
--- a/drivers/power/da9030_battery.c
+++ b/drivers/power/da9030_battery.c
@@ -22,6 +22,7 @@
 
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
+#include <linux/notifier.h>
 
 #define DA9030_FAULT_LOG		0x0a
 #define DA9030_FAULT_LOG_OVER_TEMP	(1 << 7)
-- 
1.7.10.4

