Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab3LBTSO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:18:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39247 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625Ab3LBTRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:17:45 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.12 081/212] rt2400pci: fix RSSI read
Date: Mon,  2 Dec 2013 11:14:32 -0800
Message-Id: <20131202191256.758480392@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <stf_xl@wp.pl>

commit 2bf127a5cc372b9319afcbae10b090663b621c8b upstream.

RSSI value is provided on word3 not on word2.

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rt2x00/rt2400pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1261,7 +1261,7 @@ static void rt2400pci_fill_rxdone(struct
 	 */
 	rxdesc->timestamp = ((u64)rx_high << 32) | rx_low;
 	rxdesc->signal = rt2x00_get_field32(word2, RXD_W2_SIGNAL) & ~0x08;
-	rxdesc->rssi = rt2x00_get_field32(word2, RXD_W3_RSSI) -
+	rxdesc->rssi = rt2x00_get_field32(word3, RXD_W3_RSSI) -
 	    entry->queue->rt2x00dev->rssi_offset;
 	rxdesc->size = rt2x00_get_field32(word0, RXD_W0_DATABYTE_COUNT);
 


