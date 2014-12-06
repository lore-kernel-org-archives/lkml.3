Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761AbaLFPSH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 10:18:07 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:47767 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752250AbaLFPIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 10:08:10 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 30/66] powerpc/pseries: Honor the generic "no_64bit_msi" flag
Date: Sat,  6 Dec 2014 16:07:22 +0100
Message-Id: <61a926913b3d5ea35d69d4f0a9c5c0e068abe72c.1417878427.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
References: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
In-Reply-To: <cover.1417878427.git.jslaby@suse.cz>
References: <cover.1417878427.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 415072a041bf50dbd6d56934ffc0cbbe14c97be8 upstream.

Instead of the arch specific quirk which we are deprecating

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/powerpc/platforms/pseries/msi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/pseries/msi.c b/arch/powerpc/platforms/pseries/msi.c
index 6d2f0abce6fa..3b350fb91285 100644
--- a/arch/powerpc/platforms/pseries/msi.c
+++ b/arch/powerpc/platforms/pseries/msi.c
@@ -426,7 +426,7 @@ static int rtas_setup_msi_irqs(struct pci_dev *pdev, int nvec_in, int type)
 	 */
 again:
 	if (type == PCI_CAP_ID_MSI) {
-		if (pdn->force_32bit_msi) {
+		if (pdev->no_64bit_msi) {
 			rc = rtas_change_msi(pdn, RTAS_CHANGE_32MSI_FN, nvec);
 			if (rc < 0) {
 				/*
-- 
2.1.3

