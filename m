Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598AbaFGKVQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 06:21:16 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:56484 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbaFGKVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 06:21:14 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Geoff Levand <geoff@infradead.org>, netdev@vger.kernel.org
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        cbe-oss-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: ethernet: toshiba: ps3_gelic_net.c:  Cleaning up a check on a memory allocation
Date: Sat,  7 Jun 2014 12:22:08 +0200
Message-Id: <1402136528-16857-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A check on a memory allocation is checked incorrectly.

This was partly found using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/net/ethernet/toshiba/ps3_gelic_net.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
index d899d00..bb79928 100644
--- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
+++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
@@ -1561,7 +1561,7 @@ static struct gelic_card *gelic_alloc_card_net(struct net_device **netdev)
 	 * alloc netdev
 	 */
 	*netdev = alloc_etherdev(sizeof(struct gelic_port));
-	if (!netdev) {
+	if (!*netdev) {
 		kfree(card->unalign);
 		return NULL;
 	}
-- 
1.7.10.4

