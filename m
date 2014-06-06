Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751541AbaFFL5S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 07:57:18 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:51531 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaFFL5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 07:57:14 -0400
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: grant.likely@linaro.org, Magnus Damm <magnus.damm@gmail.com>,
        robh+dt@kernel.org
Date: Fri, 06 Jun 2014 20:59:18 +0900
Message-Id: <20140606115918.4584.2306.sendpatchset@w520>
In-Reply-To: <20140606115909.4584.28612.sendpatchset@w520>
References: <20140606115909.4584.28612.sendpatchset@w520>
Subject: [PATCH 01/02] of: Add OF_ADDRESS=n stub for of_can_translate_address()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm+renesas@opensource.se>

Add a stub for the CONFIG_OF_ADDRESS=n case of 
of_translate_address(). The return value for the
stub is false which is in sync with when the full
version of the function does not support address
translation. Added to allow removal of Kconfig
dependency handling for CONFIG_OF_ADDRESS.

Signed-off-by: Magnus Damm <damm+renesas@opensource.se>
---

 include/linux/of_address.h |    5 +++++
 1 file changed, 5 insertions(+)

--- 0001/include/linux/of_address.h
+++ work/include/linux/of_address.h	2014-06-06 19:04:44.000000000 +0900
@@ -64,6 +64,11 @@ extern struct of_pci_range *of_pci_range
 					struct of_pci_range_parser *parser,
 					struct of_pci_range *range);
 #else /* CONFIG_OF_ADDRESS */
+static inline bool of_can_translate_address(struct device_node *dev)
+{
+	return false;
+}
+
 static inline struct device_node *of_find_matching_node_by_address(
 					struct device_node *from,
 					const struct of_device_id *matches,
