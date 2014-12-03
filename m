Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbaLCLjr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:39:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54625 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752568AbaLCL1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:40 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Joe Schultz <jschultz@xes-inc.com>,
        Aaron Sierra <asierra@xes-inc.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 082/101] vme_tsi148: Fix typo in tsi148_slave_get()
Date: Wed,  3 Dec 2014 12:26:44 +0100
Message-Id: <ff286b4678fd95286afef33e5b740a2e0d5f9983.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Schultz <jschultz@xes-inc.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 098ced8fefe4a4e4240fa47b1ed9b00d65b6cd21 upstream.

This patch corrects a typo where "vme_base" was used instead of
"*vme_base". The typo resulted in an incorrect value being returned
to userspace (via vme_user).

It also removes the following compile warning on some platforms:

warning: cast from pointer to integer of different size

[asierra: commit title/log rewording]
Signed-off-by: Joe Schultz <jschultz@xes-inc.com>
Signed-off-by: Aaron Sierra <asierra@xes-inc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/vme/bridges/vme_tsi148.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vme/bridges/vme_tsi148.c b/drivers/vme/bridges/vme_tsi148.c
index 6783ad0d1875..b92eb181dcda 100644
--- a/drivers/vme/bridges/vme_tsi148.c
+++ b/drivers/vme/bridges/vme_tsi148.c
@@ -741,7 +741,7 @@ static int tsi148_slave_get(struct vme_slave_resource *image, int *enabled,
 	reg_join(vme_bound_high, vme_bound_low, &vme_bound);
 	reg_join(pci_offset_high, pci_offset_low, &pci_offset);
 
-	*pci_base = (dma_addr_t)vme_base + pci_offset;
+	*pci_base = (dma_addr_t)(*vme_base + pci_offset);
 
 	*enabled = 0;
 	*aspace = 0;
-- 
2.1.3

