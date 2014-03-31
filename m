Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703AbaCaN2k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 09:28:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35859 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754418AbaCaNY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 09:24:59 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>,
        Rob Herring <robh@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 66/71] of: fix PCI bus match for PCIe slots
Date: Mon, 31 Mar 2014 14:23:12 +0100
Message-Id: <1396272197-13394-67-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
References: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.33 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>

commit 14e2abb732e485ee57d9d5b2cb8884652238e5c1 upstream.

On IBM pseries systems the device_type device-tree property of a PCIe
bridge contains the string "pciex". The of_bus_pci_match() function was
looking only for "pci" on this property, so in such cases the bus
matching code was falling back to the default bus, causing problems on
functions that should be using "assigned-addresses" for region address
translation. This patch fixes the problem by also looking for "pciex" on
the PCI bus match function.

v2: added comment

Signed-off-by: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
Acked-by: Grant Likely <grant.likely@linaro.org>
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/of/address.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/of/address.c b/drivers/of/address.c
index 8bd5127..3edc6dd 100644
--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -99,11 +99,12 @@ static unsigned int of_bus_default_get_flags(const __be32 *addr)
 static int of_bus_pci_match(struct device_node *np)
 {
 	/*
+ 	 * "pciex" is PCI Express
 	 * "vci" is for the /chaos bridge on 1st-gen PCI powermacs
 	 * "ht" is hypertransport
 	 */
-	return !strcmp(np->type, "pci") || !strcmp(np->type, "vci") ||
-		!strcmp(np->type, "ht");
+	return !strcmp(np->type, "pci") || !strcmp(np->type, "pciex") ||
+		!strcmp(np->type, "vci") || !strcmp(np->type, "ht");
 }
 
 static void of_bus_pci_count_cells(struct device_node *np,
-- 
1.9.1

