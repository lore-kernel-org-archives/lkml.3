Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab3LSIzv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 03:55:51 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:48535 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610Ab3LSIzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 03:55:48 -0500
From: Rashika Kheria <rashika.kheria@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, josh@joshtriplett.org
Subject: =?UTF-8?q?=5BPATCH=20v3=207/8=5D=20drivers=3A=20net=3A=20Mark=20functions=20as=20static=20in=20debug=2Ec?=
Date: Thu, 19 Dec 2013 14:25:34 +0530
Message-Id: <8e5f8e06430a9d822c4d5a1a3a7a3454eb75281c.1387382457.git.rashika.kheria@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <04fe932bc3585620c91d511bb0894e45bb762ffa.1387382457.git.rashika.kheria@gmail.com>
References: <04fe932bc3585620c91d511bb0894e45bb762ffa.1387382457.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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

