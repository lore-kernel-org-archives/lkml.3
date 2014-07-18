Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762636AbaGRP16 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 11:27:58 -0400
Received: from isis.lip6.fr ([132.227.60.2]:55134 "EHLO isis.lip6.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762356AbaGRP0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 11:26:31 -0400
X-pt: isis.lip6.fr
From: Benoit Taine <benoit.taine@lip6.fr>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: benoit.taine@lip6.fr, "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/25] iwlegacy: Replace DEFINE_PCI_DEVICE_TABLE macro use
Date: Fri, 18 Jul 2014 17:26:50 +0200
Message-Id: <1405697232-11785-4-git-send-email-benoit.taine@lip6.fr>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1405697232-11785-1-git-send-email-benoit.taine@lip6.fr>
References: <1405697232-11785-1-git-send-email-benoit.taine@lip6.fr>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.4.3 (isis.lip6.fr [132.227.60.2]); Fri, 18 Jul 2014 17:26:07 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should prefer `struct pci_device_id` over `DEFINE_PCI_DEVICE_TABLE` to meet
kernel coding style guidelines. This issue was reported by checkpatch.

Signed-off-by: Benoit Taine <benoit.taine@lip6.fr>

---
Not tested.

 drivers/net/wireless/iwlegacy/3945.c     |    2 +-
 drivers/net/wireless/iwlegacy/4965-mac.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945.c b/drivers/net/wireless/iwlegacy/3945.c
index b598e28..93bdf68 100644
--- a/drivers/net/wireless/iwlegacy/3945.c
+++ b/drivers/net/wireless/iwlegacy/3945.c
@@ -2728,7 +2728,7 @@ static struct il_cfg il3945_abg_cfg = {
 	},
 };
 
-DEFINE_PCI_DEVICE_TABLE(il3945_hw_card_ids) = {
+const struct pci_device_id il3945_hw_card_ids[] = {
 	{IL_PCI_DEVICE(0x4222, 0x1005, il3945_bg_cfg)},
 	{IL_PCI_DEVICE(0x4222, 0x1034, il3945_bg_cfg)},
 	{IL_PCI_DEVICE(0x4222, 0x1044, il3945_bg_cfg)},
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index c159c05..3dcbe2c 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -6800,7 +6800,7 @@ il4965_txq_set_sched(struct il_priv *il, u32 mask)
  *****************************************************************************/
 
 /* Hardware specific file defines the PCI IDs table for that hardware module */
-static DEFINE_PCI_DEVICE_TABLE(il4965_hw_card_ids) = {
+static const struct pci_device_id il4965_hw_card_ids[] = {
 	{IL_PCI_DEVICE(0x4229, PCI_ANY_ID, il4965_cfg)},
 	{IL_PCI_DEVICE(0x4230, PCI_ANY_ID, il4965_cfg)},
 	{0}

