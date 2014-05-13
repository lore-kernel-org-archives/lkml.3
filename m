Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbaEMUsW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 16:48:22 -0400
Received: from mout.gmx.net ([212.227.15.15]:64280 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234AbaEMUsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 16:48:08 -0400
From: Christian Engelmayer <cengelma@gmx.at>
To: linux-kernel@vger.kernel.org
Cc: haver@linux.vnet.ibm.com, gregkh@linuxfoundation.org,
        Christian Engelmayer <cengelma@gmx.at>
Subject: [PATCH] misc: genwqe: fix uninitialized return value in genwqe_free_sync_sgl()
Date: Tue, 13 May 2014 22:47:03 +0200
Message-Id: <1400014023-7570-1-git-send-email-cengelma@gmx.at>
X-Mailer: git-send-email 1.9.1
X-Provags-ID: V03:K0:0ZaWewM8gK1KCIK+VBuQkcGIJEPRrudPLzxL/hLgbQnh91QvfDD
 s1x5Ofw4h8wctLdIzgI+Cld9z2PE7r4Z2z2TbJgC8M6cSZ2j07t86t9A/X81RHqVwAOaTCQ
 lLlxB0GXcQe5JlJt+H7IAY6/b6IoBXq4XuoaoPwAxXG+TkZV7sxB8ozjDlvcVi8PnugC+zV
 N2BGTtowMJJdTMKDwiBwQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function genwqe_free_sync_sgl() returns the value of variable 'rc'. 'rc' is
only set in the error paths, thus initialize it by 0. Coverity CID 1204242.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
Compile tested and applies against branch char-misc-next of tree
git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
---
 drivers/misc/genwqe/card_utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/genwqe/card_utils.c b/drivers/misc/genwqe/card_utils.c
index d049d27..5babf40 100644
--- a/drivers/misc/genwqe/card_utils.c
+++ b/drivers/misc/genwqe/card_utils.c
@@ -454,7 +454,7 @@ int genwqe_setup_sgl(struct genwqe_dev *cd, struct genwqe_sgl *sgl,
  */
 int genwqe_free_sync_sgl(struct genwqe_dev *cd, struct genwqe_sgl *sgl)
 {
-	int rc;
+	int rc = 0;
 	struct pci_dev *pci_dev = cd->pci_dev;
 
 	if (sgl->fpage) {
-- 
1.9.1

