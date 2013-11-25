Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940Ab3KYNyO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:54:14 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58951 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754274Ab3KYNxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:53:43 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        "Francois Romieu" <romieu@fr.zoreil.com>,
        "David Woodhouse" <dwmw2@infradead.org>,
        "David Woodhouse" <David.Woodhouse@intel.com>
Date: Mon, 25 Nov 2013 13:44:29 +0000
Message-ID: <lsq.1385387069.867476767@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 32/87] 8139cp: re-enable interrupts after tx timeout
In-Reply-To: <lsq.1385387069.559528559@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.212
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.53-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: David Woodhouse <dwmw2@infradead.org>

commit 01ffc0a7f1c1801a2354719dedbc32aff45b987d upstream.

Recovery doesn't work too well if we leave interrupts disabled...

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Acked-by: Francois Romieu <romieu@fr.zoreil.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/realtek/8139cp.c | 1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/realtek/8139cp.c
+++ b/drivers/net/ethernet/realtek/8139cp.c
@@ -1234,6 +1234,7 @@ static void cp_tx_timeout(struct net_dev
 	cp_clean_rings(cp);
 	rc = cp_init_rings(cp);
 	cp_start_hw(cp);
+	cp_enable_irq(cp);
 
 	netif_wake_queue(dev);
 

