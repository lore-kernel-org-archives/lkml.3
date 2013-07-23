Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934391Ab3GWWiN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:38:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41804 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934783Ab3GWW1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:27:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>,
        Jonghwan Choi <jhbird.choi@gmail.com>
Subject: [ 077/103] of: Fix address decoding on Bimini and js2x machines
Date: Tue, 23 Jul 2013 15:26:28 -0700
Message-Id: <20130723220428.466056522@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130723220418.532514378@linuxfoundation.org>
References: <20130723220418.532514378@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Jonghwan Choi <jhbird.choi@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/of/address.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -106,8 +106,12 @@ static unsigned int of_bus_default_get_f
 
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


