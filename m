Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020AbaHLMQX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 08:16:23 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:32890 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbaHLMQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 08:16:21 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: perex@perex.cz, tiwai@suse.de
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] sound: pci: es1968: use pci_device_id
Date: Tue, 12 Aug 2014 17:45:40 +0530
Message-Id: <1407845740-3524-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uses the struct pci_device_id instead of the depreciated macro DEFINE_PCI_DEVICE_TABLE.


Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 sound/pci/es1968.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/es1968.c b/sound/pci/es1968.c
index 5bb1cf6..a9956a7 100644
--- a/sound/pci/es1968.c
+++ b/sound/pci/es1968.c
@@ -570,7 +570,7 @@ struct es1968 {
 
 static irqreturn_t snd_es1968_interrupt(int irq, void *dev_id);
 
-static DEFINE_PCI_DEVICE_TABLE(snd_es1968_ids) = {
+static const struct pci_device_id snd_es1968_ids[] = {
 	/* Maestro 1 */
         { 0x1285, 0x0100, PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_MULTIMEDIA_AUDIO << 8, 0xffff00, TYPE_MAESTRO },
 	/* Maestro 2 */
-- 
1.8.1.2

