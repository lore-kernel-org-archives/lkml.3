Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162680Ab3LFNtX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:49:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44118 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757664Ab3LFNCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:02:11 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stanislaw Gruszka <stf_xl@wp.pl>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 118/272] rt2400pci: fix RSSI read
Date: Fri,  6 Dec 2013 12:56:47 +0000
Message-Id: <1386334761-25517-119-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <stf_xl@wp.pl>

commit 2bf127a5cc372b9319afcbae10b090663b621c8b upstream.

RSSI value is provided on word3 not on word2.

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 3d53a09..38ed9a3 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1261,7 +1261,7 @@ static void rt2400pci_fill_rxdone(struct queue_entry *entry,
 	 */
 	rxdesc->timestamp = ((u64)rx_high << 32) | rx_low;
 	rxdesc->signal = rt2x00_get_field32(word2, RXD_W2_SIGNAL) & ~0x08;
-	rxdesc->rssi = rt2x00_get_field32(word2, RXD_W3_RSSI) -
+	rxdesc->rssi = rt2x00_get_field32(word3, RXD_W3_RSSI) -
 	    entry->queue->rt2x00dev->rssi_offset;
 	rxdesc->size = rt2x00_get_field32(word0, RXD_W0_DATABYTE_COUNT);
 
-- 
1.8.3.2

