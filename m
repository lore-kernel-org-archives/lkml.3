Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759198Ab3HMUU2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 16:20:28 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:13014 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759180Ab3HMUU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 16:20:27 -0400
Message-ID: <201308132020.r7DKKQw9022749@farm-0021.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Tue, 13 Aug 2013 15:17:38 -0400
Subject: [PATCH] tile: mark pcibios_init() as __init
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was bombed away because it was previously marked as __devinit,
but it should be an __init function.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/pci.c    | 2 +-
 arch/tile/kernel/pci_gx.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/tile/kernel/pci.c b/arch/tile/kernel/pci.c
index af75835..b7180e6 100644
--- a/arch/tile/kernel/pci.c
+++ b/arch/tile/kernel/pci.c
@@ -386,7 +386,7 @@ void pcibios_set_master(struct pci_dev *dev)
 }
 
 /* Process any "pci=" kernel boot arguments. */
-char * __init pcibios_setup(char *str)
+char *__init pcibios_setup(char *str)
 {
 	if (!strcmp(str, "off")) {
 		pci_probe = 0;
diff --git a/arch/tile/kernel/pci_gx.c b/arch/tile/kernel/pci_gx.c
index 4843881..66ef9db 100644
--- a/arch/tile/kernel/pci_gx.c
+++ b/arch/tile/kernel/pci_gx.c
@@ -1060,7 +1060,7 @@ void pcibios_fixup_bus(struct pci_bus *bus)
 }
 
 /* Process any "pci=" kernel boot arguments. */
-char *pcibios_setup(char *str)
+char *__init pcibios_setup(char *str)
 {
 	if (!strcmp(str, "off")) {
 		pci_probe = 0;
-- 
1.8.3.1

