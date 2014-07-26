Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914AbaGZTyP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:54:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34120 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299AbaGZTNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:13:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Fitzsimmons <fitzsim@fitzsim.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 52/87] net: mvneta: Fix big endian issue in mvneta_txq_desc_csum()
Date: Sat, 26 Jul 2014 12:02:26 -0700
Message-Id: <20140726190216.303243070@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190214.530473925@linuxfoundation.org>
References: <20140726190214.530473925@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Fitzsimmons <fitzsim@fitzsim.org>

[ Upstream commit 0a1985879437d14bda8c90d0dae3455c467d7642 ]

This commit fixes the command value generated for CSUM calculation
when running in big endian mode.  The Ethernet protocol ID for IP was
being unconditionally byte-swapped in the layer 3 protocol check (with
swab16), which caused the mvneta driver to not function correctly in
big endian mode.  This patch byte-swaps the ID conditionally with
htons.

Cc: <stable@vger.kernel.org> # v3.13+
Signed-off-by: Thomas Fitzsimmons <fitzsim@fitzsim.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/mvneta.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -1217,7 +1217,7 @@ static u32 mvneta_txq_desc_csum(int l3_o
 	command =  l3_offs    << MVNETA_TX_L3_OFF_SHIFT;
 	command |= ip_hdr_len << MVNETA_TX_IP_HLEN_SHIFT;
 
-	if (l3_proto == swab16(ETH_P_IP))
+	if (l3_proto == htons(ETH_P_IP))
 		command |= MVNETA_TXD_IP_CSUM;
 	else
 		command |= MVNETA_TX_L3_IP6;


