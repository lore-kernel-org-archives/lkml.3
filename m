Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857Ab3LNMaf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 07:30:35 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:48286 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab3LNMae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 07:30:34 -0500
Date: Sat, 14 Dec 2013 18:00:25 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        josh@joshtriplett.org
Subject: [PATCH v2 8/9] drivers: net: Mark functions as static in debug.c
Message-ID: <f72a822c9171b17d2d51a221820e30d0ca1ecd36.1386911124.git.rashika.kheria@gmail.com>
References: <a610f6ee6bb992b91e43bdc851f3db62fc3decd5.1386911123.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a610f6ee6bb992b91e43bdc851f3db62fc3decd5.1386911123.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch marks the function il_clear_traffic_stats() in debug.c as
static because they are not used outside this file.

Thus, it also removes the following warnings in
wireless/iwlegacy/debug.c:

drivers/net/wireless/iwlegacy/debug.c:35:1: warning: no previous prototype for ‘il_clear_traffic_stats’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/net/wireless/iwlegacy/debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlegacy/debug.c b/drivers/net/wireless/iwlegacy/debug.c
index eff2650..b7e03dd 100644
--- a/drivers/net/wireless/iwlegacy/debug.c
+++ b/drivers/net/wireless/iwlegacy/debug.c
@@ -31,7 +31,7 @@
 
 #include "common.h"
 
-void
+static void
 il_clear_traffic_stats(struct il_priv *il)
 {
 	memset(&il->tx_stats, 0, sizeof(struct traffic_stats));
-- 
1.7.9.5

