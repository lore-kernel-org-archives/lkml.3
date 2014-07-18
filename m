Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762280AbaGRP0U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 11:26:20 -0400
Received: from isis.lip6.fr ([132.227.60.2]:55212 "EHLO isis.lip6.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762220AbaGRP0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 11:26:17 -0400
X-pt: isis.lip6.fr
From: Benoit Taine <benoit.taine@lip6.fr>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: benoit.taine@lip6.fr, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/25] x86: Replace DEFINE_PCI_DEVICE_TABLE macro use
Date: Fri, 18 Jul 2014 17:26:53 +0200
Message-Id: <1405697232-11785-7-git-send-email-benoit.taine@lip6.fr>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1405697232-11785-1-git-send-email-benoit.taine@lip6.fr>
References: <1405697232-11785-1-git-send-email-benoit.taine@lip6.fr>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.4.3 (isis.lip6.fr [132.227.60.2]); Fri, 18 Jul 2014 17:26:08 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should prefer `struct pci_device_id` over `DEFINE_PCI_DEVICE_TABLE` to meet
kernel coding style guidelines. This issue was reported by checkpatch.

Signed-off-by: Benoit Taine <benoit.taine@lip6.fr>

---
Tested by compilation without errors.

 drivers/platform/x86/intel_ips.c     |    2 +-
 drivers/platform/x86/intel_scu_ipc.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/intel_ips.c b/drivers/platform/x86/intel_ips.c
index 18dcb58..a0d1f57 100644
--- a/drivers/platform/x86/intel_ips.c
+++ b/drivers/platform/x86/intel_ips.c
@@ -1478,7 +1478,7 @@ ips_link_to_i915_driver(void)
 }
 EXPORT_SYMBOL_GPL(ips_link_to_i915_driver);
 
-static DEFINE_PCI_DEVICE_TABLE(ips_id_table) = {
+static const struct pci_device_id ips_id_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL,
 		     PCI_DEVICE_ID_INTEL_THERMAL_SENSOR), },
 	{ 0, }
diff --git a/drivers/platform/x86/intel_scu_ipc.c b/drivers/platform/x86/intel_scu_ipc.c
index 76ca094..66a4d32 100644
--- a/drivers/platform/x86/intel_scu_ipc.c
+++ b/drivers/platform/x86/intel_scu_ipc.c
@@ -640,7 +640,7 @@ static void ipc_remove(struct pci_dev *pdev)
 	intel_scu_devices_destroy();
 }
 
-static DEFINE_PCI_DEVICE_TABLE(pci_ids) = {
+static const struct pci_device_id pci_ids[] = {
 	{
 		PCI_VDEVICE(INTEL, PCI_DEVICE_ID_LINCROFT),
 		(kernel_ulong_t)&intel_scu_ipc_lincroft_pdata,

