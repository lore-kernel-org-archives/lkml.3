Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222AbaCaAWD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 20:22:03 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36323 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752967AbaC3XZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:25:00 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Rob Herring" <robh@kernel.org>,
        "Kleber Sacilotto de Souza" <klebers@linux.vnet.ibm.com>,
        "Grant Likely" <grant.likely@linaro.org>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.494146005@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 083/200] of: fix PCI bus match for PCIe slots
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/of/address.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -98,11 +98,12 @@ static unsigned int of_bus_default_get_f
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

