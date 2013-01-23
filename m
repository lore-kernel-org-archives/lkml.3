Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab3AWICT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 03:02:19 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:33266 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415Ab3AWICS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 03:02:18 -0500
From: Yijing Wang <wangyijing@huawei.com>
To: Rob Landley <rob@landley.net>, Bjorn Helgaas <bhelgaas@google.com>
CC: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jon Mason <jdmason@kudzu.us>, <linux-pci@vger.kernel.org>,
        Hanjun Guo <guohanjun@huawei.com>, <jiang.liu@huawei.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH] PCI: Document PCIE BUS MPS parameters
Date: Wed, 23 Jan 2013 16:01:36 +0800
Message-ID: <1358928096-29008-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document PCIE BUS MPS parameters pcie_bus_tune_off, pcie_bus_safe,
pcie_bus_peer2peer, pcie_bus_perf into Documentation/kernel-parameters.txt.
These parameters were introduced by Jon Mason <mason@myri.com> at
commit 5f39e6705 and commit b03e7495a8. Document these into 
kernel-parameters.txt help users to understand and use the parameters.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 Documentation/kernel-parameters.txt |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 363e348..4dfa8d2 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2227,6 +2227,19 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 				This sorting is done to get a device
 				order compatible with older (<= 2.4) kernels.
 		nobfsort	Don't sort PCI devices into breadth-first order.
+		pcie_bus_tune_off	[X86] Disable PCI-E MPS turning and using
+				the BIOS configured MPS defaults.
+		pcie_bus_safe	[X86] Use the smallest common denominator MPS
+				of the entire tree below a root complex for every device
+				on that fabric. Can avoid inconsistent mps problem caused
+				by hotplug.
+		pcie_bus_perf	[X86] Configure pcie device MPS to the largest
+				allowable MPS based on its parent bus.Improve performance
+				as much as possible.
+		pcie_bus_peer2peer	[X86] Make the system wide MPS the smallest
+				possible value (128B).This configuration could prevent it
+				from working by having the MPS on one root port different
+				than the MPS on another.
 		cbiosize=nn[KMG]	The fixed amount of bus space which is
 				reserved for the CardBus bridge's IO window.
 				The default value is 256 bytes.
-- 
1.7.1


