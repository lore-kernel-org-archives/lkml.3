Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759841Ab3K0CF7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 21:05:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38818 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220Ab3K0A4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:56:46 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Woodhouse <David.Woodhouse@intel.com>,
        Francois Romieu <romieu@fr.zoreil.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.4 12/39] 8139cp: re-enable interrupts after tx timeout
Date: Tue, 26 Nov 2013 16:56:36 -0800
Message-Id: <20131127005619.897122799@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005619.011763867@linuxfoundation.org>
References: <20131127005619.011763867@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Woodhouse <dwmw2@infradead.org>

commit 01ffc0a7f1c1801a2354719dedbc32aff45b987d upstream.

Recovery doesn't work too well if we leave interrupts disabled...

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Acked-by: Francois Romieu <romieu@fr.zoreil.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Luis Henriques <luis.henriques@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/realtek/8139cp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/realtek/8139cp.c
+++ b/drivers/net/ethernet/realtek/8139cp.c
@@ -1232,6 +1232,7 @@ static void cp_tx_timeout(struct net_dev
 	cp_clean_rings(cp);
 	rc = cp_init_rings(cp);
 	cp_start_hw(cp);
+	cp_enable_irq(cp);
 
 	netif_wake_queue(dev);
 


