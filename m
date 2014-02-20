Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112AbaBUAke (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 19:40:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45680 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481AbaBTXwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:52:02 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>,
        Grant Likely <grant.likely@linaro.org>, Rob Herring <robh@kernel.org>
Subject: [PATCH 3.12 23/82] of: fix PCI bus match for PCIe slots
Date: Thu, 20 Feb 2014 15:52:06 -0800
Message-Id: <20140220235020.174282354@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140220235019.483734207@linuxfoundation.org>
References: <20140220235019.483734207@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/of/address.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -99,11 +99,12 @@ static unsigned int of_bus_default_get_f
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


