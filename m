Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172AbaCCS6d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 13:58:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:56051 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755155AbaCCS6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 13:58:30 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Grant Likely <grant.likely@linaro.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 35/67] of: Fix address decoding on Bimini and js2x machines
Date: Mon,  3 Mar 2014 10:55:23 -0800
Message-Id: <1393872955-28810-36-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393872955-28810-1-git-send-email-kamal@canonical.com>
References: <1393872955-28810-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.19 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/of/address.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/of/address.c b/drivers/of/address.c
index fb2a4e8..d61fdae 100644
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
1.8.3.2

