Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933601Ab3DBWOA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:14:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33322 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933538Ab3DBWNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:13:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Veaceslav Falico <vfalico@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 123/124] pch_gbe: fix ip_summed checksum reporting on rx
Date: Tue,  2 Apr 2013 15:11:45 -0700
Message-Id: <20130402221118.456674273@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221104.163133110@linuxfoundation.org>
References: <20130402221104.163133110@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Veaceslav Falico <vfalico@redhat.com>

[ Upstream commit 76a0e68129d7d24eb995a6871ab47081bbfa0acc ]

skb->ip_summed should be CHECKSUM_UNNECESSARY when the driver reports that
checksums were correct and CHECKSUM_NONE in any other case. They're
currently placed vice versa, which breaks the forwarding scenario. Fix it
by placing them as described above.

Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
@@ -1726,9 +1726,9 @@ pch_gbe_clean_rx(struct pch_gbe_adapter
 
 			skb->protocol = eth_type_trans(skb, netdev);
 			if (tcp_ip_status & PCH_GBE_RXD_ACC_STAT_TCPIPOK)
-				skb->ip_summed = CHECKSUM_NONE;
-			else
 				skb->ip_summed = CHECKSUM_UNNECESSARY;
+			else
+				skb->ip_summed = CHECKSUM_NONE;
 
 			napi_gro_receive(&adapter->napi, skb);
 			(*work_done)++;


