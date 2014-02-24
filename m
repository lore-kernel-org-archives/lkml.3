Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbaBXUFF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 15:05:05 -0500
Received: from e24smtp05.br.ibm.com ([32.104.18.26]:49896 "EHLO
	e24smtp05.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873AbaBXUFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 15:05:02 -0500
From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
To: netdev@vger.kernel.org
Cc: dm@chelsio.com, davem@davemloft.net, linux-kernel@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Subject: [PATCH] net/cxgb4: use remove handler as shutdown handler
Date: Mon, 24 Feb 2014 17:04:52 -0300
Message-Id: <1393272292-11268-1-git-send-email-cascardo@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022420-1798-0000-0000-000001CF5E28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without a shutdown handler, T4 cards behave very badly after a kexec.
Some firmware calls return errors indicating allocation failures, for
example. This is probably because thouse resources were not released by
a BYE message to the firmware, for example.

Using the remove handler guarantees we will use a well tested path.

With this patch I applied, I managed to use kexec multiple times and
probe and iSCSI login worked every time.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 43ab35f..34e2488 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -6179,6 +6179,7 @@ static struct pci_driver cxgb4_driver = {
 	.id_table = cxgb4_pci_tbl,
 	.probe    = init_one,
 	.remove   = remove_one,
+	.shutdown = remove_one,
 	.err_handler = &cxgb4_eeh,
 };
 
-- 
1.7.1

