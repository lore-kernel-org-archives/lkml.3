Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab3KYNLP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:11:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57364 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023Ab3KYNJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:09:18 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Woodhouse <David.Woodhouse@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Nathan Williams <nathan@traverse.com.au>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 75/78] 8139cp: re-enable interrupts after tx timeout
Date: Mon, 25 Nov 2013 13:07:02 +0000
Message-Id: <1385384825-21681-76-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
References: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.26 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Woodhouse <dwmw2@infradead.org>

commit 01ffc0a7f1c1801a2354719dedbc32aff45b987d upstream.

Recovery doesn't work too well if we leave interrupts disabled...

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Acked-by: Francois Romieu <romieu@fr.zoreil.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Nathan Williams <nathan@traverse.com.au>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/realtek/8139cp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/realtek/8139cp.c b/drivers/net/ethernet/realtek/8139cp.c
index efd3e34..9ac8801 100644
--- a/drivers/net/ethernet/realtek/8139cp.c
+++ b/drivers/net/ethernet/realtek/8139cp.c
@@ -1252,6 +1252,7 @@ static void cp_tx_timeout(struct net_device *dev)
 	cp_clean_rings(cp);
 	rc = cp_init_rings(cp);
 	cp_start_hw(cp);
+	cp_enable_irq(cp);
 
 	netif_wake_queue(dev);
 
-- 
1.8.3.2

