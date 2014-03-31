Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbaCaN3g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 09:29:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35853 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397AbaCaNY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 09:24:57 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Grant Likely <grant.likely@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 65/71] of: Fix address decoding on Bimini and js2x machines
Date: Mon, 31 Mar 2014 14:23:11 +0100
Message-Id: <1396272197-13394-66-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
References: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.33 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

commit 6dd18e4684f3d188277bbbc27545248487472108 upstream.

 Commit:

  e38c0a1fbc5803cbacdaac0557c70ac8ca5152e7
  of/address: Handle #address-cells > 2 specially

broke real time clock access on Bimini, js2x, and similar powerpc
machines using the "maple" platform. That code was indirectly relying
on the old (broken) behaviour of the translation for the hypertransport
to ISA bridge.

This fixes it by treating hypertransport as a PCI bus

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-by: Rob Herring <rob.herring@calxeda.com>
Signed-off-by: Grant Likely <grant.likely@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/of/address.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/of/address.c b/drivers/of/address.c
index 7e262a6..8bd5127 100644
--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -98,8 +98,12 @@ static unsigned int of_bus_default_get_flags(const __be32 *addr)
 
 static int of_bus_pci_match(struct device_node *np)
 {
-	/* "vci" is for the /chaos bridge on 1st-gen PCI powermacs */
-	return !strcmp(np->type, "pci") || !strcmp(np->type, "vci");
+	/*
+	 * "vci" is for the /chaos bridge on 1st-gen PCI powermacs
+	 * "ht" is hypertransport
+	 */
+	return !strcmp(np->type, "pci") || !strcmp(np->type, "vci") ||
+		!strcmp(np->type, "ht");
 }
 
 static void of_bus_pci_count_cells(struct device_node *np,
-- 
1.9.1

